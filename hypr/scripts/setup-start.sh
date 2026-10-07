#!/bin/bash
set -u
set -o pipefail
umask 077

# Timestamp diagnostics from helpers and applications as well as phase messages.
exec > >(while IFS= read -r line; do
    printf '[%(%F %T)T] %s\n' -1 "$line" >> /tmp/setup-start.log
done) 2>&1
log() { printf '%s\n' "$*" >&2; }
run() { "$@" || { log "FAILED: $*"; return 1; }; }
exec 9>/tmp/setup-start.lock
if ! flock -n 9; then log 'Another setup run is active; skipping.'; exit 0; fi

apps=ok
terminal=skipped
lyrics=skipped
finish=failed
spotify_fresh=0

addresses() {
    local clients needle=${1,,}
    clients=$(hyprctl clients -j) || { log 'Cannot read Hyprland clients'; return 1; }
    # Substring match: Wayland app_id classes differ from the binary name
    # (e.g. ghostty reports com.mitchellh.ghostty, evince reports org.gnome.Evince).
    jq -r --arg needle "$needle" '.[] | select((.class | ascii_downcase) | contains($needle)) | .address' <<< "$clients"
}

place_app() {
    local class=$1 workspace=$2 windows address attempt
    shift 2
    windows=$(addresses "$class") || return 1
    if [[ -z $windows ]]; then
        command -v "$1" >/dev/null || { log "Missing application: $1"; return 1; }
        log "Launching $class for workspace $workspace"
        # Do not let long-lived application processes retain the setup lock.
        "$@" >/dev/null 2>&1 9>&- </dev/null &
        [[ $class == spotify ]] && spotify_fresh=1
        for ((attempt=0; attempt<40; attempt++)); do
            windows=$(addresses "$class") || return 1
            [[ -n $windows ]] && break
            sleep 0.5
        done
        [[ -n $windows ]] || { log "Timed out waiting for $class"; return 1; }
    else
        log "Reusing $class"
    fi
    while IFS= read -r address; do
        run hyprctl dispatch movetoworkspacesilent "$workspace,address:$address" || return 1
    done <<< "$windows"
}

log 'Phase 1: launch and place applications'
if command -v hyprctl >/dev/null && command -v jq >/dev/null; then
    # Match needle "zen" so both "zen" and "zen-browser" class spellings hit.
    place_app zen 1 zen-browser || apps=partial
    place_app ghostty 2 ghostty -e tmux new-session -A -s Workflow || apps=partial
    place_app spotify 3 spotify --ozone-platform=wayland \
        --remote-debugging-port=9222 --remote-debugging-address=127.0.0.1 \
        --remote-allow-origins=http://127.0.0.1:9222 || apps=partial
    if [[ -f $HOME/books/HP-Books/HP-6.pdf ]]; then
        place_app evince 5 evince "$HOME/books/HP-Books/HP-6.pdf" || apps=partial
    else
        log 'WARNING: HP-6.pdf is missing; skipping Evince'
        apps=partial
    fi
else
    log 'Missing hyprctl or jq; skipping application placement'
    apps=skipped
fi

setup_tmux() {
    local attempt sessions session windows index name cli_index='' first_index destination
    command -v tmux >/dev/null || { log 'tmux is absent'; return 1; }
    for ((attempt=0; attempt<30; attempt++)); do
        if tmux list-sessions >/dev/null 2>&1; then break; fi
        sleep 0.5
    done
    if ! sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null); then
        log 'tmux server timed out; creating detached Workflow (existing Ghostty needs manual attachment)'
        run tmux new-session -d -s Workflow || return 1
        sessions=Workflow
    fi
    if ! tmux has-session -t '=Workflow' 2>/dev/null; then
        if [[ $sessions == 0 ]]; then
            run tmux rename-session -t '=0' Workflow || return 1
            sessions=Workflow
        else
            run tmux new-session -d -s Workflow || return 1
        fi
    fi
    # The requested one-session layout discards sessions other than Workflow.
    while IFS= read -r session; do
        if [[ $session != Workflow ]]; then
            log "Removing extra tmux session: $session"
            run tmux kill-session -t "=$session" || return 1
        fi
    done <<< "$sessions"
    # Match the repository layout: first window (ov) is index 1, second (cli) is index 2.
    run tmux set-option -t Workflow base-index 1 || return 1
    run tmux set-option -t Workflow renumber-windows on || return 1
    windows=$(tmux list-windows -t Workflow -F '#{window_index} #{window_name}') || return 1
    read -r first_index name <<< "$windows"
    if [[ $first_index != 1 ]]; then
        run tmux move-window -k -s "Workflow:$first_index" -t Workflow:1 || return 1
    fi
    run tmux rename-window -t Workflow:1 ov || return 1
    windows=$(tmux list-windows -t Workflow -F '#{window_index} #{window_name}') || return 1
    while read -r index name; do
        if [[ $index != 1 && $name == cli ]]; then cli_index=$index; break; fi
    done <<< "$windows"
    if [[ -z $cli_index ]]; then
        run tmux new-window -d -a -t Workflow:1 -n cli || return 1
    elif [[ $cli_index != 2 ]]; then
        run tmux move-window -k -s "Workflow:$cli_index" -t Workflow:2 || return 1
    fi
    windows=$(tmux list-windows -t Workflow -F '#{window_index} #{window_name}') || return 1
    while read -r index name; do
        if [[ $index != 1 && $index != 2 ]]; then
            log "Removing extra tmux window: $index $name"
            run tmux kill-window -t "Workflow:$index" || return 1
        fi
    done <<< "$windows"
    run tmux set-window-option -t Workflow:1 automatic-rename off || return 1
    run tmux set-window-option -t Workflow:2 automatic-rename off || return 1
    if command -v zoxide >/dev/null; then
        run zoxide add "$HOME/dotfiles" || return 1
        if [[ -d $HOME/dotfiles/nvim/lua/custom ]]; then
            run zoxide add "$HOME/dotfiles/nvim/lua/custom" || return 1
        else
            log 'WARNING: nvim/lua/custom is missing; skipping its zoxide seed'
        fi
    else
        log 'zoxide is absent; skipping seeds (cd aliases may not work)'
    fi
    sleep 1
    # Never inject shell commands into an existing editor or foreground program.
    for name in ov cli; do
        local pane shell
        pane=$(tmux display-message -p -t "Workflow:$name" '#{pane_id}') || return 1
        shell=$(tmux display-message -p -t "$pane" '#{pane_current_command}') || return 1
        if [[ $shell != zsh ]]; then
            log "WARNING: $name is running $shell; leaving its input untouched"
            terminal=partial
            continue
        fi
        [[ $name == ov ]] && destination=cus || destination=dot
        run tmux send-keys -t "$pane" C-u || return 1
        run tmux send-keys -t "$pane" -l "cd $destination" || return 1
        run tmux send-keys -t "$pane" Enter || return 1
        sleep 1.5
        run tmux send-keys -t "$pane" -l cls || return 1
        run tmux send-keys -t "$pane" Enter || return 1
    done
    run tmux select-window -t Workflow:1 || return 1
    sessions=$(tmux list-sessions -F '#{session_name}') || return 1
    windows=$(tmux list-windows -t Workflow -F '#{window_index} #{window_name}') || return 1
    if [[ $sessions != Workflow || $windows != $'1 ov\n2 cli' ]]; then
        log "tmux verification failed: sessions=$sessions; windows=$windows"; return 1
    fi
    log 'tmux verified: exactly Workflow with 1 ov and 2 cli'
}

log 'Phase 2: normalize tmux'
terminal=ok
setup_tmux || terminal=failed

cdp_eval() {
    local request response
    request=$(jq -cn --arg expression "$1" \
        '{id:1,method:"Runtime.evaluate",params:{expression:$expression,returnByValue:true,userGesture:true}}') || return 1
    if command -v websocat >/dev/null; then
        response=$(printf '%s\n' "$request" | timeout 4 websocat -t -1 -n \
            --origin http://127.0.0.1:9222 "$cdp_url") || { log 'CDP transport failed (websocat)'; return 1; }
    else
        response=$(cdp_eval_py "$request") || { log 'CDP transport failed (python)'; return 1; }
    fi
    if ! jq -e '.id == 1 and (.error == null) and (.result.exceptionDetails == null)' <<< "$response" >/dev/null; then
        log "CDP evaluation failed: $response"; return 1
    fi
    jq -er '.result.result.value' <<< "$response"
}

# Pure-stdlib WebSocket client so the CDP transport never needs websocat.
cdp_eval_py() {
    python3 - "$cdp_url" "$1" <<'PYEOF'
import base64, secrets, socket, struct, sys

url, request = sys.argv[1], sys.argv[2]
rest = url[len("ws://"):]
host_port, _, path = rest.partition("/")
host, _, port = host_port.partition(":")
port = int(port or 80)
path = "/" + path

def read_exact(n):
    buf = b""
    while len(buf) < n:
        part = sock.recv(n - len(buf))
        if not part:
            sys.exit(1)
        buf += part
    return buf

key = base64.b64encode(secrets.token_bytes(16)).decode()
req = (
    "GET %s HTTP/1.1\r\n"
    "Host: %s:%d\r\n"
    "Upgrade: websocket\r\n"
    "Connection: Upgrade\r\n"
    "Sec-WebSocket-Key: %s\r\n"
    "Sec-WebSocket-Version: 13\r\n"
    "Origin: http://127.0.0.1:9222\r\n\r\n"
) % (path, host, port, key)

sock = socket.create_connection((host, port), timeout=4)
sock.sendall(req.encode())
header = b""
while b"\r\n\r\n" not in header:
    chunk = sock.recv(4096)
    if not chunk:
        sys.exit(1)
    header += chunk
if b" 101 " not in header.split(b"\r\n", 1)[0]:
    sys.exit(1)

payload = request.encode()
mask = secrets.token_bytes(4)
if len(payload) < 126:
    head = bytes([0x81, 0x80 | len(payload)])
elif len(payload) < 65536:
    head = bytes([0x81, 0x80 | 126]) + struct.pack(">H", len(payload))
else:
    head = bytes([0x81, 0x80 | 127]) + struct.pack(">Q", len(payload))
masked = bytes(b ^ mask[i % 4] for i, b in enumerate(payload))
sock.sendall(head + mask + masked)

data = b""
while True:
    h = read_exact(2)
    fin = h[0] & 0x80
    opcode = h[0] & 0x0F
    masked = h[1] & 0x80
    length = h[1] & 0x7F
    if length == 126:
        length = struct.unpack(">H", read_exact(2))[0]
    elif length == 127:
        length = struct.unpack(">Q", read_exact(8))[0]
    m = read_exact(4) if masked else b""
    chunk = read_exact(length)
    if masked:
        chunk = bytes(b ^ m[i % 4] for i, b in enumerate(chunk))
    if opcode == 8:
        sys.exit(1)
    if opcode == 1 or opcode == 0:
        data += chunk
    if fin:
        break
print(data.decode(errors="replace"))
PYEOF
}

setup_lyrics() {
    local dependency targets candidate state cdp_url='' expression deadline windows address
    # Only newly launched Spotify is automated; a later run never toggles its view.
    [[ $spotify_fresh == 1 ]] || { log 'Spotify was already running; no CDP attachment attempted'; return 1; }
    for dependency in curl timeout; do
        command -v "$dependency" >/dev/null || {
            log "Missing $dependency for CDP; install curl and coreutils"
            return 1
        }
    done
    if ! command -v websocat >/dev/null && ! command -v python3 >/dev/null; then
        log 'Missing websocat or python3 for the CDP transport; install either package'
        return 1
    fi
    deadline=$((SECONDS + 20))
    while ((SECONDS < deadline)); do
        if targets=$(curl --noproxy '*' -fsS --max-time 1 http://127.0.0.1:9222/json 2>/dev/null); then
            while IFS= read -r candidate; do
                [[ $candidate == ws://127.0.0.1:9222/* || $candidate == ws://localhost:9222/* ]] || continue
                cdp_url=$candidate
                if state=$(cdp_eval 'Boolean(document.querySelector("#SpicyLyrics_PageButton, #SpicyLyricsPage")) ? "spotify" : "waiting"') && [[ $state == spotify ]]; then break 2; fi
                cdp_url=''
            done < <(jq -r '.[] | select(.type == "page") | .webSocketDebuggerUrl // empty' <<< "$targets")
        fi
        sleep 0.5
    done
    [[ -n $cdp_url ]] || { log 'CDP timed out or Spicy Lyrics controls were unavailable'; return 1; }
    windows=$(addresses spotify) || return 1
    read -r address <<< "$windows"
    [[ -n $address ]] || { log 'Spotify window is no longer available'; return 1; }
    run hyprctl dispatch workspace 3 || return 1
    run hyprctl dispatch focuswindow "address:$address" || return 1
    log 'Using CDP: lyrics page -> cinema -> document fullscreen'
    # These selectors are navigation controls from upstream app.tsx and PageView.ts.
    expression=$(printf '%s\n' \
        '(() => {' \
        ' const page = document.querySelector("#SpicyLyricsPage");' \
        ' if (page?.classList.contains("Fullscreen") && document.fullscreenElement) return "done";' \
        ' const pending = window.__setupStartLyrics || (window.__setupStartLyrics = {});' \
        ' let stage, button;' \
        ' if (!page || page.classList.contains("CardMode")) {' \
        '   stage = "page"; button = document.querySelector("#SpicyLyrics_PageButton");' \
        ' } else if (!page.classList.contains("Fullscreen")) {' \
        '   stage = "cinema"; button = page.querySelector("#CinemaView");' \
        ' } else {' \
        '   stage = "fullscreen"; button = page.querySelector("#FullscreenToggle");' \
        ' }' \
        ' if (button && !pending[stage]) { pending[stage] = true; button.click(); }' \
        ' return "waiting";' \
        '})()')
    deadline=$((SECONDS + 20))
    while ((SECONDS < deadline)); do
        state=$(cdp_eval "$expression") || return 1
        if [[ $state == done ]]; then log 'Spicy Lyrics document fullscreen confirmed'; return 0; fi
        sleep 0.5
    done
    log 'Spicy Lyrics fullscreen timed out; no further toggle will be sent'
    return 1
}

log 'Phase 3: Spicy Lyrics fullscreen without playback commands'
if setup_lyrics; then
    lyrics=ok
else
    # F11 cannot open lyrics from the homepage; guessed clicks or tab order are unsafe.
    log 'WARNING: skipping keyboard fallback: no source-backed homepage lyrics shortcut; open Spicy Lyrics and Cinema View, then Fullscreen manually'
    lyrics=failed
fi

log 'Phase 4: return to workspace 1'
if run hyprctl dispatch workspace 1; then finish=ok; fi
log "Summary: apps=$apps; tmux=$terminal; lyrics=$lyrics; workspace1=$finish"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source ~/.pk10k.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# Alliases
alias cls='clear'
alias lgit='lazygit'
alias wfetch='wakafetch'
alias lgit='lazygit'
alias zen='zen-browser'
alias vim='nvim'
alias neofetch="$HOME/neofetch-solid-arch.sh"
alias matrix='cmatrix -C red'
alias cd="z"
alias cdi="zi"
alias top='btop'
alias setcursor='hyprctl setcursor "Bibata-Modern-Ice" 20'
# Ctrl + Left/Right
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# Ctrl + Shift + Left/Right (optional - Zsh doesn't spport selection here)
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
bindkey '^H' backward-kill-word
export GTK_THEME=TokyoNight-Dark-BL
HISTSIZE=10000
SAVEHIST=10000
export TERMINAL=ghostty
export EDITOR=nvim
export YAZI_CONFIG_HOME="$HOME/.config/yazi"
# Load FZF bindings and completions
# Created by `pipx` on 2025-07-16 07:50:33
export PATH="$PATH:/home/armaghan/.local/bin"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# or
# source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
echo -ne '\e[4 q'

ZSH_HIGHLIGHT_STYLES[comment]='fg=#565f89'                # Slate blue (soft comment)
ZSH_HIGHLIGHT_STYLES[command]='fg=#7aa2f7,bold'          # Bright blue command
ZSH_HIGHLIGHT_STYLES[function]='fg=#bb9af7,bold'         # Lavender function
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7dcfff,bold'          # Cyan builtin
ZSH_HIGHLIGHT_STYLES[alias]='fg=#7dcfff,underline'       # Cyan alias, underlined
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#ff9e64,bold'    # Orange reserved keywords
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#ff9e64'              # Orange glob patterns
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#89ddff,bold' # Light blue separators
ZSH_HIGHLIGHT_STYLES[argument]='fg=#c0caf5'              # Light grey for arguments
ZSH_HIGHLIGHT_STYLES[path]='fg=#9ece6a,bold'             # Green paths, bold
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e,bold'    # Red errors
ZSH_HIGHLIGHT_STYLES[default]='fg=#c0caf5'               # Default text (light grey)

if [[ -f ~/zff/zff.sh ]]; then
  source ~/zff/zff.sh
fi

export PATH="$HOME/.cargo/bin:$PATH"
eval "$(zoxide init zsh)"

# Binding ZFF

zff-widget() {
  zff --ansi \
      --border=rounded \
      --height=80% \
      --preview "$HOME/zff/zff-preview.sh {}" \
      --preview-window=left,60%,wrap
  zle reset-prompt
}

zle -N zff-widget

bindkey '^f' zff-widget
zle -N fzf-history-widget
fzf-history-widget() {
  BUFFER=$(fc -rl 1 | fzf +s --tac | sed 's/^[0-9 \t]*//')
  CURSOR=$#BUFFER
  zle redisplay
}

bindkey '^R' fzf-history-widget

cdi_widget() {
  zle -I    
  cdi  
  zle reset-prompt
}

zle -N cdi_widget
bindkey '^N' cdi_widget

# ███████╗███████╗██╗  ██╗███████╗██╗     ██╗     
# ╚══███╔╝██╔════╝██║  ██║██╔════╝██║     ██║     
#   ███╔╝ ███████╗███████║█████╗  ██║     ██║     
#  ███╔╝  ╚════██║██╔══██║██╔══╝  ██║     ██║     
# ███████╗███████║██║  ██║███████╗███████╗███████╗
# ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝

#  NOTE:  Setting up Powerlevel10k to be the main prompt, and load up instantly when starting a new terminal/tmux session:

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
ZSH_THEME="powerlevel10k/powerlevel10k"
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source ~/.pk10k.zsh

#  ALIASES:

alias cls='clear'
alias notify-send='dunstify -u critical -t 3000'
alias tree='tree -C'
alias lgit='lazygit'
alias wfetch='wakafetch --full | lolcat'
alias status='git status -u'
alias lgit='lazygit'
alias zen='zen-browser'
alias ov='nvim'
alias vim='nvim'
alias matrix='cmatrix -C red'
alias cd="z"
alias ls="eza -A -a --icons --group-directories-first"
alias cdi="zi"
alias top='btop'
alias setcursor='hyprctl setcursor "Bibata-Modern-Ice" 20'
alias count='find . -type f | wc -l'
alias ll='eza -lah -a --icons --group-directories-first'
alias lt='eza --tree -a --icons'
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'

# Making CONTROL+RIGHT/LEFT ARROW keys work in terminal:

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Making it so that, alt+tab accepts the autosuggest:

bindkey '^[^I' autosuggest-accept

# Binding CONTROL+BACKSPACE to delete a single word inside of for example: ~/.config/hypr, if I press control+backspace it will delete "hypr" and not the entire thing:

WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
bindkey '^H' backward-kill-word

# Setting command history to be a big number:

HISTSIZE=10000
SAVEHIST=10000

# Setting up Yazi config to be in the config file, and terminal to be ghostty and editor to be nvim

export GTK_THEME=TokyoNight-Dark-BL
export TERMINAL=ghostty
export EDITOR=nvim
export YAZI_CONFIG_HOME="$HOME/.config/yazi"
export PATH="$PATH:/home/armaghan/.local/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$HOME/.cargo/bin:$PATH"

# Exporting the Path, and sourcing zsh syntax highlighting in the terminal:

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
echo -ne '\e[4 q'

# Syntax highlighting with custom colors:

ZSH_HIGHLIGHT_STYLES[comment]='fg=#565f89,italic'     
ZSH_HIGHLIGHT_STYLES[command]='fg=#7aa2f7,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#bb9af7,bold'   
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7dcfff,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#73daca,underline'  
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#ff9e64,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#ff9e64'          
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#89ddff,bold'
ZSH_HIGHLIGHT_STYLES[argument]='fg=#c0caf5'          
ZSH_HIGHLIGHT_STYLES[path]='fg=#9ece6a,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e,bold'  
ZSH_HIGHLIGHT_STYLES[default]='fg=#c0caf5'

autoload -U compinit; compinit
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-flags \
    --color=fg:#cdd6f4,bg:-1,hl:#f38ba8,fg+:#cdd6f4,bg+:-1,hl+:#f5c2e7 \
    --color=info:#cba6f7,prompt:#89b4fa,pointer:#f38ba8,marker:#a6e3a1,spinner:#f9e2af,header:#f38ba8 \
    --bind=tab:accept,ctrl-j:down,ctrl-k:up,ctrl-space:toggle \
    --border=sharp \
    --height=60% \
    --layout=reverse \
    --info=right \
    --header="i use arch (btw)" \
    --header-first \
    --margin=1,2 \
    --padding=1,1 \
    --cycle
# Pressing enter executes the selected completion immediately
zstyle ':fzf-tab:*' accept-line enter

# Make nvim/vim/ov tab completion show only files (no directories)
zstyle ':completion:*:nvim:*' file-patterns '*(.)'
zstyle ':completion:*:vim:*' file-patterns '*(.)'
zstyle ':completion:*:ov:*' file-patterns '*(.)'

# Ensure cd tab completion shows only directories
zstyle ':completion:*:cd:*' file-patterns '*(/)'

# ZFF:

if [[ -f ~/zff/zff.sh ]]; then
  source ~/zff/zff.sh
fi
# Bind Ctrl+F to the widget
zle -N zffi
bindkey '^F' zffi


## OPENCODE

opencode_widget() {
  opencode
  zle reset-prompt
}
zle -N opencode_widget
bindkey '^O' opencode_widget

# Zoxide menu

eval "$(zoxide init zsh)"
zle -N cdi_widget
bindkey '^N' cdi_widget
# Enabling fzf hitory widget with fzf

export FZF_DEFAULT_OPTS="
    --height=100%        \
    --no-border            \
    --margin=1,5        \
    --padding=1,2       \
    --preview-window=right:90%:wrap \
    --color=bg+:-1,bg:-1,spinner:#9ece6a,hl:#89ddff \
    --color=fg:#a9b1d6,header:#f38ba8,info:#ff9e64,pointer:#ff9e64 \
    --color=marker:#7aa2f7,fg+:#cdd6f4,prompt:#f7768e,hl+:#89ddff \
    --color=selected-bg:-1 \
    --color=border:#45475a,label:#ff9e64
"

zle -N fzf-history-widget

fzf-history-widget() {
    BUFFER=$(fc -rl 1 | fzf +s --tac \
        --color=fg:7,hl:1,hl+:3,border:4 \
        --color=info:3,prompt:2,spinner:1,pointer:8,marker:8 \
        --color=fg+:2,hl+:3 \
        --bind=tab:accept \
        --pointer="" \
        --preview-window=right:60%:wrap \
        --layout=reverse-list \
        --height 100% | sed 's/^[0-9 \t]*//')
    CURSOR=$#BUFFER
    zle redisplay
    zle reset-prompt
}

bindkey '^R' fzf-history-widget

cdi_widget() {
  zle -I    
  cdi  
  zle reset-prompt
}
zff_widget() {
  zff
  zle reset-prompt
}

# FZF directory widget
cd_fzf() {
  local dir=$(fd --hidden --type d --exclude .git . $HOME | fzf --height 100% --reverse --border)
  if [[ -n $dir ]]; then
    cd "$dir"
    zle accept-line
    zle reset-prompt
  fi
}
zle -N cd_fzf
bindkey '^J' cd_fzf

# Ripgrep + FZF function
rgf() {
  local file
  file=$(rg --files | fzf --preview 'bat --style=numbers --color=always {} || cat {}' --bind 'enter:become($EDITOR {})')
  if [[ -n $file ]]; then
    $EDITOR $file
  fi
}

# Bind Ctrl+G to rgf
zle -N rgf
bindkey '^G' rgf

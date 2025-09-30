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
alias ai='tmux attach-session -t ai'
alias git status='git status -u'
alias wfetch='wakafetch -d 7'
alias lgit='lazygit'
alias zen='zen-browser'
alias ov='nvim'
alias vim='nvim'
alias neofetch="$HOME/neofetch-solid-arch.sh"
alias matrix='cmatrix -C red'
alias cd="z"
alias ls="lsd -A"
alias cdi="zi"
alias top='btop'
alias setcursor='hyprctl setcursor "Bibata-Modern-Ice" 20'

# Making CONTROL+RIGHT/LEFT ARROW keys work in terminal:

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Making it so that, alt+tab accepts the autosuggest:

bindkey '^[^I' autosuggest-accept

# Binding CONTROL+BACKSPACE to delete a single word inside of for example: ~/.config/hypr, if I press control+backspace it will delete "hypr" and not the entire thing:

WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
bindkey '^H' backward-kill-word
export GTK_THEME=TokyoNight-Dark-BL

# Setting command history to be a big number:

HISTSIZE=10000
SAVEHIST=10000

# Setting up Yazi config to be in the config file, and terminal to be ghostty and editor to be nvim

export TERMINAL=ghostty
export EDITOR=nvim
export YAZI_CONFIG_HOME="$HOME/.config/yazi"

# Exporting the Path, and sourcing zsh syntax highlighting in the terminal:

export PATH="$PATH:/home/armaghan/.local/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$HOME/.cargo/bin:$PATH"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
echo -ne '\e[4 q'

# Syntax highlighting with custom colors:

ZSH_HIGHLIGHT_STYLES[comment]='fg=#626880,italic'       
ZSH_HIGHLIGHT_STYLES[command]='fg=#7aa2f7,bold'          
ZSH_HIGHLIGHT_STYLES[function]='fg=#bb9af7,bold'     
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7dcfff,bold'       
ZSH_HIGHLIGHT_STYLES[alias]='fg=#4fd6be,underline'    
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#ffb86c,bold' 
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#ffb86c'            
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
    --color=fg:7,hl:1,hl+:3,border:9,fg+:2,hl+:3,info:3,prompt:2,spinner:1,pointer:8,marker:8,bg:-1 \
    --bind=tab:accept,btab:preview-up \
    --pointer="" \
    --border=rounded \
    --height=10% \

# ZFF:

if [[ -f ~/zff/zff.sh ]]; then
  source ~/zff/zff.sh
fi
zle -N zff
bindkey '^F' zff 

# Bind Ctrl+F to the widget

# Zoxide menu

eval "$(zoxide init zsh)"
zle -N cdi_widget
bindkey '^N' cdi_widget
# Enabling fzf hitory widget with fzf

export FZF_DEFAULT_OPTS="
    --height=100%        \
    --layout=reverse    \
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
        --height 10% | sed 's/^[0-9 \t]*//')
    CURSOR=$#BUFFER
    zle redisplay
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

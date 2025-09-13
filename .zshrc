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
alias lgit='lazygit'
alias wfetch='wakafetch -d 7'
alias lgit='lazygit'
alias zen='zen-browser'
alias vim='nvim'
alias neofetch="$HOME/neofetch-solid-arch.sh"
alias matrix='cmatrix -C red'
alias cd="z"
alias ls="ls -A"
alias cdi="zi"
alias top='btop'
alias setcursor='hyprctl setcursor "Bibata-Modern-Ice" 20'

# Making CONTROL+RIGHT/LEFT ARROW keys work in terminal:

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

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

#  Enabling zff (alternative to fzf) on startup and using it:

if [[ -f ~/zff/zff.sh ]]; then
  source ~/zff/zff.sh
fi

# Enabling zoxide (One of if not THE greatest terminal tools of all time) and making it so that CONTROL+N brings up the zi    widget

eval "$(zoxide init zsh)"
zle -N cdi_widget
bindkey '^N' cdi_widget

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

# Enabling fzf hitory widget with fzf


export FZF_DEFAULT_OPTS="
  --height=80%        \
  --layout=reverse    \
  --border            \
  --margin=1,2        \
  --padding=1,2       \
  --info=inline       \
"

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

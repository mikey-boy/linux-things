# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~

# Misc
export LT="$HOME/linux-things"
export SB="$HOME/notes/obsidian"

# Kubernetes
export do=(--dry-run=client -o yaml)
export now=(--force --grace-period 0)

# Colored GCC warnings and errors
export GCC_COLORS='error=02;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# ~~~~~~~~~~~~~~~ ZSH configuration ~~~~~~~~~~~~~~~~~~~~~~~~

setopt autocd               # Change directory just by typing name
setopt interactivecomments  # Bash style comments
setopt extendedglob         # Extended glob support
setopt numericglobsort      # Sort filenames numerically when it makes sense
setopt promptsubst          # Enable command substitution in prompt
#setopt shwordsplit         # Perform wordsplitting (into arrays) on shell variables 

# Configure vim editing
bindkey -v
export KEYTIMEOUT=5

# Ctrl + R for search history
bindkey "^R" history-incremental-search-backward

# Updates autocomplete for new installs
zstyle :compinstall filename '/home/mike/.zshrc'
autoload -Uz compinit
compinit

# Various key bindings
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[End]}" ]] && bindkey -- "${key[End]}" end-of-line
[[ -n "${key[Home]}" ]] && bindkey -- "${key[Home]}" beginning-of-line
[[ -n "${key[Insert]}" ]] && bindkey -- "${key[Insert]}" overwrite-mode
[[ -n "${key[Delete]}" ]] && bindkey -- "${key[Delete]}" delete-char
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Control-Left]}" ]] && bindkey -- "${key[Control-Left]}" backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~

# neovim
alias v='nvim'

# linux things
alias lt='cd $LT'
alias sb='cd $SB'

# ls
alias ls='ls --color=auto'
alias ll='ls -l'
alias lal='ls -al'
alias lsd='ls -l -t'

# Github
alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias gc='git commit'
alias gp='git push'
alias gau='git add -u'

# Docker
alias docker='sudo docker'
alias dockershell="docker run --rm -i -t --entrypoint=/bin/bash"
alias dockershellsh="docker run --rm -i -t --entrypoint=/bin/sh"

# Kubernetes
alias k='kubectl'
alias kn='kubectl config set-context --current --namespace '
alias kdbg='kubectl run --image busybox --attach debugger -it --rm'

# Misc
alias terraform='tf'
alias objdump='objdump -M intel'
alias xclip="xclip -selection clipboard"
alias sv='source .venv/bin/activate'
alias grep='grep --color=auto'
alias sz='source ~/.zshrc'
alias c='clear'
alias e='exit'
alias t='tmux'

# ~~~~~~~~~~~~~~~ PATH ~~~~~~~~~~~~~~~~~~~~~~~~

# Update PATH
export PATH="$PATH:/opt/android-studio/jre/bin"                 # Android Studio
export PATH="$PATH:$HOME/opt/cross/bin"                         # OS development (cross-compilers)
export PATH="$PATH:/home/mike/.local/share/gem/ruby/3.0.0/bin"  # Ruby gems
export PATH="$PATH:$HOME/go/bin"                                # Golang binaries
export PATH="$PATH:$LT/scripts"                                 # Custom scripts

# Update go-specific environment variables
export GOBIN="$HOME/go/bin"
export GOPATH="$HOME/go/"

# Update Ruby specific environment variables
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"

# ~~~~~~~~~~~~~~~ Powerlevel10k ~~~~~~~~~~~~~~~~~~~~~~~~

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


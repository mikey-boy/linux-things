# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Save command history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

export LANG=en_US.UTF-8

setopt autocd               # Change directory just by typing name
setopt interactivecomments  # Bash style comments
setopt extendedglob         # Extended glob support
setopt numericglobsort      # Sort filenames numerically when it makes sense
setopt promptsubst          # Enable command substitution in prompt
#setopt shwordsplit         # Perform wordsplitting (into arrays) on shell variables 

bindkey -v
export KEYTIMEOUT=1

# Updates autocomplete for new installs
zstyle :compinstall filename '/home/mike/.zshrc'
autoload -Uz compinit
compinit

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Ctrl + R for search history
bindkey "^R" history-incremental-search-backward

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# Load user-defined functions
if [ -f ~/.bash_fncs ]; then
    . ~/.bash_fncs
fi

# Update PATH
export PATH="$PATH:/opt/android-studio/jre/bin"                 # Android Studio
export PATH="$PATH:$HOME/opt/cross/bin"                         # OS development (cross-compilers)
export PATH="$PATH:/home/mike/.local/share/gem/ruby/3.0.0/bin"  # Ruby gems
export PATH="$PATH:$HOME/go/bin"                                # Golang binaries

# Update go-specific environment variables
export GOBIN="$HOME/go/bin"
export GOPATH="$HOME/go/"

# Update Ruby specific environment variables
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"

# Enable git prompt
source ~/aur/git-prompt.zsh/src/git-prompt.zsh-2.2.1/git-prompt.zsh

# Kubernetes exports
export do=(--dry-run=client -o yaml)
export now=(--force --grace-period 0)

# Various key bindings
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

new_line_before_prompt=yes
precmd() {
    # Print the previously configured title    
    print -Pnr -- "$TERM_TITLE"

    # Print the previously configured title    
    if [ "$new_line_before_prompt" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}


#PROMPT='%(?..%F{red}%? )%f%B%F{151}%~%f%b : '
#RPROMPT='$(gitprompt)'
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

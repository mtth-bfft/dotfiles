###############################################################################
###                          Autocompletion on TAB                          ###
###############################################################################

autoload -Uz compinit && compinit # enable TAB-autocompletion

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
# import dircolors from the GNU ls command settings in $LS_COLORS
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS$}'
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=** l:|=*' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=** l:|=*' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=** l:|=*' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=** l:|=*'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' prompt 'corr(%e)> '
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
zstyle :compinstall filename '~/.zshrc'
zstyle ':completion:*' rehash true # search for new executables before each run

setopt extendedglob # smarter glob than bash (^ to negate patterns, <N-M> for int ranges, etc.)
setopt nomatch # but be careful, print an error when a pattern matches no file name
setopt nobeep # bells are annoying

# show three dots while waiting for completion results
# (http://stackoverflow.com/questions/171563/#844299)
expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

###############################################################################
###                           Editors and behaviour                         ###
###############################################################################

export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"
export PAGER="/usr/bin/less"
setopt multios # automatically perform tees to emulate multiple redirections
setopt checkjobs # confirm exiting if there are background jobs running
# keyboard behavior, see man 5 terminfo
[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}" ]] && bindkey "${terminfo[kend]}" end-of-line
[[ -n "${terminfo[kpp]}" ]] && bindkey "${terminfo[kpp]}" beginning-of-line
[[ -n "${terminfo[knp]}" ]] && bindkey "${terminfo[knp]}" end-of-line
[[ -n "${terminfo[kich1]}" ]] && bindkey "${terminfo[kich1]}" overwrite-mode
[[ -n "${terminfo[kdch1]}" ]] && bindkey "${terminfo[kdch1]}" delete-char
[[ -n "${terminfo[kcub1]}" ]] && bindkey "${terminfo[kcub1]}" backward-char
[[ -n "${terminfo[kcuf1]}" ]] && bindkey "${terminfo[kcuf1]}" forward-char
# also make up-down scan through history without replacing what's been typed
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search
# make ctrl-arrow moves word by word
bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word

###############################################################################
###                          Command history saving                         ###
###############################################################################

HISTFILE=~/.history # share the history file with potential other files
HISTSIZE=100000 # number of commands read when starting (not unique ones)
SAVEHIST=$HISTSIZE # number of commands saved when working
setopt hist_ignore_space # do not record commands starting with a space
setopt inc_append_history # append at the end, at every command (no bufferisation)
setopt extended_history # save the start UNIX timestamp and duration
setopt hist_find_no_dups # remove duplicates in history searches
setopt hist_ignore_dups # do not append repetitions of the command right before
setopt hist_reduce_blanks # remove duplicate spaces in history

###############################################################################
###                           Directory Traversal                           ###
###############################################################################

DIRSTACKSIZE=10 # save the last N directories visited in a stack
DIRSTACKFILE="$HOME/.cache/zsh/dirs" # use a user-specific file to store it
# we have to manually reload the stack on startup
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    # and jump to the top-one at shell start if a start folder wasn't given
    # in argv
    [[ -d $dirstack[1] && "$(pwd)" == "$HOME" ]] && cd $dirstack[1]
fi
chpwd_dirstack_hook() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
chpwd_functions=(${chpwd_functions[@]} "chpwd_dirstack_hook")
setopt autopushd # make cd push the old directory onto the stack
setopt pushdsilent # do not print the directory stack after each push/pop
setopt pushdminus # revert +/- operators
setopt autocd # typing the name of a directory does a cd to it
# Set a few alias to navigate through directories
alias -g ...='../..'
for i in `seq 1 $DIRSTACKSIZE`; do
    alias "$i"="cd -$i"
done

###############################################################################
###                          Virtualenv activation                          ###
###############################################################################

# look for a directory containing the dirs/files that we could expect
function virtualenv_lookup_activate() {
    for d in .*/(N) */(N); do
        if [[ -d "$d" && -f "$d/bin/activate" && -f "$d/bin/python" && -x "$d/bin/python" ]]
        then
            source "$d/bin/activate"
        fi
    done
}
virtualenv_lookup_activate # perform an initial lookup, the startup directory might have one
# add it to the list of functions to be called on each directory change
chpwd_functions=(${chpwd_functions[@]} "virtualenv_lookup_activate")

###############################################################################
###                        Prompt color and metadata                        ###
###############################################################################

autoload -U colors && colors # we're gonna use $fg[colorname] variables
setopt promptsubst # we're gonna use parameter expansion and command substitution in our prompts
setopt notify # print background job statuses without waiting for the next prompt
export VIRTUAL_ENV_DISABLE_PROMPT='yes' # prevent venv/bin/activate from changing our prompt
export _OLD_VIRTUAL_PS1='' # remove any pre-activation prompt already saved

root_color="%{$fg_bold[red]%}"
user_color="%{$fg[green]%}"
host_color="%{$fg[green]%}"
time_color="%{$fg[blue]%}"
status_zero_color="%{$fg[green]%}"
status_nonzero_color="%{$fg_bold[red]%}"
cwd_color="%{$fg[cyan]%}"
venv_color="%{$fg[magenta]%}"
git_commit_ready="%{$fg[blue]%}"
git_branch_dirty="%{$fg[yellow]%}"
git_branch_clean="%{$fg[green]%}"
git_untracked_flag='+'

function virtualenv_prompt() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        psvar[1]=${VIRTUAL_ENV##*/}
    else
        psvar[1]=''
    fi
}
function gitstatus_prompt() {
    if [[ "${NO_GIT_PROMPT:-0}" == "0" ]] && gitstatus=$(git status --porcelain 2>/dev/null); then
        psvar[2]='1'
        untracked=$(echo "$gitstatus" | grep "^??" | wc -l)
        if [[ "$untracked" -ne "0" ]]; then
            psvar[3]="$git_untracked_flag"
        else
            psvar[3]=''
        fi
        modified=$(echo "$gitstatus" | grep "M" | wc -l)
        unstaged=$(echo "$gitstatus" | grep "^ M" | wc -l)
        if [[ "$modified" -ne "0" || "$untracked" -ne "0" ]]; then
            psvar[4]='M'
            if [[ "$unstaged" -eq "0" && "$untracked" -eq "0" ]]; then
                psvar[5]='R'
            else
                psvar[5]=''
            fi
        else
            psvar[4]=''
            psvar[5]=''
        fi
    else
        psvar[2]=''
    fi
}
autoload -U add-zsh-hook
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b'
add-zsh-hook precmd vcs_info
add-zsh-hook precmd virtualenv_prompt
add-zsh-hook precmd gitstatus_prompt

PROMPT='┌ '
PROMPT+='%(!.%{$root_color%}.%{$user_color%})%n%{$reset_color%}'
PROMPT+='%{$host_color%}@%m%{$reset_color%}'
PROMPT+=':%{$cwd_color%}%3~%{$reset_color%}'
PROMPT+='%(1V.%{$venv_color%}(%1v)%{$reset_color%}.)'
PROMPT+='%(2V.%(4V.%(5V.%{$git_commit_ready%}.%{$git_branch_dirty%}).%{$git_branch_clean%})[$vcs_info_msg_0_%(3V.%3v.)]%{$reset_color%}.)'
PROMPT+='
└ '

RPROMPT='%{$time_color%}%D{%d/%m %H:%M:%S}%{$reset_color%}'
RPROMPT+=' [%(?.%{$status_zero_color%}.%{$status_nonzero_color%})%?%{$reset_color%}]'

###############################################################################
###                          Miscellaneous aliases                          ###
###############################################################################

# make file-handling commands more verbose
for cmd in chown chmod cp rm; do
    alias $cmd="$cmd -v"
done

alias ls="ls --color=auto"
alias l="ls -alhp --color=auto"
alias ll="ls -alhp --color=auto"
alias lll="ls -alhpZ --color=auto"
alias grep="grep --color"
alias ds="dirs -vp"
alias please='sudo $(fc -ln -1)'
alias fuck='pkill -9'
alias iptbls="iptables -nvL --line-numbers"

###############################################################################
###                       Machine-Local cusomisations                       ###
###############################################################################

if [[ -f local_zshrc ]]; then
	source local_zshrc
fi


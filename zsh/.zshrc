# Load zplug

unset ZPLUG_CLONE_DEPTH
unset ZPLUG_CACHE_FILE

source ~/.zplug/init.zsh

# Enable emacs mode
bindkey -e

# Let zplug manage itself
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions", as:plugin, use:"src"
zplug "rupa/z", use:z.sh

zplug "zsh-users/zsh-autosuggestions"
    export ZSH_AUTOSUGGEST_USE_ASYNC=true
    bindkey '^ ' autosuggest-accept

# pure prompt
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:"pure.zsh", from:github, as:theme

# defer:3 needed to load after compinit
zplug "zsh-users/zsh-syntax-highlighting", defer:3

# # Install plugins if there are plugins that have not been installed
# if ! zplug check --verbose; then
#     printf "Install? [y/N]: "
#     if read -q; then
#         echo; zplug install
#     fi
# fi

zplug load

# Show git stash status
zstyle :prompt:pure:git:stash show yes

# personal scripts
PATH="$HOME/bin:$PATH"
# go binaries
PATH="$HOME/go/bin:$PATH"
# npm
PATH="$HOME/.npm-packages:$PATH"
# neovim version manager
PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# fly.io
export FLYCTL_INSTALL="/home/pockata/.fly"
PATH="$FLYCTL_INSTALL/bin:$PATH"
# rust
PATH="$HOME/.cargo/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
nvm () {
    echo "Lazy loading nvm..."
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm "$@"
}

export EDITOR='nvim'

# Map Ctrl-S to sth usefull other than XOFF (interrupt data flow).
stty -ixon
setopt noflowcontrol

# # Vi mode
# bindkey -v
# # Remove the 0.4s delay switching vi modes
# export KEYTIMEOUT=1 # reduces to 0.1

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list	'' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':zplug:tag' depth 1
bindkey '^[[Z' reverse-menu-complete

# Try to correct the spelling of commands.
setopt correctall
setopt autocd
setopt extendedglob
setopt autopushd

# Allow comments in the command line
setopt interactivecomments

# Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt notify

# Automatically list choices on an ambiguous completion.
setopt auto_list

# confirm execution of command from history
setopt hist_verify

# Share history between sessions
HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=100000
HISTORY_IGNORE="(bg|fg|cd*|rm*|clear|ls|pwd|history|exit|make*|* --help)"

# use a shared history but separate it by tmux session
if [[ $TMUX_PANE ]]; then
    session_name="$(tmux display-message -p '#S')"
    HISTFILE=$HOME/.history_tmux_${session_name}
fi

# Don't consider certain characters part of the word
WORDCHARS=${WORDCHARS//\/[&.;]}

setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt extended_history
setopt hist_ignore_space

export FZF_DEFAULT_COMMAND="(git ls-files --others --exclude-standard --cached 2> /dev/null || rg --files --no-ignore --hidden --follow --glob '!.git/*' --glob '!node_modules/*' 2>&1)"
export FZF_DEFAULT_OPTS='--multi --bind=ctrl-k:down,ctrl-l:up'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_CTRL_R_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS="$FZF_DEFAULT_OPTS --preview 'echo {}' --preview-window down:3:hidden:wrap:noborder --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | xsel --clipboard --input)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"
export FZF_ALT_C_COMMAND="fdfind --follow --strip-cwd-prefix --type d 2> /dev/null"
#export FZF_ALT_C_OPTS="$FZF_DEFAULT_OPTS"
command -v tree > /dev/null && export FZF_ALT_C_OPTS="$FZF_DEFAULT_OPTS --preview 'tree -C {} | head -$LINES' --preview-window 'noborder'"

# Use rg instead of the default find command for listing candidates.
# - The first argument to the function is the base path to start traversal
# - Note that rg only lists files not directories
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    rg --files "$1" | with-dir "$1"
}

# Use rg to generate the list for directory completion
_fzf_compgen_dir() {
    rg --files "$1" | only-dir "$1"
}

# load fzf's zsh keybindings if available
if [[ -e /usr/share/fzf/completion.zsh ]]; then
	source /usr/share/fzf/completion.zsh
fi

if [[ -e /usr/share/doc/fzf/examples/completion.zsh ]]; then
	source /usr/share/doc/fzf/examples/completion.zsh
fi

# load fzf's zsh keybindings if available
if [[ -e /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
	source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# colorize man pages
# http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
export LESS_TERMCAP_mb=$(printf "\e[1;31m")
export LESS_TERMCAP_md=$(printf "\e[1;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;44;33m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[1;32m")
export LESS='--ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --chop-long-lines'

# like normal z when used with arguments but displays an fzf prompt when used without.
unalias z 2> /dev/null
z() {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf-tmux +s --tac --query "$*" | sed 's/^[0-9,.]* *//')"
}

# Aliases
alias g="git"
alias ga="g add \$(gf) && g st"
alias gv='f() { nvim +"let g:loaded_startify = 1" +"GV $1" +"autocmd BufWipeout <buffer> qall" +tabonly }; f'
alias t="tmux -2"
alias e="nvim"
alias today="g today | gshow"
# TODO: use eog or okular based on availability
alias view="viewnior"

# https://github.com/Jguer/yay/issues/750
alias aur="yay --editmenu"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ip a | grep 'inet ' | sed -e 's/^.*inet //g' -e 's/\/.*//g' | grep -v '127.0.0.1'"
alias ls='LC_COLLATE=C ls -A --color -h --group-directories-first'
alias ll='ls -l'
alias lsym='ls -la | grep -i "\->" | awk "/ / { print \$9, \$11 }"'
alias busy="cat /dev/urandom | hexdump -C | grep --color=auto \"ca fe\""

alias addr="ip -o a | cut -d ' ' -f2,7"
alias open="xdg-open"

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

alias da='docker exec -i -t'
# Docker Compose
alias dc='docker-compose'
alias dcu='docker-compose up -d'
alias dcl='docker-compose logs'
alias dcr='docker-compose run --rm'

alias gi='grep -i'

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$_";
}

function groot() {
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
        cd $1
    fi
}

alias gr='groot'

# Basic calculator
= () {
    bc -l <<< "$@"
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# Add bindings to the vicmd keymap
bindkey -a j backward-char
bindkey -a ';' forward-char
bindkey -a k down-history
bindkey -a l up-history

# for lolcommits
export LOLCOMMITS_DIR="${HOME}/Pictures/lolcommits/"
export LOLCOMMITS_FORK=true
export LOLCOMMITS_STEALTH=true

# for NPM
export NPM_PACKAGES="${HOME}/.npm-packages"

# for NODE
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

PATH="$NPM_PACKAGES/bin:$PATH"
PATH="${HOME}/.gem/ruby/2.6.0/bin:$PATH"
PATH="${HOME}/.local/share/neovim/bin:${PATH}"
export PATH;

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias headers="curl -s -D - -o /dev/null"

# scan the local network and list the connected devices
lscan() {
    local ipRange=$(ip addr | grep -oE "192.168.*.*/[1-9]{2}" | awk -F '.' '{print $3}')
    local scanReport=$(nmap -sn "192.168.$ipRange.1-254/24" | egrep "scan report")
    # echo "$scanReport\n" | sed -r 's#Nmap scan report for (.*) \((.*)\)#\1 \2#'
    echo "$scanReport"
}

is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

# cselect - git commit selector
cselect() {
    is_in_git_repo || return
    git l --graph --color=always "$@" |
    fzf -d 100% --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --header "Press CTRL-S to toggle sort" \
        --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'git show --format=medium --stat --color=always % | head -$LINES '" |
            grep -o "[a-f0-9]\{7,\}"
}

# gshow - git commit browser
gshow() {
    is_in_git_repo || return

    if [ -t 0 ]; then
        git_output="$(git l --graph --color=always "$@")"
    else
        git_output="$(cat -)"
    fi

    # switch preview position on narrow screens
    PREVIEW_SIDE="$([[ "$(tput cols)" -gt 145 ]] && echo "right" || echo "up")"
    echo "$git_output" |
    fzf -d 100% --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --header "Press CTRL-S to toggle sort" \
        --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'git show --color=always % | head -$LINES '" \
        --preview-window "${PREVIEW_SIDE}" \
        --bind "enter:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'nvim fugitive://\$(git rev-parse --show-toplevel)/.git//\$(git rev-parse --verify %) < /dev/tty'"
}

gb() {
    is_in_git_repo || return
    git branch -a --color=always | grep -v '/HEAD\s' | sort | sed 's#remotes/##' |
    fzf-tmux --ansi --multi --tac --preview-window right:70%:noborder \
        --preview 'git log-format --graph $(sed s/^..// <<< {} | cut -d" " -f1) -- | head -'$LINES |
    tr -d ' *'
}

gf() {
    is_in_git_repo || return
    git -c color.status=always status --short |
    fzf-tmux -m --ansi --nth 2..,.. \
        --preview-window right:50%:noborder \
        --preview 'NAME="$(cut -c4- <<< {})" &&
        (git diff --color=always "$NAME" | sed 1,4d; cat "$NAME") | head -'$LINES |
    cut -c4- | tr '\n' ' '
}

gp() {
    is_in_git_repo || return
    git diff --color=always --name-status HEAD~1..HEAD |
    fzf-tmux -m --ansi --nth 2..,.. \
        --preview-window right:50%:noborder \
        --preview 'NAME="$(cut -c3- <<< {})" &&
        (git diff --color=always "$NAME" | sed 1,4d; cat "$NAME") | head -'$LINES |
    cut -c4- | tr '\n' ' '
}

# gco - checkout git branch/tag
gco() {

    is_in_git_repo || return

    local tags branches target
    tags=$(
        git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return

    branches=$(
        git branch --all | grep -v HEAD             |
        sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
        sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return

    target=$(
        (echo "$tags"; echo "$branches") |
        fzf --no-hscroll --ansi +m -d "\t" -n 2 -1 -q "$*") || return

    git checkout $(echo "$target" | awk '{print $2}')
}

listdirectories() {
    rg --files . | only-dir . |\
        2> /dev/null | \
        grep -v '^.$' | \
        sed 's|\./||g' | \
        fzf-tmux --ansi --multi --tac --preview-window right:50%:noborder \
            --preview 'tree -C {} | head -$LINES'
}

# Call from a local repo to open the repository on github/bitbucket in browser
# Modified version of https://github.com/zeke/ghwd
repo() {
    # Validate that this folder is a git folder
    if ! command git branch 2>/dev/null 1>&2 ; then
        echo "Not a git repo!"
        exit $?
    fi

    # Figure out github repo base URL
    local base_url

    base_url=$(command git config --get remote.origin.url)
    base_url=${base_url%\.git} # remove .git from end of string

    # Fix git@github.com: URLs
    base_url=${base_url//git@github\.com:/https:\/\/github\.com\/}

    # Fix git://github.com URLS
    base_url=${base_url//git:\/\/github\.com/https:\/\/github\.com\/}

    # Fix git@bitbucket.org: URLs
    base_url=${base_url//git@bitbucket.org:/https:\/\/bitbucket\.org\/}

    # Fix git@gitlab.com: URLs
    base_url=${base_url//git@gitlab\.com:/https:\/\/gitlab\.com\/}

    # Find current directory relative to .git parent
    full_path=$(pwd)
    git_base_path=$(cd "./$(command git rev-parse --show-cdup)" || exit 1; pwd)
    relative_path=${full_path#$git_base_path} # remove leading git_base_path from working directory

    # If filename argument is present, append it
    if [ "$1" ]; then
        relative_path="$relative_path/$1"
    fi

    # Figure out current git branch
    # git_where=$(command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
    git_where=$(command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null

    # Remove cruft from branchname
    branch=${git_where#refs\/heads\/}

    [[ $base_url == *bitbucket* ]] && tree="src" || tree="tree"
    url="$base_url/$tree/$branch$relative_path"


    echo "Calling $(type open) for $url"

    open "$url" &> /dev/null || (echo "Using $(type open) to open URL failed." && exit 1);
}

# Interactive process killing with FZF:
fkill() {
  pid=$(ps -ux | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

# Smart cd
# cd /etc/fstab
#
# https://github.com/mika/zsh-pony#smart-cd
cd () {
    # handle "cd -- folder" calls from fzf's ALT-C
    local arg="${1}"
    if [[ $arg == "--" ]]
    then
        arg="${2}"
    fi

    if [[ -f ${arg} ]]
    then
        [[ ! -e ${arg:h} ]] && return 1
        print "Correcting ${arg} to ${arg:h}"
        builtin cd ${arg:h}
    else
        builtin cd ${arg}
    fi
}

widget-helper() {
    local ret=$?
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}

alias git_diff_commit='git diff-tree --no-commit-id --name-only -r HEAD'
alias gdc=git_diff_commit

# https://github.com/sirupsen/dotfiles/blob/8d232bab79c0032af1b827ad523d77f0f8959037/home/.bash/04_aliases.bash#L59
review-latest-commit() {
  nvim -c "lua require('gitsigns').change_base('HEAD~1', true)" -c ":e!" $(git_diff_commit)
}
alias rlc='review-latest-commit'

git-branches-widget() {
    LBUFFER="${LBUFFER}$(gb)"
    widget-helper
}

git-changedfiles-widget() {
    LBUFFER="${LBUFFER}$(gf)"
    widget-helper
}

git-prevCommit-widget() {
    LBUFFER="${LBUFFER}$(gp)"
    widget-helper
}

git-commitfinder-widget() {
    LBUFFER="${LBUFFER}$(cselect)"
    widget-helper
}

listdirectories-widget() {
    LBUFFER="${LBUFFER}$(listdirectories)"
    widget-helper
}

autoload -U edit-command-line

zle -N edit-command-line
zle -N git-branches-widget
zle -N git-changedfiles-widget
zle -N git-prevCommit-widget
zle -N git-commitfinder-widget
zle -N listdirectories-widget

bindkey -r '^G'
bindkey '^G^F' git-changedfiles-widget
bindkey '^G^P' git-prevCommit-widget
bindkey '^G^R' git-commitfinder-widget
bindkey '^G^B' git-branches-widget
bindkey '^X^E' edit-command-line
# bindkey '^F' listdirectories-widget

# Complete word from history with menu
# https://github.com/mika/zsh-pony
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history
bindkey "^X^X" hist-complete

bindkey -s '^f' "tmux-sessionizer\n"

if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

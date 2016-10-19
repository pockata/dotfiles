# Load zplug
source ~/.zplug/init.zsh

# Let zplug manage itself
zplug "zplug/zplug"

zplug "zsh-users/zsh-completions", as:plugin, use:"src"
zplug "rupa/z", use:z.sh

# pure prompt
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"

# nice:10 needed to load after compinit
zplug "zsh-users/zsh-syntax-highlighting", nice:10

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# ruby binaries
PATH="$HOME/.gem/ruby/2.3.0/bin/:$PATH"

export PATH="$HOME/bin:$PATH"

export EDITOR='vim'

# Map Ctrl-S to sth usefull other than XOFF (interrupt data flow).
stty -ixon
setopt noflowcontrol

# Vi mode
bindkey -v
# Remove the 0.4s delay switching vi modes
export KEYTIMEOUT=1 # reduces to 0.1

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list	'' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
bindkey '^[[Z' reverse-menu-complete

# Try to correct the spelling of commands.
setopt correctall
setopt autocd
setopt extendedglob
setopt autopushd

# Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt notify

# Automatically list choices on an ambiguous completion.
setopt auto_list

# confirm execution of command from history
setopt hist_verify

# Share history between sessions
HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000

setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt extended_history
setopt hist_ignore_space

export FZF_DEFAULT_COMMAND='ag --hidden -g ""' # Use ag as the default source for fzf
export FZF_DEFAULT_OPTS='--multi --bind=ctrl-k:down,ctrl-l:up'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_CTRL_R_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS="$FZF_DEFAULT_OPTS"
export FZF_CTRL_C_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_C_OPTS="$FZF_DEFAULT_OPTS"
command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -$LINES'"

# Use ag instead of the default find command for listing candidates.
# - The first argument to the function is the base path to start traversal
# - Note that ag only lists files not directories
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    ag --hidden -g "" "$1"
}

# colorize man pages
# http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
export LESS_TERMCAP_mb=$(printf "\e[1;31m")
export LESS_TERMCAP_md=$(printf "\e[1;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;44;33m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[1;32m")
export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'

# like normal z when used with arguments but displays an fzf prompt when used without.
unalias z 2> /dev/null
z() {
    [ $# -gt 0 ] && _z "$*" && return
    cd "$(_z -l 2>&1 | fzf-tmux +s --tac --query "$*" | sed 's/^[0-9,.]* *//')"
}

# Aliases
alias a="atom-beta"
alias g="git"
alias gv='vim +"let g:loaded_startify = 1" +GV +"autocmd BufWipeout <buffer> qall"'
alias t="tmux -2"
alias e="vim"
alias view="eog"
alias aur="yaourt"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias cu="caniuse --long --mobile --percentages"
alias ls='LC_COLLATE=C ls -A --color -h --group-directories-first'
alias lsym='ls -la | grep -i "\->" | awk "/ / { print \$9, \$11 }"'
alias lsg='ls -la | grep -ni dot'
alias busy="cat /dev/urandom | hexdump -C | grep --color=auto \"ca fe\""

alias addr="ip -o a | cut -d ' ' -f2,7"
alias open="xdg-open"

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

alias da='docker exec -i -t --entrypoint /bin/bash'
# Docker Compose
alias dc='docker-compose'
alias dcu='docker-compose up -d'
alias dcl='docker-compose logs'
alias dcr='docker-compose run --rm'

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

# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

# Add bindings to the vicmd keymap
bindkey -a j backward-char
bindkey -a ';' forward-char
bindkey -a k down-history
bindkey -a l up-history

# for Brackets
export EXTRACT="/opt/brackets/samples/root/Getting Started/images"

# for lolcommits
export LOLCOMMITS_DIR="${HOME}/Pictures/lolcommits/"
export LOLCOMMITS_FORK=true
export LOLCOMMITS_STEALTH=true

# for NPM
export NPM_PACKAGES="${HOME}/.npm-packages"

# for NODE
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

PATH="$NPM_PACKAGES/bin:$PATH"
export PATH;

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias headers="curl -s -D - -o /dev/null"

# Switch tmux-sessions
tls() {
    local session
    session=$(tmux list-sessions -F "#{session_name}" | \
        fzf-tmux --query="$1" --select-1 --exit-0) && {
        test -z "$TMUX" && tmux attach -t "$session" || tmux switch-client -t "$session"
    }
}

# v - open files in ~/.viminfo
v() {
  local files
  files=$(grep '^>' ~/.viminfo | cut -c3- |
          while read line; do
            [ -f "${line/\~/$HOME}" ] && echo "$line"
          done | fzf-tmux -d -m -q "$*" -1) && vim ${files//\~/$HOME}
}

# christ?
chist() {
    local cols sep
    export cols=$(( COLUMNS / 3 ))
    export sep='{::}'

    cp -f ~/.config/chromium/Default/History /tmp/h
    sqlite3 -separator $sep /tmp/h \
        "select title, url from urls order by last_visit_time desc" |
    ruby -ne '
        cols = ENV["cols"].to_i
        title, url = $_.split(ENV["sep"])
        len = 0
        puts "\x1b[36m" + title.each_char.take_while { |e|
        if len < cols
            len += e =~ /\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/ ? 2 : 1
        end
        }.join + " " * (2 + cols - len) + "\x1b[m" + url' |
    fzf --ansi --multi --no-hscroll --tiebreak=index |
    sed 's#.*\(https*://\)#\1#' | xargs xdg-open
}

is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

# gshow - git commit browser
gshow() {
    is_in_git_repo || return
    git l --graph --color=always "$@" |
    fzf -d 100% --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --header "Press CTRL-S to toggle sort" \
        --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'git show --color=always % | head -$LINES '" \
        --bind "enter:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'vim fugitive://\$(git rev-parse --show-toplevel)/.git//% < /dev/tty'"
}

gb() {
    is_in_git_repo || return
    git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf-tmux --ansi --multi --tac --preview-window right:70% \
        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
    sed 's/^..//' | cut -d' ' -f1 |
    sed 's#^remotes/##'
}

gf() {
    is_in_git_repo || return
    git -c color.status=always status --short |
    fzf-tmux -m --ansi --nth 2..,.. \
        --preview 'NAME="$(cut -c4- <<< {})" &&
        (git diff --color=always "$NAME" | sed 1,4d; cat "$NAME") | head -'$LINES |
    cut -c4-
}

# gco - checkout git branch/tag
gco() {
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


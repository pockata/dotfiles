# Load zplug
source ~/.zplug/zplug

# Let zplug manage itself
zplug "b4b4r07/zplug"

zplug "zsh-users/zsh-history-substring-search", as:plugin
zplug "zsh-users/zsh-completions", as:plugin, of:"src"
zplug "rupa/z", of:z.sh

# Directory listings for zsh with git features
zplug "supercrabtree/k", of:k.sh

# pure prompt
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"

# nice:10 needed to load after compinit
zplug "zsh-users/zsh-syntax-highlighting", nice:10

# A Zsh plugin to help remembering those aliases you once defined.
zplug "djui/alias-tips"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

export PATH=$HOME/bin:$PATH

#http://zsh.sourceforge.net/Doc/Release/Options.html

# Loading NVM
#export NVM_DIR="/home/pockata/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

export EDITOR='vim'

# Vi mode
bindkey -v
# Remove the 0.4s delay switching vi modes
export KEYTIMEOUT=1 # reduces to 0.1

# Try to correct the spelling of commands.
setopt correct

# Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt notify

# Automatically list choices on an ambiguous completion.
setopt auto_list

# Share history between sessions
HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000

setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt extended_history

export FZF_DEFAULT_COMMAND='ag -l -g ""' # Use ag as the default source for fzf
export FZF_DEFAULT_OPTS='--multi'

# Aliases
alias a="atom-beta"
alias g="git"
alias v="gvim"
alias view="eog"
alias aur="yaourt"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias cu="caniuse --long --mobile --percentages"
alias ls='LC_COLLATE=C ls -A --color -h --group-directories-first'
alias lsym='ls -la | grep -i "\->" | awk "/ / { print \$9, \$11 }"'
alias lsg='ls -la | grep -ni dot'
alias busy="cat /dev/urandom | hexdump -C | grep --color=auto \"ca fe\""

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

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

# Basic calculator
= () {
    bc -l <<< "$@"
}

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
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
#bindkey -a k down-history
#bindkey -a l up-history

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

# for ATOM
export ATOM_DEV_RESOURCE_PATH="{$HOME}/Projects/atom/"

PATH="$NPM_PACKAGES/bin:$PATH"
export PATH;


# Load Antigen
source /usr/share/zsh/scripts/antigen/antigen.zsh

antigen bundle git
antigen bundle zsh-users/zsh-completions src
antigen bundle rupa/z
antigen bundle command-not-found
antigen bundle node
antigen bundle npm
antigen bundle rsync
antigen bundle mafredri/zsh-async
antigen bundle sindresorhus/pure
antigen bundle zsh-users/zsh-syntax-highlighting

# A Zsh plugin to help remembering those aliases you once defined.
antigen bundle djui/alias-tips

antigen apply

export PATH=$HOME/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs, plugins, and themes. Aliases can be placed here, though oh-my-zsh users are encouraged to define aliases within the ZSH_CUSTOM folder.  For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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


# Aliases
alias a="atom-beta"
alias g="git"
alias v="gvim"
alias view="eog"
alias aur="yaourt"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias cu="caniuse --long --mobile --percentages"
alias ls='ls -A --color -h --group-directories-first'
alias lsym='ls -la | grep -i "\->" | awk "/ / { print \$9, \$11 }"'
alias lsg='ls -la | grep -ni dot'

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
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
#bindkey -a j backward-char
#bindkey -a ';' forward-char
#bindkey -a k down-history
#bindkey -a l up-history

# for Brackets
export EXTRACT="/opt/brackets/samples/root/Getting Started/images"

# for lolcommits
export LOLCOMMITS_DIR="/home/pockata/Pictures/lolcommits/"
export LOLCOMMITS_FORK=true
export LOLCOMMITS_STEALTH=true

# for NPM
export NPM_PACKAGES="${HOME}/.npm-packages"

# for NODE
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

# for ATOM
export ATOM_DEV_RESOURCE_PATH="/home/pockata/Projects/atom/"

PATH="$NPM_PACKAGES/bin:$PATH"
PATH="/home/pockata/.gem/ruby/2.2.0/bin:${PATH+:}${PATH}"; 
export PATH;


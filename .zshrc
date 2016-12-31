# Editor
if  [ $TERM = "linux" ] ; then
    export EDITOR=vim
    alias vd='vimdiff'
else
    export EDITOR=nvim
    alias vim='nvim'
    alias vimdiff='nvim -d'
fi
# dircolors
eval "`dircolors -b ~/.dircolors`"

# colorgcc + ccache
export PATH="/usr/lib/colorgcc/bin/:$PATH" 
export CCACHE_PATH="/usr/bin"
h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }
autoload -Uz colors && colors
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
alias dh='dirs -v'

# REPORTTIME
TIMEFMT="'$fg[green]%J$reset_color' time: $fg[blue]%*Es$reset_color, cpu: $fg[blue]%P$reset_color"
export REPORTTIME=5

# openrc
listd() { rc-status $1; }
start() { sudo rc-service $1 start; }
stop() { sudo rc-service $1 stop; }
restart() { sudo rc-service $1 restart; }
status() { sudo rc-service $1 status; }
enabled() { sudo rc-update add $1 $2; listd $2 }
disabled() { sudo rc-update del $1 $2; listd $2 }
Start() { sudo rc-service $1 start; sudo rc-service $1 status; }
Stop() { sudo rc-service $1 stop; sudo rc-service $1 status; }
Restart() { sudo rc-service $1 restart; rc-service $1 status; }

# general aliases and functions
alias pg='echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && ps aux | grep --color=auto -i'
alias scp='scp -p'
alias cp='cp -a'
alias xx='exit'
alias sudo='sudo '
alias wget='wget -c'
alias grep='grep --color=auto'
alias zgrep='zgrep --color=auto'
alias ls='ls --group-directories-first --color=auto'
alias ll='ls -lhF'
alias la='ls -lha'
alias dir='ls -lhA'
alias lt='ls -lhtr'
alias lta='ls -lhatr'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias du='du -ach'
alias dus='du -ach | sort -h'
alias df='df --si'
alias c='clear'
alias free='free -mt'
alias fhere='find . -name '
alias diff='diff --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias reboot='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart'
alias shutdown='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop'
alias poweroff='shutdown '
alias suspend='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Suspend  boolean:true'
alias hibernate='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Hibernate  boolean:true'
alias dmesg='dmesg --color=auto'
alias wdmesg='watch -n 0 -c "dmesg --color=always | tail --lines 30"'
export LESS=-R
x() {
	if [[ -f "$1" ]]; then
		case "$1" in
			*.tar.lrz)
				b=$(basename "$1" .tar.lrz)
				lrztar -d "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.lrz)
				b=$(basename "$1" .lrz)
				lrunzip "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar.bz2)
				b=$(basename "$1" .tar.bz2)
				bsdtar xjf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.bz2)
				b=$(basename "$1" .bz2)
				bunzip2 "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar.gz)
				b=$(basename "$1" .tar.gz)
				bsdtar xzf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.gz)
				b=$(basename "$1" .gz)
				gunzip "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar.xz)
				b=$(basename "$1" .tar.xz)
				bsdtar Jxf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.xz)
				b=$(basename "$1" .gz)
				xz -d "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.rar)
				b=$(basename "$1" .rar)
				unrar e "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar)
				b=$(basename "$1" .tar)
				bsdtar xf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tbz2)
				b=$(basename "$1" .tbz2)
				bsdtar xjf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tgz)
				b=$(basename "$1" .tgz)
				bsdtar xzf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.zip)
				b=$(basename "$1" .zip)
				unzip "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.Z)
				b=$(basename "$1" .Z)
				uncompress "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.7z)
				b=$(basename "$1" .7z)
				7z x "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*) echo "don't know how to extract '$1'..." && return 1;;
		esac
		return 0
	else
		echo "'$1' is not a valid file!"
		return 1
	fi
}
alias yt='noglob youtube-dl -q'
alias orphans='[[ -n $(pacman -Qdt) ]] && sudo pacman -Rs $(pacman -Qdtq) || echo "no orphans to remove"'
# feed
if [ ! -n "$FEED_BOOKMARKS" ]; then export FEED_BOOKMARKS=$HOME/.feed_bookmarks; fi
if [ ! -d "$FEED_BOOKMARKS" ]; then mkdir -p $FEED_BOOKMARKS; fi

feed() {
	if [ ! -d $FEED_BOOKMARKS ]; then mkdir $FEED_BOOKMARKS; fi

	if [ ! -n "$1" ]; then
		echo -e "\\n \\e[04mUsage\\e[00m\\n\\n   \\e[01;37m\$ feed \\e[01;31m<url>\\e[00m \\e[01;31m<new bookmark?>\\e[00m\\n\\n \\e[04mSee also\\e[00m\\n\\n   \\e[01;37m\$ deef\\e[00m\\n"
		return 1;
	fi

	local rss_source="$(curl --silent $1 | sed -e ':a;N;$!ba;s/\n/ /g')";

	if [ ! -n "$rss_source" ]; then
		echo "The feed is empty";
		return 1;
	fi

	# THE RSS PARSER
	# The characters "£, §" are used as metacharacters. They should not be encountered in a feed...
	echo -e "$(echo $rss_source | \
		sed -e 's/&amp;/\&/g
		s/&lt;\|&#60;/</g
		s/&gt;\|&#62;/>/g
		s/<\/a>/£/g
		s/href\=\"/§/g
		s/<title>/\\n\\n\\n   :: \\e[01;31m/g; s/<\/title>/\\e[00m ::\\n/g
		s/<link>/ [ \\e[01;36m/g; s/<\/link>/\\e[00m ]/g
		s/<description>/\\n\\n\\e[00;37m/g; s/<\/description>/\\e[00m\\n\\n/g
		s/<p\( [^>]*\)\?>\|<br\s*\/\?>/\n/g
		s/<b\( [^>]*\)\?>\|<strong\( [^>]*\)\?>/\\e[01;30m/g; s/<\/b>\|<\/strong>/\\e[00;37m/g
		s/<i\( [^>]*\)\?>\|<em\( [^>]*\)\?>/\\e[41;37m/g; s/<\/i>\|<\/em>/\\e[00;37m/g
		s/<u\( [^>]*\)\?>/\\e[4;37m/g; s/<\/u>/\\e[00;37m/g
		s/<code\( [^>]*\)\?>/\\e[00m/g; s/<\/code>/\\e[00;37m/g
		s/<a[^§]*§\([^\"]*\)\"[^>]*>\([^£]*\)[^£]*£/\\e[01;31m\2\\e[00;37m \\e[01;34m[\\e[00;37m \\e[04m\1\\e[00;37m\\e[01;34m ]\\e[00;37m/g
		s/<li\( [^>]*\)\?>/\n \\e[01;34m*\\e[00;37m /g
		s/<!\[CDATA\[\|\]\]>//g
		s/\|>\s*<//g
		s/ *<[^>]\+> */ /g
		s/[<>£§]//g')\n\n";
	# END OF THE RSS PARSER

	if [ -n "$2" ]; then
		echo "$1" > $FEED_BOOKMARKS/$2
		echo -e "\\n\\t\\e[01;37m==> \\e[01;31mBookmark saved as \\e[01;36m\\e[04m$2\\e[00m\\e[01;37m <==\\e[00m\\n"
	fi
}

deef() {
	if test -n "$1"; then
		if [ ! -r "$FEED_BOOKMARKS/$1" ]; then
			echo -e "\\n \\e[01;31mBookmark \\e[01;36m\\e[04m$1\\e[00m\\e[01;31m not found.\\e[00m\\n\\n \\e[04mType:\\e[00m\\n\\n   \\e[01;37m\$ deef\\e[00m (without arguments)\\n\\n to get the complete list of all currently saved bookmarks.\\n";
			return 1;
		fi
		local url="$(cat $FEED_BOOKMARKS/$1)";
		if [ ! -n "$url" ]; then
			echo "The bookmark is empty";
			return 1;
		fi
		echo -e "\\n\\t\\e[01;37m==> \\e[01;31m$url\\e[01;37m <==\\e[00m"
		feed "$url";
	else
		echo -e "\\n \\e[04mUsage\\e[00m\\n\\n   \\e[01;37m\$ deef \\e[01;31m<bookmark>\\e[00m\\n\\n \\e[04mCurrently saved bookmarks\\e[00m\\n";
		for i in $(find $FEED_BOOKMARKS -maxdepth 1 -type f);
			do echo -e "   \\e[01;36m\\e[04m$(basename $i)\\e[00m";
		done;
		echo -e "\\n \\e[04mSee also\\e[00m\\n\\n   \\e[01;37m\$ feed\\e[00m\\n";
	fi;
}
note () {
    # if file doesn't exist, create it
    if [[ ! -f $HOME/.notes ]]; then
        touch "$HOME/.notes"
    fi

    if ! (($#)); then
        # no arguments, print file
        cat "$HOME/.notes"
    elif [[ "$1" == "-c" ]]; then
        # clear file
        printf "%s" > "$HOME/.notes"
    else
        # add all arguments to file
        printf "%s\n" "$*" >> "$HOME/.notes"
    fi
}
todo() {
    if [[ ! -f $HOME/.todo ]]; then
        touch "$HOME/.todo"
    fi

    if ! (($#)); then
        cat "$HOME/.todo"
    elif [[ "$1" == "-l" ]]; then
        nl -b a "$HOME/.todo"
    elif [[ "$1" == "-c" ]]; then
        > $HOME/.todo
    elif [[ "$1" == "-r" ]]; then
        nl -b a "$HOME/.todo"
        eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\}; echo
        read -p "Type a number to remove: " number
        sed -i ${number}d $HOME/.todo "$HOME/.todo"
    else
        printf "%s\n" "$*" >> "$HOME/.todo"
    fi
}
calc() {
    echo "scale=3;$@" | bc -l
}

## Use git completion
if [ -e ~/.git-completion.sh ] ; then
  source ~/.git-completion.sh
fi

function rot13 {
    args={"$@"}
    echo "`echo $@ | tr A-Za-z N-ZA-Mn-za-m`"
}

alias vi='vim'
export EDITOR=vim

alias ducks='du -cks * | sort -rn | head -n 20'
alias gc='git checkout'
alias gd='git diff'
alias gs='git status'
alias gb='git branch'
alias gl='git log'

alias b='(cd ..; make)'
alias m='make'
alias mm='make'
alias make='time make -j2'

which xdg-open > /dev/null
if [ $? -eq 0 ] ; then
	alias open='xdg-open'
fi
export MAKE_FLAGS='-j 2 --quiet'


# WebKit
export WEBKITDIR=$HOME/dev/webkit/
#export DISABLE_NI_WARNING=1


# Google Chrome junk
export CHROME_REVIEW_EMAIL=`rot13 vprsbk@tznvy.pbz`
export CHROME=$HOME/dev/chromium_real
export PATH=$CHROME/chromium_tools:$CHROME/git-cl/:$CHROME/linux:$PATH


### Support for switching between multiple Qt repositories

export PATHSAVE="$PATH"
export LDSAVE="$LD_LIBRARY_PATH"

function qs
{
    if [ ! -z $1 ] ; then
        export QTVERSION="$1"
        if [ $1 == "none" ] ; then
            export QTDIR=""
            export PATH="$PATHSAVE"
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
        else
            export QTDIR="$HOME/dev/$1"
            export PATH="$QTDIR/bin:$PATHSAVE"
            export LD_LIBRARY_PATH="$QTDIR/lib:$LD_LIBRARY_PATH"
        fi
    fi
    echo "Using Qt: $QTVERSION";
}

alias qcd='cd $QTDIR'
qs qt-snapshot

_complete_qs() {
    branches=`(cd $HOME/dev/;ls -d qt*/)`
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "none ${branches}" -- ${cur}) )
}
complete -F _complete_qs qs


### Add Git to my Shell

function parse_git_dirty {
  git diff --quiet > /dev/null 2> /dev/null  || echo " ⚡"
  }
  
  function parse_git_dirty2 {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "⚡"
  }

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}
export PS1='\u@\h \[\033[0m\]\w\[\033[0m\]$(parse_git_branch)$ '

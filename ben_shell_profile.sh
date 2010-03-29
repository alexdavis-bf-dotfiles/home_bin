#
# Customize my bash profile with various functions and alias's
#

export PATH=$PATH:$HOME/bin:$HOME/git/home_bin

## Use git completion
if [ -e ~/.git-completion.sh ] ; then
  source ~/.git-completion.sh
fi

function rot13 {
    args={"$@"}
    echo "`echo $@ | tr A-Za-z N-ZA-Mn-za-m`"
}

# teaches aspell about a word
function learn {
    args={"$@"}
    echo $@ >> $HOME/.aspell.en.pws
}

alias vi='vim'
export EDITOR=vim

alias ducks='du -cks * | sort -rn | head -n 20'
alias gc='git checkout'
alias gd='git diff'
alias gs='git status'
alias gb='git branch'
alias gl='git log'
alias ga='git commit --amend'
function gsc { git show $1 | source-highlight --src-lang=C --out-format=esc; }

alias m='make'
alias mm='make'
alias make='time make -j2'
alias b='(cd ..; make)'
alias c='(cd ..; cd ..;make)'
export MAKE_FLAGS='-j 2'

which xdg-open > /dev/null
if [ $? -eq 0 ] ; then
	alias open='xdg-open'
fi


# WebKit
export WEBKITREPO=$HOME/git/webkit/
#export WEBKITDIR=$WEBKITREPO
export PATH=$PATH:$WEBKITREPO/WebKitTools/Scripts/
#export DISABLE_NI_WARNING=1


# Google Chrome junk
#export CHROME_REVIEW_EMAIL=`rot13 vprsbk@tznvy.pbz`
#export CHROME=$HOME/git/chromium_real
#export PATH=$CHROME/chromium_tools:$CHROME/git-cl/:$CHROME/linux:$PATH


### Support for switching between multiple Qt repositories

export PATHSAVE="$PATH"
export LDSAVE="$LD_LIBRARY_PATH"

function qs
{
    if [ ! -z $1 ] ; then
        choice=$1
        if [[ (! -d $HOME/git/$1) && (-d $HOME/git/qt-$1) ]] ; then
            choice="qt-$1";
        fi
        if [[ ($1 == "none") || (! -d $HOME/git/$choice) ]] ; then
            export QTDIR=""
            export PATH="$PATHSAVE"
            export LD_LIBRARY_PATH="$LDSAVE"
            export QTVERSION="none"
        else
            export QTDIR="$HOME/git/$choice"
            export PATH="$QTDIR/bin:$PATHSAVE"
            export LD_LIBRARY_PATH="$QTDIR/lib:$LDSAVE"
            export QTVERSION="$1"
        fi
    fi
    echo "Using Qt: $QTVERSION";
}

alias qcd='cd $QTDIR'
qs 4.6

_complete_qs() {
    branches=`(cd $HOME/git/;ls -d qt*/)`
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

# include git achievements
export PATH=$PATH:$HOME/git/git-achievements
alias git='git-achievements'

# include git hooks
export PATH=$PATH:$HOME/git/git-hooks

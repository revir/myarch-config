# mark
export CMARKPATH=$HOME/.marks

function c {
    local m=$1
    if [ "$m" = "" ]; then 
        c show
    elif [[ "$m" = "show" ]]; then
        ls -l "$CMARKPATH" | grep ^l | sed 's/\s\s*/ /g' | cut -d ' ' -f 9-

    elif [[ "$m" = "mark" ]]; then
        c setmark "$(pwd)" "$2"  

    elif [[ "$m" = "setmark" ]]; then
        mkdir -p "$CMARKPATH"
        local target=$(realpath "$2")
        local name="$3"
        if [[ -z "$target" || -z "$name"  || ! (-d "$target") ]]; then
            echo "wrong argument!"
            echo "------------------"
            c help
        fi
        
        echo "setmark $target $name"
        rm -f "$CMARKPATH/$name"
        ln -s "$target" "$CMARKPATH/$name"

    elif [[ "$m" = "unmark" ]]; then
        local name="$2"
        if [ "$name" = "" ]; then 
            echo "wrong argument!"
            echo "------------------"
            c help
        fi
        rm -f "$CMARKPATH/$name"

    elif [[ "$m" = "help" ]]; then
        echo
        echo "welcome to use dir mark!"
        echo "usage: "
        echo "c [show]"
        echo "c mark <shortname>"
        echo "c setmark <directory> <shortname>"
        echo "c unmark <shortname>"
        echo "c <shortname>"
        echo
        echo "these option mean:"
        echo "show          show all the marks."
        echo "mark          mark current directory."
        echo "setmark       mark any directory you set."
        echo "unmark        unmark the directory."
        echo

    else
        cd -P "$CMARKPATH/$m" 2>/dev/null || echo "No such mark: $m"
    fi
}

_completemarks_bash() {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(ls $CMARKPATH)
    COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
    return 0
}

function _completemarks_zsh {
  reply=($(ls $CMARKPATH))
}

if [[ $(basename $SHELL) = 'zsh'  ]]; then
    compctl -K _completemarks_zsh c

elif [[ $(basename $SHELL) = 'bash' ]]; then
    complete -F _completemarks_bash c
fi





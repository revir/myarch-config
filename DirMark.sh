# mark
export GMARKPATH=$HOME/.marks

function g {
    local m=$1
    if [ "$m" = "" ]; then 
        g show
    elif [[ "$m" = "show" ]]; then
        ls -l "$GMARKPATH" | grep ^l | sed 's/\s\s*/ /g' | cut -d ' ' -f 9-

    elif [[ "$m" = "mark" ]]; then
        g setmark "$(pwd)" "$2"  

    elif [[ "$m" = "setmark" ]]; then
        mkdir -p "$GMARKPATH"
        local target=$(realpath "$2")
        local name="$3"
        if [[ -z "$target" || -z "$name"  || ! (-d "$target") ]]; then
            echo "wrong argument!"
            echo "------------------"
            g help
        fi
        
        echo "setmark $target $name"
        rm -f "$GMARKPATH/$name"
        ln -s "$target" "$GMARKPATH/$name"

    elif [[ "$m" = "unmark" ]]; then
        local name="$2"
        if [ "$name" = "" ]; then 
            echo "wrong argument!"
            echo "------------------"
            g help
        fi
        rm -f "$GMARKPATH/$name"

    elif [[ "$m" = "help" ]]; then
        echo
        echo "welcome to use gmark!"
        echo "usage: "
        echo "g [show]"
        echo "g mark <shortname>"
        echo "g setmark <directory> <shortname>"
        echo "g unmark <shortname>"
        echo "g <shortname>"
        echo
        echo "these option mean:"
        echo "show          show all the marks."
        echo "mark          mark current directory."
        echo "setmark       mark any directory you set."
        echo "unmark        unmark the directory."
        echo

    else
        cd -P "$GMARKPATH/$m" 2>/dev/null || echo "No such mark: $m"
    fi
}

# _completemarks() {
#     local curw=${COMP_WORDS[COMP_CWORD]}
#     local wordlist=$(ls -l "$MARKPATH" | grep ^l | cut -d ' ' -f 13)
#     COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
#     return 0
# }
#complete -F _completemarks g unmark

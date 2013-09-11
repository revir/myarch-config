# mark
export MARKPATH=$HOME/.marks
export MARKDEFAULT=ws  #设置你的默认书签，可以直接输入g跳转

function g {
    local m=$1
    if [ "$m" = "" ]; then m=$MARKDEFAULT; fi
    cd -P "$MARKPATH/$m" 2>/dev/null || echo "No such mark: $m"
}
function mark {
    mkmark "$(pwd)" "$1"
}
function mkmark {
    mkdir -p "$MARKPATH"
    local m=$2
    if [ "$m" = "" ]; then m=$MARKDEFAULT; fi
    rm -f "$MARKPATH/$m"
    ln -s "$1" "$MARKPATH/$m"
}
function unmark {
    local m=$1
    if [ "$m" = "" ]; then m=$MARKDEFAULT; fi
    rm -i "$MARKPATH/$m"
}
function gs {
    ls -l "$MARKPATH" | grep ^l | sed 's/\s\s*/ /g' | cut -d ' ' -f 9-
}

_completemarks() {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(ls -l "$MARKPATH" | grep ^l | cut -d ' ' -f 13)
    COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
    return 0
}

#complete -F _completemarks g unmark

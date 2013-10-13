#Save files to this repository.
export SAVETOHERE_DIR="$(pwd)"
export SAVETOHERE_LIST="$SAVETOHERE_DIR/.savelist"

function s {
    local m=$1
    if [ "$m" = "" ]; then 
    	s show

    elif [[ "$m" = "init" ]]; then
        #init
        echo "original place, file name, add date" > $SAVETOHERE_LIST

    elif [[ "$m" = "add" ]]; then
        #add file to this repository
        local target=$2
        if [[ -d $target ]]; then
            #if it is a dir
            echo 'dir'  
        elif [[ -f $target ]]; then
            #if it is a file
            local name=$(basename $target)
            local realpath=$(realpath $target)
            local targetdir=$(realpath $(dirname $target))

            #move the file to repository
            mv "$target" "$SAVETOHERE_DIR"
            #make a link
            ln -s  "$SAVETOHERE_DIR/$name" "$targetdir/$name"
            #add a report to the savelist
            echo "$realpath, $name, $(date)" >> "$SAVETOHERE_LIST"
            #done!
            echo "add $realpath to repository"

        else
            echo 'else'
        fi

    elif [[ "$m" = "edit" ]]; then
        #edit file in this repository
        local name=$2
        if [[ -f "$name" ]]; then
            $EDITOR "$name"
        else
            name="$SAVETOHERE_DIR/$name"
            echo $name
        fi

        if [[ -f "$name" ]]; then
            $EDITOR "$name"
        else
            echo "wrong file name, no such file!"
        fi

    elif [[ "$m" = "show" ]]; then
        #show saved files
        echo "The repository is at $SAVETOHERE_DIR"
        echo
        cat $SAVETOHERE_LIST

    elif [[ "$m" = "apply" ]]; then
        #apply all this files, which means make soft links to the original file place
        echo apply

    elif [[ -d $m || -f $m ]]; then
    	#if it is a dir
    	s add $m

    else
        echo 'wrong argument!'
    fi
}

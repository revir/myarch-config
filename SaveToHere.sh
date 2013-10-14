#Save files to this repository.
export SAVETOHERE_DIR="$(pwd)"
export SAVETOHERE_LIST="$SAVETOHERE_DIR/.savelist"

function s {
    local m=$1
    if [ "$m" = "" ]; then 
    	s show

    elif [[ "$m" = "init" ]]; then
        #init
        echo "original place,file name,add date" > $SAVETOHERE_LIST

    elif [[ "$m" = "add" ]]; then
        #add file to this repository
        local target=$2
        echo "target: $target"
        if [[ -d "$target" ]]; then
            #if it is a dir
            echo 'sorry, dir is not supported yet!'  
        elif [[ -f "$target" ]]; then
            #if it is a file

            #if it already exists in this repository
            if [[ "exist" = $(s exist $target) ]]; then
                echo "sorry, the file already exists in this repository!"
            else
                local name=$(basename $target)
                local realpath=$(realpath $target)
                local targetdir=$(realpath $(dirname $target))

                #move the file to repository
                mv "$target" "$SAVETOHERE_DIR"
                #make a link
                ln -s  "$SAVETOHERE_DIR/$name" "$targetdir/$name"
                #add a report to the savelist
                echo "$realpath,$name,$(date)" >> "$SAVETOHERE_LIST"
                #done!
                echo "add $realpath to repository"
            fi
        else
            echo "sorry, we don't support this file"
        fi

    elif [[ "$m" = "exist" ]]; then
        #statements
        local name=$2
        if [[ -f "$name" ]]; then
            name=$(basename $name)
        fi
        name="$SAVETOHERE_DIR/$name"

        if [[ -f "$name" ]]; then
            echo "exist"
        else
            echo "not exist"
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
        grep ^/ $SAVETOHERE_LIST | while read LINE
        do
            local ap="$(echo $LINE | cut -d ',' -f1)"
            local an="$(echo $LINE | cut -d ',' -f2)"
            if [[ -f "$ap" || -L "$ap" ]]; then
                #statements
                echo "$ap already exists, warning!"
            else
                ln -s  "$SAVETOHERE_DIR/$an" "$ap"
                echo "apply $an!"
            fi
        done

    elif [[ -d $m || -f $m ]]; then
    	#if it is a dir
    	s add $m

    else
        echo 'wrong argument!'
    fi
}

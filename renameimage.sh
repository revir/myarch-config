#this program is just for learn and test
#
function renameimage {
	local target=$1
	echo "target: $target"
	if [[ -z $target ]]; then
		#statements
		echo 'error'
	else

		local name=$(basename $target)
		local newname=$name

		declare -l newname
		newname=$name

		if [[ "$name" = "$newname" ]]; then
			#statements
			echo "$name equal"
		else
			mv "$name" "$newname"
			# echo "$name   $newname"
		fi
	fi
}

for file in $(ls .)
do
	renameimage $file
done



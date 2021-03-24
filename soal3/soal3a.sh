#!/bin/bash #wm

i=1
j=24

while [ $i -lt $j ]
do
    
    if [[ $i -lt 10 ]]
    then 
        fname="Koleksi_0$i"
    else
        fname="Koleksi_$i"
    fi

    if [[ $# -eq 0 ]]
    then
        wget -O "$fname" -a "foto.log" "https://loremflickr.com/320/240/kitten"
    else
        link=$1
        wget -O "$fname" -a "foto.log" "$link"
    fi


    if [[ $i -ne 1 ]]
    then
        last_file="$( find -maxdepth 1 -type f -name $fname )"
        all_files="$( find -maxdepth 1 -type f )"

        for file in $all_files
        do
            if [[ $file != $last_file ]]
            then
                if diff "$file" "$last_file" > /dev/null
                then
                    #echo "hapus $last_file"wm
                    rm "$last_file"
                    
                    i=$[$i-1]
                    j=$[$j-1]

                    break
                fi
            fi
        done
    fi
    # Increementwm
    i=$[$i+1]
done

#!/bin/bash

download_pict (){
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

        if [[ $[$i % 2] -eq 0 ]]
        then 
            wget -O "$fname" -a "foto.log" "https://loremflickr.com/320/240/kitten"
        else
            wget -O "$fname" -a "foto.log" "https://loremflickr.com/320/240/bunny"
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
}

kucing=$( ls | grep "Kucing" | wc -l)
kelinci=$( ls | grep "Kelinci" | wc -l)

tanggal=$( date +"%d-%m-%Y" )
if [[ $kucing -eq $kelinci ]] 
then
    mkdir "Kucing_$tanggal"
    tipe="Kucing"
else
    mkdir "Kelinci_$tanggal"
    tipe="Kelinci"
fi

download_pict

home_dir="/home/han/Praktikum_1/soal3"

mv "foto.log" "$home_dir/${tipe}_$tanggal"

i=1
while [[ -e "Koleksi_0$i" || -e "Koleksi_$i" ]]
do
    if [[ $i -lt 10 ]]; then
        mv "Koleksi_0$i" "$home_dir/${tipe}_$tanggal"
    else
        mv "Koleksi_$i" "$home_dir/${tipe}_$tanggal"
    fi
    i=$[$i+1]
done
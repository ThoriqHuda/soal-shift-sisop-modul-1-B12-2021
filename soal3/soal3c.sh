#!/bin/bash

download_pict (){
    link=$1
    bash soal3a.sh $link
}

kucing=$( ls | grep "Kucing" | wc -l)
kelinci=$( ls | grep "Kelinci" | wc -l)

tanggal=$( date +"%d-%m-%Y" )
if [[ $kucing -eq $kelinci ]] 
then
    mkdir "Kucing_$tanggal"
    download_pict "https://loremflickr.com/320/240/kitten"
    tipe="Kucing"
else
    mkdir "Kelinci_$tanggal"
    download_pict "https://loremflickr.com/320/240/bunny"
    tipe="Kelinci"
fi

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
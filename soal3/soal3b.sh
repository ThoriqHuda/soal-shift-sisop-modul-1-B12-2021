#!/bin/bash

bash "soal3a.sh"

tanggal=$( date +"%d-%m-%Y" )

mkdir "$tanggal"

home_dir="/home/han/Praktikum_1/soal3"

mv "foto.log" "$home_dir/$tanggal"

i=1
while [[ -e "Koleksi_0$i" || -e "Koleksi_$i" ]]
do
    if [[ $i -lt 10 ]]; then
        mv "Koleksi_0$i" "$home_dir/$tanggal"
    else
        mv "Koleksi_$i" "$home_dir/$tanggal"
    fi
    i=$[$i+1]
done

#!/bin/bash

tanggal=$( date +"%m%d%Y" )

all_dir=$( find -maxdepth 1 -type d | grep -o "[^.\/].*")

zip "Koleksi.zip" -m -r $all_dir -P "$tanggal"


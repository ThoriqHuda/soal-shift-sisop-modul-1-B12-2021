#!/bin/bash
awk '
BEGIN {FS="\t"}

# Sub Soal A
{if (max_PP<=$21/($18-$21)*100) {
max_PP=$21/($18-$21)*100
max_idx=$1
}}
#---------------

# Sub Soal B
{if ($10=="Albuquerque" && $2~"-2017-") {iter[$7]++}}
#---------------

# Sub Soal C
{
if ($8=="Consumer") consumer+=1
else if ($8=="Corporate") corporate+=1
else if ($8=="Home Office") homeoffice+=1
}
#---------------

# Sub Soal D
{
if ($13 == "West" || $13 == "East" || $13 == "South" || $13 == "Central")
array[$13]+=$21
}
#---------------

END {
# Hasil Sub Soal A
printf "Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %.2f%%.\n", max_idx, max_PP
#---------------

# Hasil Sub Soal B
printf "\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:\n"
for (nama in iter) {
   printf "%s\n", nama
}
#---------------

# Hasil Sub Soal C
printf "\nTipe segmen customer yang penjualannya paling sedikit adalah "
if (consumer < corporate) {
   if (consumer < homeoffice)
      printf "%s dengan %d\n", "Customer", consumer
   else
      printf "%s dengan %d\n", "Home Office", homeoffice
}
else {
   if (corporate < homeoffice)
      printf "%s dengan %d\n", "Corporate", corporate
   else
      printf "%s dengan %d\n", "Home Office", homeoffice
}
#---------------

# Hasil Sub Soal D
min_profit=9999999
for (i in array) {
  if (min_profit > array[i]) {
    min_profit = array[i]
    min_reg=i
  }
}
printf "\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.2f\n", min_reg, min_profit
#---------------

}

' /home/han/Downloads/Laporan-TokoShiSop.tsv > hasil.txt

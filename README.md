# Laporan Penjelasan dan Penyelesaian Soal

## Soal 1

## Soal 2
Menggunakan **awk** untuk mengecek tiap baris data.
```
#!/bin/bash
awk '
BEGIN {FS="\t"}
```
FS adalah field separator, field dipisahkan dengan ```\t``` tab

### a. Profit Percentage
Membandingkan profit percentage dengan profit percentage baris selanjutnya, lalu simpan Row ID nya. 

Membandingkan profit percentage dengan profit percentage beris selanjutnya:
```
{if (max_PP<=$21/($18-$21)*100) {
```
```max_PP``` adalah variabel untuk menyimpan profit percentage terbesar.\
```$21``` untuk mengakses kolom profit.\
```$18``` untuk mengakses kolom sales. 

Jika profit percentage baris selanjutnya lebih besar, maka max_PP berubah menjadi profit percentage baris tersebut dan Row ID-nya disimpan:
```
max_PP=$21/($18-$21)*100
max_idx=$1
}}
```
```max_idx``` adalah variabel untuk menyimpan Row ID.\
```$1``` untuk mengakses kolom Row ID. 

Format untuk men-display hasil:
```
{
printf "Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan
persentase %.2f%%.\n", max_idx, max_PP
```

Hasilnya adalah seperti berikut
```
Transaksi terakhir dengan profit percentage terbesar yaitu 9952 dengan persentase 100.00%.
```

### b. Nama customer tahun 2017 di Albuquerque
Mencari customer yang memiliki transaksi tahun 2017 dan di kota Albuquerque, lalu simpan nama customernya. 

Cari 'Albuquerque' di kolom City dan '-2017-' di kolom Order ID, lalu simpan nama customernya di array:
```
{if ($10=="Albuquerque" && $2~"-2017-") {iter[$7]++}}
```
```$10=="Albuquerque"``` untuk mencari baris yang terdapat 'Albuquerque' dari $10 (kolom City).\
```$2~"-2017-"``` untuk mencari baris yang mengandung ( ~ ) '-2017-' dari $2 (kolom Order ID). Adanya tanda '-' yang mengapit 2017 agar hanya mengambil angka yang berada diantara '-' saja.\
```{iter[$7]++}``` untuk menyimpan $7 (kolom Customer Name) yang memenuhi kondisi diatas sebagai index di array. 

Format untuk men-display hasil:
```
printf "\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:\n"
for (nama in iter) {
  printf "%s\n", nama
}
```
```for (nama in iter)``` untuk mengiterasi semua index di array. 

Hasilnya adalah seperti berikut
```
Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
Benjamin Farhat
David Wiener
Michelle Lonsdale
```

### c. Segment customer yang jumlah transaksinya paling sedikit
Menghitung jumlah transaksi tiap segment customer, lalu dibandingkan untuk dicari yang paling sedikit:
```
{
if ($8=="Consumer") consumer+=1
else if ($8=="Corporate") corporate+=1
else if ($8=="Home Office") homeoffice+=1
}
```
Jika pada $8 (kolom Segment) terdapat 'Consumer', maka value dari variabel consumer akan bertambah satu, dan seterusnya sesuai dengan segment dan variabelnya. 

Format untuk men-display hasil:
```
printf "\nTipe segmen customer yang penjualannya paling sedikit adalah "
if (consumer < corporate {
  if (consumer < homeoffice)
    printf "%s dengan %d transaksi.\n", "Consumer", consumer
  else
    printf "%s dengan %d transaksi.\n", "Home Office", homeoffice
}
else {
  if (corporate < homeoffice)
    printf "%s dengan %d transaksi.\n", "Corporate", corporate
  else
    printf "%s dengan %d transaksi.\n", "Home Office", homeoffice
}
```
if-else conditions dibawah printf untuk mencari jumlah transaksi paling sedikit dari ketiga variabel. 

Hasilnya adalah sebagai berikut
```
Tipe segmen customer yang penjualannya paling sedikit adalah Home Office dengan 1783 transaksi.
```

### d. Region yang memiliki total keuntungan paling sedikit
Menghitung profit dari tiap region, lalu dibandingkan untuk dicari yang paling dikit. 

Mencari 'West' atau 'East' atau 'South' atau 'Central' di $13 (kolom Region):
```
{
if ($13 == "West" || $13 == "East" || $13 == "South || $13 == "Central")
```

Disimpan di dalam array:
```
array[$13]+=$21
}
```
Index array tersebut adalah Region ($13), lalu profit tiap baris ($21) akan ditambahkan di Region yang sesuai. 

Format untuk men-display hasil:
```
min_profit=9999999
for (i in array) {
  if (min_profit > array[i]) {
    min_profit = array[i]
    min_reg = i
  }
}
printf "\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang
paling sedikit adalah %s dengan total keuntungan %2.f\n", min_reg, min_profit
```
```min_profit``` memiliki nilai terbesar sebagai alat pembanding.\
```for (i in array)``` mengiterasi semua index di array.\
if condition untuk menyimpan value array yang kecil ke variabel min_profit.\
```min_reg``` untuk menyimpan indeks region yang memiliki profit terkecil. 

Hasilnya adalah sebagai berikut
```
Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling
sedikit adalah Central dengan total keuntungan 39706.36
```

awk ditutup dengan 
```
END
```
### e. File.txt
Script menghasilkan file 'hasil.txt' menggunakan tanda ``` > ``` :
```
' /home/han/Downloads/Laporan-TokoShiSop.tsv > hasil.txt
``` 

## Soal 3
cobabdwbdw

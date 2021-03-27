# Laporan Penjelasan dan Penyelesaian Soal

## Soal 1

## Soal 2
Menggunakan **awk** untuk mengecek tiap baris data.
```bash
BEGIN {FS="\t"}
```
FS adalah field separator, field dipisahkan dengan ```\t```tab

### a. Profit Percentage
Membandingkan profit percentage dengan profit percentage baris selanjutnya, lalu simpan Row ID nya.

Membandingkan profit percentage dengan profit percentage beris selanjutnya:
```bash
{if (max_PP<=$21/($18-$21)*100)
```
```max_PP``` adalah variabel untuk menyimpan profit percentage terbesar.
```$21``` untuk mengakses kolom profit.
```$18``` untuk mengakses kolom sales.

Jika profit percentage baris selanjutnya lebih besar, maka max_PP berubah menjadi profit percentage baris tersebut dan Row ID-nya disimpan:
```bash
max_PP
```
### b. Nama customer tahun 2017 di Albuquerque

### c. Segment customer yang jumlah transaksinya paling sedikit

### d. Region yang memiliki total keuntungan paling sedikit

## Soal 3
cobabdwbdw

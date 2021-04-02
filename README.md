# Laporan Penjelasan dan Penyelesaian Soal

## Soal 1
### 1.d
Mencari jumlah kemunculan setiap jenis pesan error.\
Menggunakan regex untuk membagi file syslog.log 
```bash
regex="(ERROR )(.*)(\ .*\))"
```
Di mana grup 1 adalah ERROR, grup 2 adalah pesan error, dan grup 3 adalah semua setelah pesan error<br><br> 

```bash
While read -r l
	do
	 global_rematch "$l" "$regex"
	done < "$file_used"
```
Membaca setiap line dari syslog.log, dan menggunakannya beserta regex sebagai argument untuk fungsi global rematch.<br><br>

```bash
global_rematch(){
	    local line=$1 regex=$2
	    while [[ $line =~ $regex ]]; do
	        if [[ ${BASH_REMATCH[2]} = "Ticket doesn't exist" ]]
	        then
	         idx="Ticket doesn\'t exist"
	         ((map["$idx"]++))
	        else
	         ((map["${BASH_REMATCH[2]}"]++))
	        fi
	        line=${line#*"${BASH_REMATCH[0]}"}
	    done
	}

```
Fungsi ini Menggunakan associative array **map** untuk menghitung berapa kali sebuah pesan error muncul pada syslog.log.
**BASH_REMATCH[2]** adalah grup 2 dari regex yaitu pesan error.\
**map["${BASH_REMATCH[2]}"]++** berarti jumlah kemunculan pesan error yang ada di line ditambah 1\
Menambahkan **map["${BASH_REMATCH[2]}"]** untuk setiap line<br/><br/>


```bash
        if [[ ${BASH_REMATCH[2]} = "Ticket doesn't exist" ]]
        then
         idx="Ticket doesn\'t exist"
         ((map["$idx"]++))
```
Bagian ini berjalan jika pesan error adalah “Ticket doesn’t exist”. Karakter ’ pada kata “doesn’t” dapat menyebabkan error, sehingga pesan error diganti menjadi tidak mengandung karakter ‘<br><br>
```bash
echo "Error,Count" > error_message.csv
	for i in "${!map[@]}"
	do
	 echo "${map[$i]},$i"
	done | sort -nr | while read -r ll
	do
	 global_rematch_again "$ll" "$regex2"
	done >> error_message.csv
```
Mengoutput pesan dan jumlah dalam format **jumlah,pesan**. Menggunakan format ini agar bisa di sort menggunakan jumlah muncul pesannya denagn **sort -nr**. Setelah itu melakukan output ulang dengan menggunakan fungsi **global_rematch_again**. Menggunakan argument line dan **regex2** yaitu
```bash
regex2="(.*)(,)(.*)
```
Dimana grup 1 adalah semua sebelum koma yaitu jumlah, grup 2 adalah koma, dan grup 3 adalah semua setelahnya yaitu pesan.<br><br>
```bash
global_rematch_again(){
	    local line=$1 regex=$2
	    while [[ $line =~ $regex ]]; do
	        echo "${BASH_REMATCH[3]},${BASH_REMATCH[1]}"
	        line=${line#*"${BASH_REMATCH[0]}"}
	    done
	}
```
Fungsi ini mengoutput ulang dengan format **pesan,jumlah**.\
Setelah itu output diappend ke file **error_message.csv**
<br><br>
### 1.e
Mencari jumlah kemunculan ERROR dan INFO dari setiap user.
File syslog.log dibagi menggunakan regex
```bash
regex3="(ERROR|INFO)(.*\()(.*)(\))"
```
Dimana grup 1 adalah ERROR atau INFO yaitu jenis log, grup 2 adalah semua sebelum dan juga karakter “(“, grup 3 adalah semua diantara karakter “(“ dan “)” yaitu adalah username, dan grup 4 adalah karakter “)”.<br><br>
```bash
while read -r lll
	do
	 global_rematch2 "$lll" "$regex3"
	done < "$file_used"
 ```
Membaca syslog.log per line dan menggunakannya beserta **regex3** sebagai argument untuk fungsi **global_rematch2** 
```bash
global_rematch2(){
	    local line=$1 regex=$2
	    while [[ $line =~ $regex ]]; do
	        if [[ ${BASH_REMATCH[1]} = "ERROR" ]]
	        then
	        ((err["${BASH_REMATCH[3]}"]++))
	        else
	        ((info["${BASH_REMATCH[3]}"]++))
	        fi
	        line=${line#*"${BASH_REMATCH[0]}"}
	    done
	}

``` 
Menggunakan Associative array **err** dan **info** untuk menghitung jumlah kemunculan jenis log untuk setiap user.
Jika jenis log adalah ERROR maka jumlah error untuk user tersebut ditambah 1 menggunakan **err["${BASH_REMATCH[3]}"]++**. Jika jenis log adalah info maka jumlah info user ditambah dengan **info["${BASH_REMATCH[3]}"]++**
Setelah mendapatkan jumlah ERROR dan INFO untuk setiap user maka dioutput dengan :
```bash
echo "Username,INFO,ERROR" > user_statistic.csv
	for i in "${!err[@]}"
	do
	

	 if [[ ${err[$i]} -eq 0 ]]
	 then
	 ((err["$i"]=0))
	 fi
	

	 if [[ ${info[$i]} -eq 0 ]]
	 then
	 ((info["$i"]=0))
	 fi
	

	 echo "$i,${info[$i]},${err[$i]}"
	done | sort -n >> user_statistic.csv

```
Mengoutput username dan jumlah ERROR dan INFO ke file **user_statistic.csv**. jika seorang user tidak pernah mendapatkan pesan ERROR atau INFO maka tidak akan ada outputnya di **user_statistic.csv**. Oleh karena itu dilakukan ```err["$i"]=0``` atau ```info["$i"]=0``` agar terdapat outputnya.

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

### a. 
Langkah mendasar untuk menyelesaikan poin ini tentunya adalah dengan men-download file pada link secara berulang (dengan loop)
```bash
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
```
Dengan menggunakan command 'wget', kita dapat mendownload file pada link. Gunakan options '-a' untuk menyimpan log dari script dalam "foto.log". Untuk penggunaan argumen pada kode ini akan dipakai pada problem 3c sehingga tidak akan dibahas disini.

Lalu, agar tidak ada image yang duplikat, lakukan pengecekan setelah berhasil men-download file pada langkah sebelumnya
```bash
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
```
Kode diatas akan mengecek kembali dari awal apakah image yang baru saja di-download adalah duuplikat dengan mengeceknya satu per satu dengan command "diff". Ketika ditemukan, lakukan remove pada image yang baru saja di-download dengan command "rm". lalu kurangi counter (dalam kasus ini variabel i) dan batas atas counternya (variabel j).
Kode - kode tersebut akan di loop dengan counter i (awalnya 1) dan batas atas j (awalnya 24).

### b.
Pada kasus yang kedua ini, kita membutuhkan bantuan dari kode pada kasus a untuk mendownload image kembali. Sehingga akan dieksekusi terlebih dahulu script soal3a.sh .
```bash
bash "soal3a.sh"
```
Lalu, kita tinggal memindahkan semua file yang diminta dengan menggunakan command "mv"
```bash
tanggal=$( date +"%d-%m-%Y" )

mkdir "$tanggal"

home_dir="/home/han/PrakSis/P3"

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
```
Command "mkdir" akan membuat directory sesuai dengan nama pada variabel 'tanggal'. Pindahkan foto.log kedalam directory tersebut. Dan terakhir, gunakan loop untuk memindahkan file yang telah di download kedalam directory yang baru saja dibuat.

Agar kode dapat dieksekusi sesuai permintaan pada soal, kita menggunakan crontab
```bash
0 20 1-31/7,2-31/4 * * cd /home/han/PrakSis/P3 && bash soal3b.sh
```
0 20 menyatakan pukul 20.00, 1-31/7 menyatakan tiap hari ketujuh dimulai dari tanggal 1, dan 2-31/4 menyatakan tiap hari keempat dimulai dari tanggal 2.

### c.
Ide utama untuk menyelesaikan kasus ini adalah dengan menghitung jumlah folder yang berawalan "Kucing" dan "Kelinci".
```bash
kucing=$( ls | grep "Kucing" | wc -l)
kelinci=$( ls | grep "Kelinci" | wc -l)
```
Command tersebut akan menghasilkan jumlah file pada directory yang mengandung kata "Kucing" dan "Kelinci" (Berhubung file yang memiliki kata tersebut hanya folder hasil eksekusi soal3c.sh sehingga kita dapat menggunakan grep).

Ketika jumlah antara "Kucing" dan "Kelinci" sama, kode akan mendownload "Kucing" dan jika berbeda akan mendownload "Kelinci"
```bash
tanggal=$( date +"%d-%m-%Y" )
if [[ $kucing -eq $kelinci ]] 
then
    mkdir "Kucing_$tanggal"
    tipe="Kucing"
else
    mkdir "Kelinci_$tanggal"
    tipe="Kelinci"
fi
download pict
```
buat direktori, download, dan set variabel "tipe" (agar lebih mudah kedepannya) sesuai jumlah folder tersebut.

fungsi download_pict akan mendownload Koleksi foto secara selang seling. fungsi ini mirip dengan soal 3a dalam proses pengecekan foto yang samanya.
```bash
download_pict(){
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
```
perbedaannya terletak pada proses download yang dilakukan secara selang seling.

Dan terakhir, lakukan hal yang sama seperti pada soal3b.sh, yaitu memindahkan file ke direktori yang telah dibuat.
```bash
home_dir="/home/han/PrakSis/P3"

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
```

### d.
Pada kasus 3d, kita diminta untuk melakukan zip pada folder - folder yang telah dibuat sebelumnya. Gunakan beberapa command berikut :
```bash
#!/bin/bash

tanggal=$( date +"%m%d%Y" )

all_dir=$( find -maxdepth 1 -type d | grep -o "[^.\/].*")

zip "Koleksi.zip" -m -r $all_dir -P "$tanggal"
```
command pada variabel all_dir akan mengambil semua folder pada direktori sekarang. lalu gunakan command "zip" untuk melakukan zip kesemua folder itu sekaligus.

### e.
```bash
0 7 * * 1-5 cd /home/han/PrakSis/P3/ && bash soal3d.sh
0 18 * * 1-5 cd /home/han/PrakSis/P3/ && unzip -P $( date +"\%m\%d\%Y" ) "Koleksi.zip" && rm "Koleksi.zip"
```
0 7 dan 0 18 masing - masing menyatakan 07.00 dan 18.00, 1-5 menyatakan hari senin sampai jumat. Jalankan soal3d.sh pada crontab pertama dan gunakan command "unzip" untuk meng-unzip file zip yang telah dibuat. pilih option "-P password" agar dapat terbuka lalu hapus dengan command "rm" setelah berhasil di unzip.

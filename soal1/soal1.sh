#!/bin/bash

file_used="/home/han/Downloads/syslog.log"

# Sub Soal E
declare -A map

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

global_rematch_again(){
    local line=$1 regex=$2
    while [[ $line =~ $regex ]]; do
        echo "${BASH_REMATCH[3]},${BASH_REMATCH[1]}"
        line=${line#*"${BASH_REMATCH[0]}"}
    done
}

regex="(ERROR )(.*)(\ .*\))"
regex2="(.*)(,)(.*)"

while read -r l
do
 global_rematch "$l" "$regex"
done < "$file_used"

echo "Error,Count" > error_message.csv
for i in "${!map[@]}"
do
 echo "${map[$i]},$i"
done | sort -nr | while read -r ll
do
 global_rematch_again "$ll" "$regex2"
done >> error_message.csv
# --------END SUBSOAL D----------

# Sub Soal E
declare -A err
declare -A info

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

regex3="(ERROR|INFO)(.*\()(.*)(\))"

while read -r lll
do
 global_rematch2 "$lll" "$regex3"
done < "$file_used"

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
# --------END SUBSOAL E----------
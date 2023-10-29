#!/bin/bash 

item_file=$1
data_file=$2
user_file=$3

echo "-------------------------------------------------------"
echo "User Name: Park Min Jung"
echo "Student Number: 12193266"
echo "[ Menu ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"

echo "-------------------------------------------------------"

stop="N"
until [ $stop = "Y" ] 
do
	read -p "Enter your choice [ 1-9 ]   " choice
	case $choice in
	1)
		echo ""	
		read -p "Please enter 'movie id' (1~1682) : " movie_id
		echo ""	
		cat $item_file | awk -F\| -v a=$movie_id 'a==$1{print } ' 
		echo ""	;;
	2)
		echo ""	
		read -p "Do you want to get the data of 'action' genre from 'u.item'? (y/n) :" YN
		echo ""
		if [ $YN = "y" ]
		then
		cat $item_file | awk -F\| '$7=="1"{print $1,$2}' | sort -t\| -k1,1n | head -n 10	
		fi 
		echo""
		;;
	3)
		echo ""
		read -p "Please enter the 'movie id' (1~1682) : " movie_id
		echo ""
		cat $data_file | awk -v a=$movie_id 'a==$2 {sum+=$3; count+=1 } END {if (count >0) average_rating=sum/count} END {if (count > 0) printf ("average rating of %d : %.5f \n",a,average_rating) }  ' 
		echo ""
		;;
	4)
		echo ""
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n) :" YN
		echo ""
		if [ $YN = "y" ]
		then
		cat $item_file | sed 's/||[^|]*|/|||/g' | head -n 10		
		fi
		echo ""
		;;
	5)
		echo ""
		read -p "Do you want to get the data about users from 'u.user'? (y/n) :" YN
		echo ""
		if [ $YN = "y" ]
		then
		cat $user_file | awk -F\| '{if ($3=="F") {gender="female"}else {gender="male"}} {printf ("user %d is %d years old %s %s \n",$1,$2,gender,$4) }' | head -n 10 
		fi
		echo ""		
		;;
	6)
		echo ""
		read -p "Do you want to Modify the format of 'release data' in 'u.item'? (y/n) " YN
		echo ""
		if [ $YN = "y" ]
                then
                cat $item_file | sed 's/\([0-9]\{2\}\)-\(Jan\)-\([0-9]\{4\}\)/\301\1/g' | tail -n 10 | sed 's/\([0-9]\{2\}\)-\(Feb\)-\([0-9]\{4\}\)/\302\1/g' | sed 's/\([0-9]\{2\}\)-\(Mar\)-\([0-9]\{4\}\)/\303\1/g' | sed 's/\([0-9]\{2\}\)-\(Apr\)-\([0-9]\{4\}\)/\304\1/g' | sed 's/\([0-9]\{2\}\)-\(May\)-\([0-9]\{4\}\)/\305\1/g' |  sed 's/\([0-9]\{2\}\)-\(Jun\)-\([0-9]\{4\}\)/\306\1/g' | sed 's/\([0-9]\{2\}\)-\(Jul\)-\([0-9]\{4\}\)/\307\1/g' | sed 's/\([0-9]\{2\}\)-\(Aug\)-\([0-9]\{4\}\)/\308\1/g' | sed 's/\([0-9]\{2\}\)-\(Sep\)-\([0-9]\{4\}\)/\309\1/g' | sed 's/\([0-9]\{2\}\)-\(Oct\)-\([0-9]\{4\}\)/\310\1/g' | sed 's/\([0-9]\{2\}\)-\(Nov\)-\([0-9]\{4\}\)/\311\1/g' | sed 's/\([0-9]\{2\}\)-\(Dec\)-\([0-9]\{4\}\)/\312\1/g' > temp.txt
                cat temp.txt
                rm temp.txt
		fi
                echo ""
		;;
	7)
		echo ""
		read -p "Please enter the 'user id' (1~943) :" user_id 
		echo ""
		cat $data_file | sort -k 2,2n | awk -v user=$user_id '$1==user {printf ("%d|",$2)}'  
		echo ""
		echo ""
		awk -v user=$user_id '$1==user {print $2}' $data_file| sort -k 1,1n > user_rated_movies.txt 
		awk -F\| 'FNR==NR {a[$1]++; next} $1 in a {print $1"|"$2}' user_rated_movies.txt $item_file | head -n 10	
		echo ""
		rm user_rated_movies.txt
		;;
	8)
		echo ""
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n) :" YN
		echo ""
		if [ $YN = "y" ]
		then
		
		awk -F\| '$2>=20 && $2<=29 && $4=="programmer" {print $1}' $user_file > programmers_20s.txt
		awk 'FNR==NR {programmers[$1]++; next} $1 in programmers {sum[$2]+=$3; count[$2]++;} END {for (movie_id in sum) {avg=sum[movie_id]/count[movie_id]; printf("%d %.5f\n", movie_id, avg)}}' programmers_20s.txt $data_file| sort -k 1,1n > average_ratings.txt
 
		cat average_ratings.txt
		echo ""
		rm average_ratings.txt
		rm programmers_20s.txt

		fi
		echo ""
		;;
	9)
		echo "Bye!"
		stop="Y"
		;;
	
	esac
done
 

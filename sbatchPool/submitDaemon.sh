# to comment in pool.txt
poolFile='/thfs1/home/bbjia/myfunc/sbatchPool/pool.txt'
poolHistoryFile='/thfs1/home/bbjia/myfunc/sbatchPool/poolHistory.txt'
MaxTaskNum=29
while true
do
    # currentTask=`squeue -u bbjia | awk 'NR>1 {sum+=1}END{print sum;}'`
    currentTask=`squeue -u bbjia | awk 'NR>1 {sum+=$7}END{print sum;}'`
    currentTask=`squeue -u bbjia | wc -l`

    
    if [[ $currentTask -lt $MaxTaskNum ]]
    then
      numLine=`awk  'END{print NR}' $poolFile`
      let "j=0"
      
      while(($j<=$numLine))
      do
	  cmd=`awk -F "#" 'NR=='$j'{print}' $poolFile|awk {print}`	  
	  if [ -z "$cmd" ]
	  then
	      :
	  else
	      eval $cmd
	      # echo $cmd
	      if [ $? = 0 ]
	      then
		  echo "Succeful submition"
	      else
		  echo "Failed submition, Break now"
		  break
	      fi
	      
	      sed -i ''$j'd' $poolFile
	      echo Submit date is: `date` >>$poolHistoryFile
	      echo $cmd >> $poolHistoryFile
	      echo >>$poolHistoryFile
	      break
	  fi
	  let "j++"
      done
      
    fi
      sleep 10
done

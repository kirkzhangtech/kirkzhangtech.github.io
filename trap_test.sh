#!/bin/bash
# Removing a set trap 
# 
trap "echo ' Sorry... Ctrl-C is trapped.'" SIGINT 
# 
count=1 
while [ $count -le 5 ]
do 
 echo "Loop #$count" 
 sleep 1 
 count=$[ $count + 1 ] 
done 

trap " echo in sleeping " SIGINT
sleep 5

echo done in sleep 5 second

# Remove the trap 
trap -- SIGINT 
echo "I just removed the trap" 
# 
count=1 
while [ $count -le 5 ] 
do 
 echo "Second Loop #$count" 
 sleep 1 
 count=$[ $count + 1 ] 
done

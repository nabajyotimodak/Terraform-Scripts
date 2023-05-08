#! /bin/bash
if [[  $(sudo lsof -i:5005 | awk \ '{print $9}' | grep -v NAME) == *:5005 ]]
then
   sudo fuser -k 5005/tcp

elif [[  $(sudo lsof -i:5055 | awk \ '{print $9}' | grep -v NAME) == *:5055 ]]
then
   sudo fuser -k 5055/tcp
else
   echo "Advisory Chat Bot"
fi

# sudo fuser -k 5005/tcp
# sudo fuser -k 5055/tcp
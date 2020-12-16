#!/bin/bash

if [[ $1 == "" || $2 == "" ]]
then
	echo -e "\n========================================================================\n"
	echo "  ./AcceptMethods.sh [url] [wordlist] [user-agent] [file extension]"
	echo -e "\n========================================================================\n"
	exit
fi

echo -e "

                                                                          ▒▒▒▒▒▒    
                                                                          ▒▒▒▒▒▒▒▒░░
                                                                          ▒▒▒▒  ▒▒▒▒
                                                                          ▒▒▒▒▓▓▒▒▓▓
                                                                        ▒▒▒▒▓▓██▓▓▓▓
                                                                      ▒▒▒▒▓▓▓▓██▓▓▒▒
                                                                    ░░▒▒▓▓██    ██  
                                                                  ░░▒▒▓▓▓▓          
                                                                ▒▒▒▒▓▓░░            
                          ▒▒                                ▒▒▒▒▓▓▓▓                
                      ▒▒▓▓▒▒                          ▓▓▒▒▒▒▓▓▓▓░░                  
                          ▓▓▒▒                      ▓▓▓▓▓▓▓▓▓▓                      
                            ▒▒                    ▓▓▓▓▓▓██▓▓                        
                            ▓▓▒▒              ▒▒▓▓██████▓▓                          
                              ▒▒            ▓▓▓▓▓▓████▒▒                            
                              ▓▓▒▒      ░░▓▓▓▓▓▓████                                
                                ▒▒▒▒  ▓▓▓▓████████                                  
                              ░░▓▓▒▒▒▒▓▓▓▓████░░                                    
                            ▓▓▒▒▓▓▒▒▒▒▓▓██▓▓                                        
                          ▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓                                          
                        ░░▒▒▒▒▒▒██████▓▓▒▒                                          
                      ▒▒▒▒██▒▒▒▒▒▒▒▒██▓▓▒▒                                          
                    ▒▒▒▒▒▒▓▓▓▓▒▒▓▓▓▓████▒▒▒▒                                        
                  ▒▒▒▒▒▒▓▓▓▓██▓▓▓▓▓▓    ▓▓▒▒░░                                      
                ▒▒▒▒▒▒██▓▓▒▒▓▓▓▓██        ▓▓▒▒░░                                    
              ▓▓▒▒▓▓▓▓▒▒▒▒▓▓██░░            ▓▓▒▒                                    
          ▒▒▓▓▒▒██▒▒▒▒▓▓▓▓██                  ██▒▒                                  
        ▓▓▓▓▓▓▓▓▒▒▓▓▓▓████                      ▓▓▒▒▓▓░░                            
      ▓▓▓▓▓▓▓▓▓▓██████▓▓                        ▓▓  ██                              
  ▒▒▓▓▓▓▓▓▓▓████████                            ████                                
"

echo -e "\nHost: $1"

if [[ $4 != "" ]]
then
	echo -e "File Extension(s): $4"
fi

if [[ $3 != "" ]]
then
	echo -e "User-Agent: $3\n"
fi

if [[ $3 != "" ]]
then
	if [[ $4 != "" ]]
	then
		gobuster dir -a $3 -w $2 -u $1 -x $4 -t64|grep "(Status"|cut -d "(" -f1 > gobuster_log.txt
	fi

	if [[ $4 == "" ]]
	then
		gobuster dir -a $3 -w $2 -u $1 -t64|grep "(Status"|cut -d "(" -f1 > gobuster_log.txt
	fi

else
	gobuster dir -w $2 -u $1 -t64|grep "(Status"|cut -d "(" -f1 > gobuster_log.txt
fi

for lp in $(cat gobuster_log.txt)
do
	if [[ $3 != "" ]]
	then
		curl -X OPTIONS $1$lp -v -A $3 1>/dev/null 2>>curl_log.txt;
	else
		curl -X OPTIONS $1$lp -v 1>/dev/null 2>>curl_log.txt;
	fi
done

echo -e "\n================================="
cat curl_log.txt|grep 'OPTIONS\|Host:\|Allow:'|sed s/../"==========================\n"/
echo -e "=================================\n"

rm -rf gobuster_log.txt curl_log.txt

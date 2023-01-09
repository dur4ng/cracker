#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

export DEBIAN_FRONTEND=noninteractive

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour}Closing the program...${endColour}"
	tput cnorm
	exit 0
}
function helpPanel(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Uso: ./cracker.sh -f ./hashes.txt -p hashcat -m ntlm -l spanish${endColour}"
	echo -e "\n\t${purpleColour}f)${endColour}${yellowColour} Hashes File${endColour}"
	echo -e "\t${purpleColour}p)${endColour}${yellowColour} Program${endColour}"
    	echo -e "\t\t${redColour}hashcat${endColour}"
	echo -e "\t\t${redColour}john${endColour}"
    	echo -e "\t${purpleColour}m)${endColour}${yellowColour} Hash Mode${endColour}"
    	echo -e "\t\t${redColour}ntlm${endColour}"
    	echo -e "\t${purpleColour}l)${endColour}${yellowColour} Language Mode${endColour}"
    	echo -e "\t\t${redColour}spanish${endColour}"
    	echo -e "\t\t${redColour}english${endColour}"
    	echo -e "\t${purpleColour}u)${endColour}${yellowColour} Url List (Optional)${endColour}"
	echo -e "\t${purpleColour}h)${endColour}${yellowColour} Help Panel${endColour}\n"
    	
	exit 0
}
function dependencies(){
	tput civis
	clear; dependencies=(hashcat john rsmangler cewl)

	echo -e "${yellowColour}[*]${endColour}${grayColour} Checking required dependencies...${endColour}"
	sleep 2

	for program in "${dependencies[@]}"; do
		echo -ne "\n${yellowColour}[*]${endColour}${blueColour} Tool:${endColour}${purpleColour} $program${endColour}${blueColour}...${endColour}"

		test -f /usr/bin/$program

		if [ "$(echo $?)" == "0" ]; then
			echo -e " ${greenColour}(V)${endColour}"
		else
			echo -e " ${redColour}(X)${endColour}\n"
			echo -e "${yellowColour}[*]${endColour}${grayColour} Instaling dependency ${endColour}${blueColour}$program${endColour}${yellowColour}...${endColour}"
			apt-get install $program -y > /dev/null 2>&1
		fi; sleep 1
	done
}

# Wordlists
function wordlistGenerator() {

    #if [ -z $urlList]; then
    #    cewl
    #fi

    case $languageMode in
        english)
            echo -e "${yellowColour}[*]${endColour}${grayColour} Creating a english wordlist\n${endColour}"
            echo -e ""
            mergeDicEnglish
        ;;
        spanish)
            echo -e "${yellowColour}[*]${endColour}${grayColour} Creating a spanish wordlist\n${endColour}"
            mergeDicEspanol
        ;;
        *)
            echo -e "${redColour}[*]${endColour}${grayColour} unkown language\n${endColour}"
            exit 1
        ;;
    esac
    
    rsmangler
    #princeprocessor
    cat ./dictionaries/permutedWordlist.txt >> ./dictionaries/customWordlist.txt
    cat ./dictionaries/princeWordlist.txt >> ./dictionaries/customWordlist.txt
    seq 600000000 799999999 > ./dictionaries/customWordlist.txt
    seq 900000000 999999999 > ./dictionaries/customWordlist.txt
}
function cewl() {
    rm ./dictionaries/cewl.txt
    for url in $(cat $urlList); do echo $url && cewl -d 5 $url >> temp_cewl.txt;done
    cat temp_cewl.txt | sort -u >> ./dictionaries/cewl.txt && rm temp_cewl.txt
}
function mergeDicEnglish(){
    cat ./dictionaries/english/names.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/english/surnames.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/english/colors.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/english/months.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/english/seasons.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/english/numbers.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/english/corporative.txt >> ./dictionaries/mergedDic.txt
    #cat ./dictionaries/cewl.txt >> ./dictionaries/mergedDic.txt
}
function mergeDicEspanol(){
    echo -e "${yellowColour}[*]${endColour}${grayColour} Merging spanish dictionaries...\n${endColour}"
    cat ./dictionaries/espanol/nombres.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/espanol/apellidos.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/espanol/colores.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/espanol/meses.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/espanol/estaciones.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/espanol/anos.txt >> ./dictionaries/mergedDic.txt
    cat ./dictionaries/espanol/corporativo.txt >> ./dictionaries/mergedDic.txt
    #cat ./dictionaries/cewl.txt >> ./dictionaries/mergedDic.txt
}

function rsmangler(){
    echo -e "${yellowColour}[*]${endColour}${grayColour} Using rsmangler ...\n${endColour}"
    rsmangler --file ./dictionaries/mergedDic.txt --min 3 --max 14  -e -i --punctuation --output ./dictionaries/permutedWordlist.txt
}

function princeprocessor(){
    echo -e "${yellowColour}[*]${endColour}${grayColour} Using prince processor...\n${endColour}"
    ./princeprocessor/pp64.bin --elem-cnt-min=5 --elem-cnt-max=16 < ./dictionaries/permutedWordlist.txt > ./dictionaries/princeWordlist.txt

}


# Cracking
function cracker(){
    case $program in
        hashcat)
            echo -e "${yellowColour}[*]${endColour}${grayColour} Program used hashcat\n${endColour}"
            case $hashMode in
                ntlm)
                    ntlm_hashcat
                ;;
                *)
                    echo -e "unkown hash"
                ;;
            esac
            ;;
        john)
            echo -e "john\n"
            case $hashMode in
                ntlm)
                    echo -e "ntlm\n"
                    ntlm_john
                ;;
                *)
                    echo -e "unknown hash\n"
                ;;
            esac
            ;;
        *)
            echo -n "unknown program"
            ;;
    esac
}
function ntlm_john(){
    john $hashFile --format=NT --wordlist=/opt/wordlists/rockyou.txt
    john $hashFile --format=NT --wordlist=/opt/wordlists/kaonahsi.txt
    john $hashFile --format=NT --wordlist=/opt/wordlists/hasheorg2019.txt
    john $hashFile --format=NT --wordlist=/opt/wordlists/crackstation.txt
    john $hashFile --format=NT --wordlist=/opt/wordlists/hashkiller-dict.txt
    john $hashFile --format=NT --wordlist=/opt/wordlists/HIBP/pwned-passwords-ntlm-ordered-by-count-v7.txt
    john $hashFile --format=NT --wordlist=/opt/wordlists/CompilationOfManyBreachesPasswords.txt
    john $hashFile --format=NT --wordlist./dictionaries/customWordlist.txt

    john $hashFile --format=NT --show | head -n -2 > result.txt
}
function ntlm_hashcat(){
    echo -e "${yellowColour}[*]${endColour}${grayColour} Cracking using generic wordlists...\n${endColour}"
    hashcat -m 1000 $hashFile /opt/wordlists/rockyou.txt /opt/wordlists/kaonahsi.txt /opt/wordlists/hasheorg2019.txt /opt/wordlists/crackstation.txt /opt/wordlists/hashkiller-dict.txt /opt/wordlists/HIBP/pwned-passwords-ntlm-ordered-by-count-v7.txt /opt/wordlists/CompilationOfManyBreachesPasswords.txt
    echo -e "${yellowColour}[*]${endColour}${grayColour} Cracking using the custom wordlists...\n${endColour}"
    hashcat -m 1000 $hashFile ./dictionaries/customWordlist.txt
    
    hashcat -m 1000 $hashFile --show --username --outfile-format=2 > result.txt
}

# Format
function format(){
    censorPassword
    csv
}
function censorPassword(){
    rm -rf censorResult.txt
    while read -r credential
    do
            username=$(echo $credential | awk -F: '{print $1}')
            pass=$(echo $credential | awk -F: '{print $2}')
            if [ ${#pass} = 1 ];
            then
                censuredString="********"
            else
                last=${pass: -1}
                firts=${pass:0:1}
                censuredString=$(echo $firts"********"$last)
            fi
            echo $username":"$censuredString >> censorResult.txt
    done < "./result.txt"
}
function csv(){
    echo "Username;Password" > result.csv
    cat censorResult.txt | awk -F: '{print $1";"$2}' >> result.csv
    rm -rf censorResult.txt
}

# MAIN
declare -i parameter_counter=0; while getopts ":f:p:m:l:u:h:" arg; do
		case $arg in
    		f) hashFile=$OPTARG; let parameter_counter+=1 ;;
	    	p) program=$OPTARG; let parameter_counter+=1 ;;
            m) hashMode=$OPTARG; let parameter_counter+=1 ;;
            l) languageMode=$OPTARG; let parameter_counter+=1 ;;
            u) urlList=$OPTARG; let parameter_counter+=1 ;;
		    h) helpPanel;;
	    esac
done
if [ $parameter_counter -ne 4 ]; then
	helpPanel
else
	dependencies
	wordlistGenerator
    	cracker
    	format
    	tput cnorm
    	echo -e "\n COMPLETED\n Now use csv2wordTable.ps1 to export the results as a word table"
fi

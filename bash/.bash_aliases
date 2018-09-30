MAC=0
UBUNTU=0
LC_NUMERIC="en_US.UTF-8"
if [[ `uname -a | grep -i darwin` ]]; then
    MAC=1
    # export LC_CTYPE=C
    # export LANG=C
    export LANG=en_US.UTF-8
    export JAVA_HOME=$(/usr/libexec/java_home)
    alias eject="diskutil eject"
    alias ll="ls -f1 -alF -G"
    alias join="/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py"
fi
if [[ `uname -a | grep -i ubuntu` ]]; then
    UBUNTU=1
    alias ll="ls -alF --color=auto"
    alias remove="sudo apt-get --purge --ignore-missing remove"
    # sudo do-release-upgrade -d
    alias update="sudo apt-get update -y -m --ignore-hold; sudo apt-get upgrade -y -m --ignore-hold; sudo apt-get dist-upgrade -y -m --ignore-hold; sudo apt-get --purge autoremove; sudo apt-get --purge clean; sudo apt-get --purge autoclean; sudo /etc/init.d/dns-clean; sudo updatedb"
    alias update2="sudo apt-get update -y -m --ignore-hold; sudo apt-get upgrade -y -m --ignore-hold; sudo apt-get --purge autoremove; sudo apt-get --purge clean; sudo apt-get --purge autoclean; sudo /etc/init.d/dns-clean; sudo updatedb"
fi

export PS1="$ "

USER_AGENT="Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/3B48b Safari/419.3"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

alias b='rm -rf build/ && mkdir build/ && cd build/ && cmake .. && cmake --build . && cd ..'
alias n='rm -rf build/ && mkdir build/ && cd build/ && cmake -G "Unix Makefiles" .. && cmake --build . && cd ..'



####################################################
######### Android
####################################################
export ANDROID_HOME=~/android-sdk
export ANDROID_SDK_ROOT=~/android-sdk
export PATH=${PATH}:$(find ~/android-sdk/build-tools/ -maxdepth 1 -type d | tr '\n' ':')
export PATH=${PATH}:~/android-sdk/platform-tools
export PATH=${PATH}:~/android-sdk/tools
export PATH=${PATH}:~/android-sdk/tools/bin
export PATH=${PATH}:~/android-ndk
export PATH=${PATH}:~/repo/dex2jar-0.0.9.15
export PATH=${PATH}:~/repo/adb-sync
export PATH=${PATH}:~/Tools/gradle/bin
export M2_HOME=~/.m2

function ascreen() {
    devices=( $(adb devices | tail -n +2 | cut -sf 1) )
    for device in "${devices[@]}"; do echo "Taking screenshot of device: $device"; adb -s $device shell screencap -p /sdcard/screen.png   &>/dev/null && adb -s $device pull /sdcard/screen.png screen$(date +%s).png &>/dev/null && adb -s $device shell rm /sdcard/screen.png &>/ dev/null; done
}


####################################################
######### Aliases
####################################################
alias pico="nano"
alias q="qmake -project; qmake; make;"
alias w='if [ ! -d "build" ]; then mkdir build; fi && cd build/ && cmake .. && make; cd ..'
alias sort="sort -f"
alias echo="echo -e"
alias grep="grep -i --color"
alias egrep="egrep -i --color"
alias curl="curl --user-agent \"$USER_AGENT\""
alias wget="wget --user-agent=\"$USER_AGENT\""
alias l="lookup"
alias p="vim ~/.bash_aliases"
alias o="source ~/.bashrc"
alias c="clear"
alias move="mv"
alias cls="printf \"\033c\""

function resizeIcons() {
	## mipmap
	find . -path \*/drawable-hdpi/ic_launcher.png -exec sh -c "convert {} -resize 72x72 {}" \;
	find . -path \*/drawable-ldpi/ic_launcher.png -exec sh -c "convert {} -resize 36x36 {}" \;
	find . -path \*/drawable-mdpi/ic_launcher.png -exec sh -c "convert {} -resize 48x48 {}" \;
	find . -path \*/drawable-xhdpi/ic_launcher.png -exec sh -c "convert {} -resize 96x96 {}" \;
	find . -path \*/drawable-xxhdpi/ic_launcher.png -exec sh -c "convert {} -resize 144x144 {}" \;
	find . -path \*/drawable-xxxhdpi/ic_launcher.png -exec sh -c "convert {} -resize 192x192 {}" \;
	## drawables
	find . -path \*/mipmap-hdpi/ic_launcher.png -exec sh -c "convert {} -resize 72x72 {}" \;
	find . -path \*/mipmap-ldpi/ic_launcher.png -exec sh -c "convert {} -resize 36x36 {}" \;
	find . -path \*/mipmap-mdpi/ic_launcher.png -exec sh -c "convert {} -resize 48x48 {}" \;
	find . -path \*/mipmap-xhdpi/ic_launcher.png -exec sh -c "convert {} -resize 96x96 {}" \;
	find . -path \*/mipmap-xxhdpi/ic_launcher.png -exec sh -c "convert {} -resize 144x144 {}" \;
	find . -path \*/mipmap-xxxhdpi/ic_launcher.png -exec sh -c "convert {} -resize 192x192 {}" \;
}

function idb() {
    i=0
    for line in $(system_profiler SPUSBDataType | sed -n -e '/iPad/,/Serial/p' -e '/iPhone/,/Serial/p' | grep "Serial Number:" | awk -F ": " '{print $2}'); do
        UDID=${line}
        udid_array[i]=${line}
        i=$(($i+1))
    done

    cnt=${#udid_array[@]}
    for ((i=0;i<cnt;i++)); do
        echo ${udid_array[i]}
    done
}

function lookup() {
	case "$1" in
	'date')
		date +'%m_%d_%Y'
		;;

	'facebook_id')
		if [[ -z "$2" ]]; then
			echo "Type in something to search.";
		else
			curl "https://graph.facebook.com/$2"
		fi
		;;

	'ip')
		if [[ -z "$2" ]]; then
			echo "Type in something to search.";
		else
			host google.com | awk '/address/ {print $NF}'
		fi
		;;

	'local'|'localip')
		ifconfig wlan0 | grep inet | awk '{print $2}' | awk -F':' '{print $2}';
		;;

	'publicip')
		curl -s checkip.dyndns.org | sed 's#.*Address: \(.*\)</b.*#\1#';
		;;

	'area'|'areacode')
		if [[ -z "$2" ]]; then
			echo "Type in something to search.";
		else
			grep "$2" ~/Dropbox/nix/lookup/area.txt;
		fi
		;;

	'get')
		if [[ -z "$2" ]]; then
			echo "Type in something to search.";
		else
			echo -e "GET / HTTP/1.0\r\n\r\n" | nc -n -i 1 `host "$2" | awk 'NR<2{print $4}'` 80;
		fi
		;;

	'head'|'header')
		if [[ -z "$2" ]]; then
			echo "Type in something to search.";
		else
			echo -e "HEAD / HTTP/1.0\r\n\r\n" | nc -n -i 1 `host "$2" | awk 'NR<2{print $4}'` 80;
		fi
		;;

	'zip'|'zipcode')
		if [[ -z "$2" ]]; then
			echo "Type in something to search.";
		else
			grep "$2" ~/Tools/lookup/zip.txt;
		fi
		;;

	*|'help')
		echo -e "Usage: lookup [options] [search]\n"
		echo "Options: area, date, get, facebook_id,"
		echo "head, ip, localip, publicip, zip"
		echo "Example: lookup area 407"
		echo "Output: 407 - Florida (Orlando, Winter Park)"
	;;
	esac
}

function jbencrypt() {
	seconds=`date +%s`;
	if [[ -z $1 ]]; then
		echo "No input files";
	elif [[ ! -f $1 ]]; then
		echo "File does not exist";
	else
		openssl aes-256-cbc -a -salt -in "$1" -out "$1"."$seconds";
		openssl des-ede3-cbc -a -salt -in "$1"."$seconds" -out "$1"."$seconds"."$seconds";
		openssl bf-cbc -a -salt -in "$1"."$seconds"."$seconds" -out "$1".txt;
		rm -rf "$1" "$1"."$seconds" "$1"."$seconds"."$seconds";
	fi
}

function jbdecrypt() {
	seconds=`date +%s`;
	if [[ -z $1 ]]; then
		echo "No input files";
	elif [[ ! -f $1 ]]; then
		echo "File does not exist";
	else
		filename=`echo "$1" | sed 's/\.[^\.]*$//'`
		openssl bf-cbc -a -d -in "$1" -out "$1"."$seconds";
		openssl des-ede3-cbc -a -d -in "$1"."$seconds" -out "$1"."$seconds"."$seconds";
		openssl aes-256-cbc -a -d -in "$1"."$seconds"."$seconds" -out "$filename";
		rm -rf "$1" "$1"."$seconds" "$1"."$seconds"."$seconds";
	fi
}

function fix() {
   	case "$1" in
	'help'|'-help'|'--help'|'?')
		echo -e "Usage: stop [-option]\nOptions:\nmix\tStop Services/Listening\ntcp\tStop Listening TCP Services\njava\tStop Java Processes\nmemory\tFix cache and memory";;

	'tcp')
		sudo netstat -tpln | awk '{print $7}' | sed 's@[^0-9]*@@' | sed 's@/*[^a-z]@@g' | while read SERVICE; do sudo service $SERVICE stop; echo $SERVICE; done;;

	'adb')
		temp_adb=$(which adb); sudo sh -c "$temp_adb kill-server && start-server";;

	esac
}

########################################################################
### Old Stuff
########################################################################

if [[ MAC == 0 ]]; then
    function gtk() {
        g++ $1.cpp -o $1.o `pkg-config --cflags --libs gtk+-2.0`; ./$1.o;
    }

    function q() {
        msp430-gcc -Os -Wall -g -mmcu=msp430x2012 -o $1.elf $1.c;
    }

    function w() {
        echo "prog $1.elf"; wait 5; echo "run"; sudo mspdebug rf2500;
    }

    function run() {
        msp430-gcc -Os -Wall -g -mmcu=msp430x2012 -o $1.elf $1.c; { echo "prog $1.elf"; wait 5; echo "run"; } | sudo mspdebug rf2500;
    }

    function wanscan() {
        sudo iwlist wlan0 scan | egrep 'Addr|ESSID' | awk '{printf("%s\n %s",$1, $5) }' | grep -vi cell | sed -e 's/ESSID:/\t/' -e '1d' -e '$d' -e '/^$/d' -e 's/"//g' -e 's/[ ]//';
    }

    function btscan() {
        sudo hciconfig hci0 reset; sudo hcitool scan | grep -v "Scann" | awk '{printf "%s \t %s\n",$1,$2}' >> bluetooth;
    }

    function capture() {
        sudo airmon-ng start wlan0; sudo tcpdump -i mon0 -A -n port 80 | egrep -i \(GET.\/\|POST.\/\|Host:\|user\|pass\) > capture.txt;
    }

    function capture1() {
        sudo airmon-ng start wlan0; sudo tcpdump -i mon0 -A -n port 80 | egrep -i \(GET.\/\|POST.\/\|Host:\|user\|pass\);
    }
fi



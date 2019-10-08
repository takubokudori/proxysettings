SETTINGS_FILEPATH=~/.proxysettings

apply_settings()
{
	if [ -z $username ]; then
		url="http://${host}:${port}"
	else 
		url="http://${username}:${password}@${host}:${port}"
	fi
	export no_proxy="localhost,127.0.0.1"
	export NO_PROXY=$no_proxy
	export http_proxy="$url"
	export HTTP_PROXY="$url"
	export https_proxy="$url"
	export HTTPS_PROXY="$url"
	export ftp_proxy="$url"
	export FTP_PROXY="$url"
}

url_encode(){
	echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
}

save_settings()
{
	echo $host > $SETTINGS_FILEPATH
	echo $port >> $SETTINGS_FILEPATH
	echo $username >> $SETTINGS_FILEPATH
}

load_settings()
{
	host=`sed -n 1P < $SETTINGS_FILEPATH`
	port=`sed -n 2P < $SETTINGS_FILEPATH`
	username=`sed -n 3P < $SETTINGS_FILEPATH`
}

ask_password()
{
	if type "nkf" > /dev/null 2>&1; then
		read -sp "Password: " password
		password=`url_encode $password`
	else
		read -sp "(URL encoded)Password: " password
	fi
	echo $password
}

if [ -e $SETTINGS_FILEPATH ]; then
	# Load settings from .proxysettings if .proxysettings exists
	load_settings
	echo "Settings loaded."
	echo "Host: $host"
	echo "Port: $port"
	if [ ! -z $username ]; then
		# Credential required.
		echo "Username: $username"
		password=`ask_password`
		echo "" # LF
		if [ -z $password ]; then
			echo "No settings exported."
		else
			apply_settings
			echo "Exported settings successfully!"
		fi # password required
	else # username is empty
		# No credential required
		read -p "Do you want to apply settings?(default n)" yn
		if [ ! -z $yn ] && [ $yn != "n" ] && [ $yn != "N" ]; then
			apply_settings
			echo "Settings exported successfully!"
		else
			echo "No settings exported."
		fi
	fi # credential required

	return 2>&- || exit

else # No .proxysettings

	read -p "Host: " host
	if [ -z $host ]; then
		# host is empty
		echo "No settings exported."
		return 2>&- || exit
	fi

	read -p "Port: " port
	if [ -z $port ]; then
		# default value 8080
		port="8080"
	fi

	read -p "Username: " username
	if [ ! -z $username ]; then
		# Credential required
		password=`ask_password`
		echo "" # LF
	fi

	apply_settings

	echo "Exported settings successfully!"

	read -p "Do you want to save settings?[Y/n] (default n): " yn
	if [ $yn = "Y" ] || [ $yn = "y" ]; then
		save_settings
		echo "Saved settings successfully!"
	fi

fi # load_settings

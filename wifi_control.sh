#"Wifi Interfaces Control Script"

usage() {
	echo "$0 on | off | status | list"
	exit 1
}

if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    usage
    exit 1
fi

while :
do
  case "$1" in
	on)
		echo "[I]Starting monitor interfaces..."
		iw phy phy0 interface add mon5 type monitor  
		iw phy phy1 interface add mon2 type monitor  
		ifconfig mon5 up
		if [[ $? -ne 0 ]]; then
			echo "[!]Error! Unable to start monitor on wlan0"
			exit 1
		fi
		ifconfig mon2 up
		if [[ $? -ne 0 ]]; then
			echo "[!]Error! Unable to start monitor on wlan1"
			exit 1
		fi
		echo "[I]Interfaces mon2 (2.4GHz) and mon5 (5.8GHz) created."
		break
		;;
	off)
		echo "[I]Stoping all monitor interfaces..."
		ifconfig mon5 down
		iw dev mon5 del
		iw phy phy0 interface add wlan0 type managed
		ifconfig mon2 down
		iw dev mon2 del
		iw phy phy0 interface add wlan1 type managed
		echo "[I]Done."
		break
		;;
	list|status)
		iw dev
		break
		;;	
	*)
		usage
		exit 1
		;;
  esac
done
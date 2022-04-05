#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.dwm/scripts/themes/gruvbox

cpu() {
	cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

	printf "^c$grey^ ^b$green^ CPU"
	printf "^c$white^ ^b$grey^ $cpu_val"
}

pkg_updates() {
	# updates=$(doas xbps-install -un | wc -l) # void
	# updates=$(checkupdates | wc -l)   # arch , needs pacman contrib
	updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

	if [ 0 -eq "$updates" ]; then
		printf " ^b$green^^c$grey^  ^d^%s" "^b$grey^^c$green^ Fully Updated"
    else
		printf "^b$green^^c$grey^  ^d^%s" "^b$grey^^c$green^ $updates"" updates"
	fi
}

mem() {
	printf "^b$blue^^c$grey^  "
	printf "^b$grey^^c$blue^ $(free -h | awk '/^Mem/ { print $4 }' | sed s/i//g)"
}

lan() {
	case "$(cat /sys/class/net/enp7s0/operstate 2>/dev/null)" in
    up) ip=$(sh /usr/share/i3blocks/iface)
        printf "^c$grey^ ^b$blue^  ^d^%s" "^b$grey^^c$blue^ $ip" ;;
	down) printf "^c$grey^ ^b$blue^  ^d^%s" "^b$grey^^c$blue^ Disconnected" ;;
	esac
}

clock() {
	printf "^c$grey^ ^b$orange^  "
	printf "^b$grey^ ^c$orange^ $(date '+%d.%m %H:%M') "
}

btc() {
    price=$(curl https://api.coinbase.com/v2/prices/spot\?currency\=USD  | sed "s/\"//g; s/}//g" | awk -F',' '{print $3}' | awk -F':' '{print $2}')
    printf "^c$grey^ ^b$red^ "
    printf "^c$red^ ^b$grey^ ${price} "
}

while true; do

	[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
	interval=$((interval + 1))
    sleep 1 && xsetroot -name "$updates $(cpu) $(btc) $(mem) $(lan) $(clock)"
done

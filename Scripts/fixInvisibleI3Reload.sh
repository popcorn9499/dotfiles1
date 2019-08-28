removeOpacity () {
    window_id=$1
    xprop -id $window_id -remove _NET_WM_WINDOW_OPACITY
}


windows=$(wmctrl -l|awk '{print $1}')

for window in $windows; 
do
    removeOpacity "$window"
done
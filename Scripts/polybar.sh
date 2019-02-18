
# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

MONITOR_LIST=$(xrandr --listmonitors | sed '1 d' | awk 'NF>1{print $NF}')

# Launch polybar


for mon in $MONITOR_LIST; do
    echo "Launching on monitor $mon"
    env MONITOR=$mon polybar example &
done
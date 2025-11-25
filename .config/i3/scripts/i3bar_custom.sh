#!/bin/bash

title(){
    CheckIdWorkspace=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')
    Title=$(xprop -id $CheckIdWorkspace 'WM_CLASS' | awk '{gsub(/"/,"",$4); gsub(/-/," ",$4); print $4}' )
    echo "{\"color\":\"#FFFFFF\",\"full_text\":\"$Title\"}"

}
wifi(){
    WiFi=$(nmcli -t -f NAME connection show --active | grep -v lo)
     if [ -z "$WiFi" ]; then
        WiFi="DOWN"
        Color="#FF0000"
    else
        Color="#00FF00"
    fi
    echo "{\"color\":\"$Color\",\"full_text\":\" $WiFi\"}"
}
bt(){
    device=$(bluetoothctl devices Connected | cut -d' ' -f4-); [ -z "$device" ] 
    if [ -z "$device" ]; then
        device="DOWN"
        Color="#FF0000"
    else
        Color="#00FF00"
    fi
    echo "{\"color\":\"$Color\",\"full_text\":\" $device\"}"
}
vol(){
    CheckIdVol=$(wpctl status | grep "Built-in Audio Analog Stereo" | awk '{print $3}'| head -n1 |sed 's/\.//')
    VOL=$(wpctl get-volume $CheckIdVol | awk '{print ($3 ? "MUTE" : int($2*100))}')
    Color=$(awk -v vol="$VOL" 'BEGIN {
    if (vol == "MUTE")      { print "#FF0000" }
    else if (vol >= 75)    { print "#00FF00" }
    else if (vol >= 50)     { print "#33CC00" }
    else if (vol >= 25)     { print "#669900" }
    else { print "#336600" }
    }')
    echo "{\"color\":\"$Color\",\"full_text\":\" $VOL%\"}"
}
cpu(){
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4+$6+$10+$12+$14}')
    INT=$(echo "$CPU" | awk '{print int($1)}')
    if [ $INT -ge 70 ]; then
        Color="#FF0000"
    else
        Color="#00FF00"
    fi
    echo "{\"color\":\"$Color\",\"full_text\":\" $INT%\"}"
}
ram(){
    TRam=$(free -w | head -n 2 | tail -n 1 | awk '{print $2}' | sed 's/..$//')
    TUsage=$(free -w | head -n 2 | tail -n 1 | awk '{print $3}' | sed 's/..$//')
    RAM=$(awk "BEGIN {printf int($TUsage/$TRam*100)}")
    Color=$(awk -v ram="$RAM" 'BEGIN {if(ram>=70) print "#FF0000"; else print "#00FF00"}')
    echo "{\"color\":\"$Color\",\"full_text\":\" $RAM%\"}"
}
bat(){
    VALUE=$(acpi -b | awk -F', ' '{print $2}' | tr -d ' %')
    STATUS=$(acpi -a | awk -F': ' '{print $2}')
    if [[ "$STATUS" = "off-line" && "$VALUE" -le 20 ]]; then
        STATUS="[LOW]"
        Color="#FF0000"
    elif [ "$STATUS" = "on-line" ]; then
        STATUS="[CHR]"
        Color="#00FF00"
    else
        STATUS="[IDLE]"
        Color="#0096FF"
    fi
    echo "{\"color\":\"$Color\",\"full_text\":\" $VALUE% $STATUS\"}"
}
dt(){
    DATE=$(date '+%d-%m-%Y')
    TIME=$(date '+%H:%M:$S')
    echo "{\"color\":\"#FFFFFF\",\"full_text\":\" $DATE  $TIME\"}"
}
echo '{"version":1}'
echo '['

while true; do
    echo "[$(title),$(wifi),$(bt),$(vol),$(cpu),$(ram),$(bat),$(dt)],"
    sleep 1
done

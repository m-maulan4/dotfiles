#!/bin/bash
title(){
    CheckIdWorkspace=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')
    Title=$(xprop -id $CheckIdWorkspace 'WM_CLASS' | awk '{gsub(/"/,"",$4); gsub(/-/," ",$4); print $4}' )
    Color=$(head /dev/urandom | tr -dc 0-9A-F | head -c 6)
    echo -e "$Title\n\n#$Color"
}
wifi(){
    WiFi=$(nmcli -t -f NAME connection show --active | grep -v lo)
     if [ -z "$WiFi" ]; then
        WiFi="DOWN"
        Color="#FF0000"
    else
        Color="#00FF00"
    fi
    echo -e "$WiFi\n\n$Color"
}
bt(){
    device=$(bluetoothctl devices Connected | cut -d' ' -f4-); [ -z "$device" ] 
    if [ -z "$device" ]; then
        device="DOWN"
        Color="#FF0000"
    else
        Color="#00FF00"
    fi
    echo -e "$device\n\n$Color"
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
    echo -e "$VOL\n\n$Color"
}
cpu(){
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4+$6+$10+$12+$14}')
    INT=$(echo "$CPU" | awk '{print int($1)}')
    if [ $INT -ge 70 ]; then
        Color="#FF0000"
    else
        Color="#00FF00"
    fi
    echo -e "$CPU%\n\n$Color"
}
ram(){
    TRam=$(free -h | head -n 2 | tail -n 1 | awk '{gsub(/Gi/,"");print $2}')
    TUsage=$(free -h | head -n 2 | tail -n 1 | awk '{gsub(/Gi/,"");print $3}')
    RAM=$(awk "BEGIN {printf \"%.0f\", $TUsage/$TRam*100}")
    Color=$(awk -v ram="$RAM" 'BEGIN {if(ram>=10) print "#FF0000"; else print "#00FF00"}')
    echo -e "$RAM%\n\n$Color"
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
    echo -e "$VALUE% $STATUS\n\n$Color"
}
# printah terminal
case "$1" in
    title)
        title  
        ;;
    wifi)
        wifi  
        ;;
    bt)
        bt  
        ;;
    vol)
        vol  
        ;;
    cpu)
        cpu  
        ;;
    ram)
        ram  
        ;;
    bat)
        bat  
        ;;
    *)
        exit 0
        ;;
esac
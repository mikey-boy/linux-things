# Ensure that this file is only writeable to root (priv esc)

alias xclip="xclip -selection clipboard"

function cheat {
        if [ "$1" = "-l" ]; then                    # list user cheatsheets
                ls ~/linux-things/cheatsheets/
        elif [ "$1" = "-li" ]; then                 # list image cheatsheets
                ls ~/linux-things/cheatsheets/imgs/
        elif [ "$1" = "-e" ]; then                  # create/edit cheatsheet
                vim ~/linux-things/cheatsheets/$2
        elif [ "$1" = "-i" ]; then                  # open image cheatsheet
                xdg-open ~/linux-things/cheatsheets/imgs/$2 
        else
                cat ~/linux-things/cheatsheets/$1
        fi
}

function tb-start {
    cur_status=$(systemctl show openvpn-client@TB-Canada.service | grep ExecMainPID | cut -d'=' -f2)
    if [ $cur_status -ne 0 ]; then
        echo "It seems that you are already connected to TunnelBear VPN. Exiting now..."
        return 0
    fi

    ip=$(curl --silent ifconfig.me)
    echo "Current IP address: $ip"
    
    sudo systemctl start openvpn-client@TB-Canada
    sleep 4 
    
    ip_new=$(curl --silent ifconfig.me)
    echo "Updated IP address: $ip_new"

    if [ "$ip" = "$ip_new" ]; then
        echo "Check that your IP actually changed using 'curl ifconfig.me'"
    fi
}

function tb-stop {
    cur_status=$(systemctl show openvpn-client@TB-Canada.service | grep ExecMainPID | cut -d'=' -f2)
    if [ $cur_status -eq 0 ]; then
        echo "You don't seem to be connected to TunnelBear VPN. Exiting now..."
        return 0
    fi

    sudo systemctl stop openvpn-client@TB-Canada
}

function tb-status {
    systemctl --no-pager status openvpn-client@TB-Canada
}

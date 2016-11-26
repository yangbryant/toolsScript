#!/bin/bash
host='localhost'
port='8123'
service='Wi-Fi'
ssh_server="ubuntu@youyifou.com"
licence_path="/Users/everyoo/node.pem"
pac_path="http://127.0.0.1:8090/proxy.pac"
password='password'

ssh_proxy_server_on(){
    ssh -D $port -f -q -CN -i $licence_path $ssh_server
}

ssh_proxy_server_off(){
    kill -9 `lsof -n -i4TCP:"$port" | grep LISTEN | awk '{print $2}' | cut -f 1 -d '/'`
}

proxy_init(){
    echo $password | sudo -S networksetup -setsocksfirewallproxy $service $host $port
    proxy_status
}

proxy_auto() {
    echo $password | sudo -S networksetup -setautoproxystate $service on
    echo $password | sudo -S networksetup -setautoproxyurl $service $pac_path
}

proxy_on(){
    echo $password | sudo -S networksetup -setsocksfirewallproxystate $service on
    # proxy_auto
    proxy_status
}

proxy_off(){
    # echo $password | sudo -S networksetup -setautoproxystate $service off
    echo $password | sudo -S networksetup -setsocksfirewallproxystate $service off
    proxy_status
}

proxy_status(){
    echo $password | sudo -S networksetup -getsocksfirewallproxy $service
}

if [ "$1" = "start" ]; then
    ssh_proxy_server_on
    proxy_init
elif [ "$1" = "stop" ]; then
    proxy_off
    ssh_proxy_server_off
else
    printf "Usage: sproxy start or stop\n"
fi
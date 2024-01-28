#!/bin/bash

# 以下请自行根据服务器路径配置
# RCON服务器的端口和密码
RCON_PORT=<your_port> # Default ports: 25575
ADMIN_PASSWORD=<your_password> # Set in game_dir/Pal/Saved/Config/LinuxServer/PalGameWorldSettings.ini
# 设置脚本与备份存档路径
scripts_dir="/home/azureuser/Pal" # Mkdir in user home dir
save_dir="/home/azureuser/Pal/AutoSaved" # Mkdir in scripts dir
# 设置游戏路径
game_dir="/home/azureuser/Steam/steamapps/common/PalServer" # Default path
# 设置日志文件
log_file="$scripts_dir/Pal_assist.log"
initialize() {
    touch $log_file
}
# 获取当前时间
date=$(date +"%Y-%m-%d")
time=$(date +"%H:%M:%S")

# 发送RCON命令
send_rcon_command() {
    echo "$1" | $scripts_dir/ARRCON -P $RCON_PORT -p $ADMIN_PASSWORD
}

# 存档&服务器保存
auto_save(){
    echo "保存时间 ${date}_${time}" | tee -a $log_file
    if ps aux | grep -q "[P]alServer.sh"; then
        send_rcon_command "save"
        sleep 30
        mkdir -p "$save_dir"
        tar -czf "$save_dir/Saved_${date}_${time}.tar.gz" -C "$game_dir/Pal/Saved" .
        echo "存档已经备份到 $save_dir" | tee -a $log_file
    else
        echo "save error:PalServer未运行" | tee -a $log_file
    fi
}

# 开启服务器
start_pal_server(){
    echo "启动时间 ${date}_${time}" | tee -a $log_file
    if ps aux | grep -q "[P]alServer.sh"; then
        echo "PalServer已启动" | tee -a $log_file
    else
    echo "PalServer未启动" | tee -a $log_file
    cd $game_dir
    nohup ./PalServer.sh &
    fi
    sleep 5
    if ps aux | grep -q "[P]alServer.sh"; then
        echo "PalServer成功启动" | tee -a $log_file
    else
        echo "start error:PalServer启动失败" | tee -a $log_file
    fi
}

# 关闭服务器
stop_pal_server(){
    if ps aux | grep -q "[P]alServer.sh"; then
        send_rcon_command "shutdown 120 The_server_will_be_rebooting_in_2_minutes"
        sleep 60
        send_rcon_command "broadcast The_server_will_be_rebooting_in_1_minutes"
        sleep 30
        send_rcon_command "broadcast The_server_will_be_rebooting_in_30_seconds"
        sleep 20
        send_rcon_command "broadcast The_server_will_be_rebooting_in_10_seconds"
        sleep 5
        send_rcon_command "broadcast The_server_will_be_rebooting_in_5_seconds"
        sleep 1
        send_rcon_command "broadcast The_server_will_be_rebooting_in_4_seconds"
        sleep 1
        send_rcon_command "broadcast The_server_will_be_rebooting_in_3_seconds"
        sleep 1
        send_rcon_command "broadcast The_server_will_be_rebooting_in_2_seconds"
        sleep 1
        send_rcon_command "broadcast The_server_will_be_rebooting_in_1_seconds"
        echo "关闭时间 ${date}_${time}" | tee -a $log_file
    else
        echo "shutdown error:PalServer未运行"
    fi
}

# 恢复备份
reload() {
    echo "恢复时间 ${date}_${time}" | tee -a $log_file
    if [ -f "$1" ]; then
        echo "恢复备份 $1" | tee -a $log_file
        rm -rf "$game_dir/Pal/Saved"
        tar --force-local -xzf "$1" -C "$game_dir/Pal/Saved"
    else
        echo "恢复备份失败: $1 不存在" | tee -a $log_file
    fi
}

if [ ! -f "$log_file" ]; then
    initialize
fi

if [ "$1" = "start" ]; then
    start_pal_server
elif [ "$1" = "stop" ]; then
    auto_save
    sleep 20
    stop_pal_server
elif [ "$1" = "restart" ]; then
    auto_save
    sleep 20
    stop_pal_server
    sleep 20
    start_pal_server
elif [ "$1" = "save" ]; then
    auto_save
elif [ "$1" = "reload" ]; then
    reload "save_dir/$2"
else
    echo "Usage: $0 {start|stop|restart|save|reload <Saved_${date}_${time}.tar.gz>}"
    exit 1
fi

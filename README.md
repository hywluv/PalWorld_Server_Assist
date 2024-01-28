# PalWorld_Server_Assists

## Introduction

Scripts for Auto management of PalWorld Linux Server.

用于个人《幻兽帕鲁》Linux 服务器的管理脚本，包含自动备份、启动、重启、恢复备份等功能。

## Structure

```text
├── Readme.md                   // 说明文档
├── AutoSaved                   // 存档文件夹
│   └── readme.txt              // 说明文档
├── Pal_assist.sh               // 主要脚本
└── ARRCON                      // RCON 程序
```

## Usage

You can use the script by running `./PalWorld.sh [start|stop|restart|save|reload <Saved_${date}_${time}.tar.gz>]`

* start: Start the server
* stop: Stop the server
* restart:Restart the server
* save: Save the game and backup the world
* reload: Reload the world from the backup file. You should specify the backup file name as the second argv.

## Automation

You can use `crontab` to automate the script. Note: You should specify the absolute path of the script.

```bash
crontab -e
# add the following line to the end of the file
55 */1 * * * /path/to/PalWorld.sh save # Save the game every hour at *:55
@reboot /path/to/PalWorld.sh start # Start the server when the system reboot
0 */6 * * * /path/to/PalWorld.sh restart # If your RAM is limited, you should restart the service regularly.
```

## 关于作者

`ARRCON` 仓库: [radj307/ARRCON](https://github.com/radj307/ARRCON)
有任何建议欢迎提交 PR 和 Issue , 也可以通过以下方式联系我：

* [邮箱](mailto:2271089251@qq.com)
* [QQ](http://wpa.qq.com/msgrd?v=3&uin=2271089251&site=qq&menu=yes)

欢迎大家一起来玩捏！帕鲁快乐！

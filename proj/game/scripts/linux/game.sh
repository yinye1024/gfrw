#!/usr/bin/env bash

GAME_ROOT_DIR=$(cd "$(dirname "$0")/../.." && pwd)
SCRIPTS_DIR=${GAME_ROOT_DIR}/scripts

#定义es文件，并给es脚本文件赋予可执行权限
ES_SCRIPT_FILE=${SCRIPTS_DIR}/es/es_game
chmod +x "${ES_SCRIPT_FILE}"

start_server()
{
  ulimit -c unlimited
  ulimit -SHn 51200
  ${ES_SCRIPT_FILE} "${GAME_ROOT_DIR}" start
}
stop_server()
{
  ${ES_SCRIPT_FILE} "${GAME_ROOT_DIR}" stop
}
live_server()
{
  ${ES_SCRIPT_FILE} "${GAME_ROOT_DIR}" live
}
attach_server()
{
  ${ES_SCRIPT_FILE} "${GAME_ROOT_DIR}" attach
}
reload()
{
  echo "$@"
  ${ES_SCRIPT_FILE} "${GAME_ROOT_DIR}" reload "$@"
}
#使用说明
usage()
{
  echo ""
  echo "用法"
  echo "$0 动作[选项]"
  echo "动作:"
  echo "  start                                 启动服务"
  echo "  stop                                  停止服务"
  echo "  live                                  shell方式启动服务"
  echo "  attach                                remsh 链接服务"
  echo "  reload                                重新加载模块(参数为module名字，用‘-’分隔)"
  echo ""
}
ACTION=$1
shift
case $ACTION in
  "") usage;;
  "help") usage;;
  "start") start_server;;
  "stop") stop_server;;
  "live") live_server;;
  "attach") attach_server;;
  "reload") reload "$@";;
  *) echo "未知命令";;
esac


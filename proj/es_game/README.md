# 游戏服的脚本控制，方便shell脚本控制服务器的操作，启动，停止，热更新等

### 如何使用
1.跑 $ rebar3 escriptize 生成文件 _build/default/bin/es_game

2.替换game项目下的escript文件 scripts/es/es_game 

3.对应在 scripts/linux/game.sh 和 scripts/linux/game.bat 添加对应的调用脚本

### 主要目录

1. node 目录  

   节点控制逻辑
   
    es_node_cfg.erl 获取节点配置的逻辑 

    es_node_cmd_builder.erl 组装系统指令
   
    es_node_item.erl  节点对象数据结构
   
    es_node_rpc.erl  节点rpc call 封装
   
    es_node_tool.erl 节点工具封装，给es_game.erl main 方法分发调用

2. utils 目录

   es_utils_exec 和系统交互的工具模块

   es_utils_map 操控map的工具模块


 

# 把游戏前后端通信的 protobuf 协议转成 erlang 模块


### 添加依赖

因为要经常改动，最好是用本地依赖

    {deps, [
        {game_proto, {path, "../game_proto"}}
       ]
    }

### 如何使用
1.把protobuf 文件放入 proto 目录

2.终端跑 rebar3 compile 命令

3.对应的文件生成在 include 和 src/pb 目录

4.game项目加入 game_proto的依赖，用pb下的模块实现业务协议的解包和封包

### 主要目录

1. proto 目录

   protobuf协议文件

2. include 目录

   根据protobuf协议生成的 include 文件
3. src/pb 目录
   
   根据protobuf协议生成的 erl 文件
4. cmd_map.erl
   
   前后端指令映射，手动添加指令分发对应的处理函数，
5. utils 目录
   
   map 和 record 相互转换的工具，以及一些别的工具类


 
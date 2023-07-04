### 模版项目

把一些通用模版放到这里，使用的时候用[工具](https://github.com/yinye1024/yyedt)的替换功能做模版替换。
在game的开发过程中，如果发现某个模块的模式和结构可能会被经常使用，就可以把它做成模版放到这里，方便快速生成代码。

### comm 目录,一些业务无关的通用模版
 1. comm/data 数据持久化，缓存相关的模版。
 2. comm/eunit eunit测试模版
 3. comm/httpd http服务模版


### local 目录，本地服务的模版
1. local/gen_gtpl_multi 多进程本地服务模版。
2. local/gen_gtpl_single 单进程本地服务模版
3. lc/gtpl 本地应用服务模版，分管理进程和工作进程


### role 目录，玩家进程的业务模版
1. 替换后直接放到玩家进程作为业务跟着玩家进程启动。

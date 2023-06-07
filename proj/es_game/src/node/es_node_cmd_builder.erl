%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 25. 5月 2023 15:41
%%%-------------------------------------------------------------------
-module(es_node_cmd_builder).
-author("yinye").

-include("es_comm.hrl").

%% API
-export([build_node_start_cmd_with_shell/1,build_node_start_cmd_daemon/1]).
-export([build_node_attach_cmd/2,build_node_rpc_cmd/3]).

%% 启动后 停留在 shell 进行后继交互，
%% 一般是启动报错的时候（log服务来不及启动）用来定位
build_node_start_cmd_with_shell(EsNodeItem)->
  %% 和守护进程启动节点的FixFlags一样，区别是不设置 -detached 参数
  FixFlags="+K true"            %% 启用内核轮询（Kernel Polling）,也就是epoll。这将使用操作系统的 I/O 多路复用机制来提高并发性能。
    ++" " ++ "+P 500000"          %% 设置进程预留存储器的大小。该参数指定 Erlang 进程系统的最大活动进程数。
    ++" " ++ "+Q 100000"          %% Port的最大数量，同时受限于系统的文件句柄数
    ++" " ++ "+t 10485760"        %% atom最大数量，默认1,048,576.
    ++" " ++ "+fnu"               %% 文件名强制utf-8编码，如果不是会异常
    ++" " ++ "+hms 8192"          %% 进程默认堆大小 单位字节
    ++" " ++ "+hmbs 8192"         %% 进程默认二进制虚拟堆大小 单位字节
    ++" " ++ "+zdbbl 81920"       %% 设置输出信息的缓冲区大小，单位千字节，默认值1024，缓冲区满了，会阻塞当前进程
    ++" " ++ "-kernel inet_dist_listen_min 16001"  %% 分布式系统中中节点的socket监听端口范围 最小值
    ++" " ++ "-kernel inet_dist_listen_max 17000"  %% 分布式系统中中节点的socket监听端口范围 最大值
    ++" " ++ "-smp enable"        %% 是否在多核上运行调度器，Otp R12B之后的版本会自动检测，设置和CPU逻辑核数相同的调度器，可不设置，默认是auto
    ++" " ++ "-hidden",

  {NodeName,Cookie,PaList,{Mod,Fun}} = es_node_item:get_start_cmd_info(EsNodeItem),
  NodeNameFlag = priv_get_node_name_flag(NodeName),
  CookieFlag = priv_get_node_cookie_flag(Cookie),
  PaFlag = priv_get_node_pa_flag(PaList),
  StartFunFlag = priv_get_node_start_fun_flag({Mod,Fun}),
  GameRootFlag = priv_get_game_root_flag(),

  FinalCmd = priv_get_erl_exec_cmd()
    ++" "++ NodeNameFlag
    ++" "++ CookieFlag
    ++" "++ StartFunFlag
    ++" "++ GameRootFlag
    ++" "++ PaFlag
    ++" "++ FixFlags,
  FinalCmd.

%% 守护进程启动节点
build_node_start_cmd_daemon(EsNodeItem)->
  FixFlags="+K true"            %% 启用内核轮询（Kernel Polling）,也就是epoll。这将使用操作系统的 I/O 多路复用机制来提高并发性能。
  ++" " ++ "+P 500000"          %% 设置进程预留存储器的大小。该参数指定 Erlang 进程系统的最大活动进程数。
  ++" " ++ "+Q 100000"          %% Port的最大数量，同时受限于系统的文件句柄数
  ++" " ++ "+t 10485760"        %% atom最大数量，默认1,048,576.
  ++" " ++ "+fnu"               %% 文件名强制utf-8编码，如果不是会异常
  ++" " ++ "+hms 8192"          %% 进程默认堆大小 单位字节
  ++" " ++ "+hmbs 8192"         %% 进程默认二进制虚拟堆大小 单位字节
  ++" " ++ "+zdbbl 81920"       %% 设置输出信息的缓冲区大小，单位千字节，默认值1024，缓冲区满了，会阻塞当前进程
  ++" " ++ "-detached"          %% 以守护进程的方式启动服务
  ++" " ++ "-kernel inet_dist_listen_min 16001"  %% 分布式系统中中节点的socket监听端口范围 最小值
  ++" " ++ "-kernel inet_dist_listen_max 17000"  %% 分布式系统中中节点的socket监听端口范围 最大值
  ++" " ++ "-smp enable"        %% 是否在多核上运行调度器，Otp R12B之后的版本会自动检测，设置和CPU逻辑核数相同的调度器，可不设置，默认是auto
  ++" " ++ "-hidden",

  {NodeName,Cookie,PaList,{Mod,Fun}} = es_node_item:get_start_cmd_info(EsNodeItem),
  NodeNameFlag = priv_get_node_name_flag(NodeName),
  CookieFlag = priv_get_node_cookie_flag(Cookie),
  PaFlag = priv_get_node_pa_flag(PaList),
  StartFunFlag = priv_get_node_start_fun_flag({Mod,Fun}),
  GameRootFlag = priv_get_game_root_flag(),

  FinalCmd = priv_get_erl_exec_cmd()
    ++" "++ NodeNameFlag
    ++" "++ CookieFlag
    ++" "++ StartFunFlag
    ++" "++ GameRootFlag
    ++" "++ PaFlag
    ++" "++ FixFlags,
  FinalCmd.
priv_get_erl_exec_cmd()->
  case es_node_cfg:is_win() of
    ?TRUE->"werl ";
    ?FALSE->"erl"
  end.

priv_get_node_name_flag(NodeName) when is_list(NodeName)->
  "-name "++NodeName.

priv_get_node_cookie_flag(Cookie) when is_list(Cookie)->
  "-setcookie " ++ Cookie.

priv_get_node_pa_flag(PaList)->
  RootPath = es_node_cfg:get_game_root_path(),
  PaFlag = priv_get_node_pa_flag(PaList,RootPath,"-pa"),
  PaFlag.

priv_get_node_pa_flag([Path|Less],RootPath,AccPaFlag) when is_list(Path) ->
  AccPaFlag_1 = AccPaFlag++" "++RootPath++Path,
  priv_get_node_pa_flag(Less,RootPath,AccPaFlag_1);
priv_get_node_pa_flag([],_RootPath,AccPaFlag) ->
  AccPaFlag.

priv_get_node_start_fun_flag({Mod,Fun}) when is_list(Mod) andalso is_list(Fun) ->
  "-s "++Mod++" "++Fun.

priv_get_game_root_flag() ->
  "-game_root_dir "++ es_node_cfg:get_game_root_path().

%% attach到目标进程
build_node_attach_cmd(EsNodeItem,TargetNodeName)->
  FixFlags= "-kernel inet_dist_listen_min 16001"  %% 分布式系统中中节点的socket监听端口范围 最小值
    ++" " ++ "-kernel inet_dist_listen_max 17000"  %% 分布式系统中中节点的socket监听端口范围 最大值
    ++" " ++ "-hidden",

  {NodeName,Cookie,PaList,_} = es_node_item:get_start_cmd_info(EsNodeItem),
  NodeNameFlag = priv_get_node_name_flag(NodeName),
  CookieFlag = priv_get_node_cookie_flag(Cookie),
  PaFlag = priv_get_node_pa_flag(PaList),
  RemshFlag = "-remsh " ++ TargetNodeName,

  FinalCmd = priv_get_erl_exec_cmd()
    ++" "++ NodeNameFlag
    ++" "++ CookieFlag
    ++" "++ RemshFlag
    ++" "++ PaFlag
    ++" "++ FixFlags,
  FinalCmd.

%% 在目标节点执行rpc
%% 节点提供rpc api 对rpc的功能进行控制
build_node_rpc_cmd(EsNodeItem,TargetNodeName,Args)->
  FixFlags= "-kernel inet_dist_listen_min 16001"  %% 分布式系统中中节点的socket监听端口范围 最小值
    ++" " ++ "-kernel inet_dist_listen_max 17000"  %% 分布式系统中中节点的socket监听端口范围 最大值
    ++" " ++ "-hidden"
    ++" " ++ "-noshell",
  {NodeName,Cookie,PaList,{Mod,Fun}} = es_node_item:get_start_cmd_info(EsNodeItem),
  NodeNameFlag = priv_get_node_name_flag(NodeName),
  CookieFlag = priv_get_node_cookie_flag(Cookie),
  StartFunFlag = priv_get_node_start_fun_flag({Mod,Fun}),
  PaFlag = priv_get_node_pa_flag(PaList),
  ExtraFlag = "-extra "++ TargetNodeName ++" " ++ Args ,

  FinalCmd = priv_get_erl_exec_cmd()
    ++" "++ NodeNameFlag
    ++" "++ CookieFlag
    ++" "++ StartFunFlag
    ++" "++ PaFlag
    ++" "++ FixFlags
    ++" "++ ExtraFlag,
  FinalCmd.

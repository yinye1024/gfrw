%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 25. 5月 2023 15:41
%%%-------------------------------------------------------------------
-module(es_node_tool).
-author("yinye").

-include("es_comm.hrl").

%% API
-export([start_cur_node_with_shell/0, start_cur_node_daemon/0,stop_cur_node/0]).
-export([cur_node_do_reload/1,attach_cur_node/0]).

%% 启动后 停留在 shell 进行后继交互，
%% 一般是启动报错的时候（log服务来不及启动）用来定位
start_cur_node_with_shell()->
  CurNodeItem = es_node_item:new_svr_node(),
  {NodeName,_Cookie,_PaList,{StarMod,StartFun}} = es_node_item:get_start_cmd_info(CurNodeItem),
  io:format("~n exec Start Node:~p ~p ~p ~n",[NodeName,StarMod,StartFun]),
  case priv_is_node_app_started(NodeName,StarMod) of
    ?FALSE ->
      io:format("~n Try Start Node ... :~p ~p ~p ~n",[NodeName,StarMod,StartFun]),
      io:format("~n Wait ...  ~n",[]),
      Cmd = es_node_cmd_builder:build_node_start_cmd_with_shell(CurNodeItem),
      FinalCmd = priv_check_string(Cmd),
      es_utils_exec:format_exec(FinalCmd),
      ?OK;
    ?TRUE ->
      io:format("[Warning] Node ~p is running, ",[NodeName]),
      ?OK
  end,
  ?OK.

%% 守护进程启动节点
start_cur_node_daemon()->
  CurNodeItem = es_node_item:new_svr_node(),
  {NodeName,_Cookie,_PaList,{StarMod,_StartFun}} = es_node_item:get_start_cmd_info(CurNodeItem),
  case priv_is_node_app_started(NodeName,StarMod) of
    ?FALSE ->
      Cmd = es_node_cmd_builder:build_node_start_cmd_daemon(CurNodeItem),
      FinalCmd = priv_check_string(Cmd),
      {_Resp,_Out} = es_utils_exec:port_exec(FinalCmd),
      %% 1 秒检查一次，等待20分钟
      MaxTry = 1200,
      priv_wait_node_up(NodeName,StarMod,MaxTry),
      ?OK;
    ?TRUE ->
      io:format("[Warning] Node ~p is running, ",[NodeName]),
      ?OK
  end,
  ?OK.
priv_wait_node_up(NodeName,MainAppName,0)->
  io:format("[Error] Node ~p start fail, check the svr error log, ",[NodeName]),
  throw(2);
priv_wait_node_up(NodeName,MainAppName,MaxTry)->
  io:format(".",[]),
  timer:sleep(1000),
  case priv_is_node_app_started(NodeName,MainAppName) of
    ?TRUE ->?Skip;
    ?FALSE -> priv_wait_node_up(NodeName,MainAppName,MaxTry-1)
  end,
  ?OK.

stop_cur_node()->
  CurNodeItem = es_node_item:new_svr_node(),
  {NodeName,_Cookie,_PaList,{StarMod,StartFun}} = es_node_item:get_start_cmd_info(CurNodeItem),
  io:format("~n exec Stop Node:~p ~p ~p ~n",[NodeName,StarMod,StartFun]),
  RpcCmd = "stop",
  IsSuccess = priv_do_cur_node_rpc(RpcCmd),

  case IsSuccess of
    ?TRUE ->
      io:format("~n Try Stop Node ... :~p ~p ~p ~n",[NodeName,StarMod,StartFun]),
      io:format("~n Wait ...  ~n",[]),
      %% 1 秒检查一次，等待20分钟
      MaxTry = 1200,
      priv_wait_node_down(NodeName,MaxTry),
      ?OK;
    ?FALSE ->
      io:format("[Warning] exec Stop fail: ~p, rpc fail ",[NodeName]),
      ?OK
  end,
  ?OK.

priv_wait_node_down(NodeName,0)->
  io:format("[Error] Node ~p stop fail, check the svr error log, ",[NodeName]),
  throw(2);
priv_wait_node_down(NodeName,MaxTry)->
  io:format(".",[]),
  timer:sleep(1000),
  case priv_is_node_alive(NodeName) of
    ?FALSE ->?Skip;
    ?TRUE -> priv_wait_node_down(NodeName,MaxTry-1)
  end,
  ?OK.

%% attach到当前节点
attach_cur_node()->
  CurNodeItem = es_node_item:new_attach_node(),
  {NodeName,_Cookie,_PaList,{StarMod,StartFun}} = es_node_item:get_start_cmd_info(CurNodeItem),
  io:format("~n Try to attach Node ... :~p ~p ~p ~n",[NodeName,StarMod,StartFun]),
  Cmd = es_node_cmd_builder:build_node_attach_cmd(CurNodeItem,NodeName),
  FinalCmd = priv_check_string(Cmd),
  es_utils_exec:format_exec(FinalCmd),
  ?OK.

%% ModsStr "-" 分隔，为空则reload all
cur_node_do_reload(ModsStr)->
  RpcCmd = "reload "++ ModsStr,
  IsSuccess = priv_do_cur_node_rpc(RpcCmd),
  IsSuccess.

priv_is_node_app_started(NodeName,MainAppName)->
  RpcCmd = "status "++ MainAppName,
  IsSuccess = priv_do_cur_node_rpc(RpcCmd),
  IsSuccess.

priv_do_cur_node_rpc(Args)->
  CurRpcNodeItem = es_node_item:new_rpc_node(),
  {NodeName,_Cookie,_PaList,{_StarMod,_StartFun}} = es_node_item:get_start_cmd_info(CurRpcNodeItem),
  Cmd = es_node_cmd_builder:build_node_rpc_cmd(NodeName, CurRpcNodeItem,Args),
  FinalCmd = priv_check_string(Cmd),
  {Resp,_Out} = es_utils_exec:port_exec(FinalCmd),
  es_node_rpc:is_success(Resp).

priv_is_node_alive(NodeName)->
  IsAlive = net_kernel:connect_node(NodeName),
  net_kernel:disconnect(NodeName),
  IsAlive.

%% 简单检查下是不是字符串
priv_check_string(Cmd)->
  Cmd_1 = binary_to_list(unicode:characters_to_binary(Cmd)),
  Cmd_1.
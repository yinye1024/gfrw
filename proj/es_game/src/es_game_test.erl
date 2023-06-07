%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 六月 2021 19:07
%%%-------------------------------------------------------------------
-module(es_game_test).
-author("yinye").
%% es_comm.hrl 和 eunit.hrl 都定义了 IF 宏，eunit.hrl做了保护
-include("es_comm.hrl").
-include_lib("eunit/include/eunit.hrl").

-define(GameRoot, "D:/allen_github/yinye1024/gfrw/proj/game").

-export([test/0,start_with_shell/0,start_daemon/0,attach/0,stop/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% es_game_test:test().
test()->
%%  start_with_shell(),
%%  start_daemon(),
%%  attach(),
  stop(),
  ?OK.

%% es_game_test:start_with_shell().
start_with_shell()->
  ?OK = file:set_cwd(?GameRoot),
  io:format("root path :~p~n",[file:get_cwd()]),

  CurNodeItem = es_node_item:new_svr_node(),
  {_NodeName,_Cookie,_PaList,{_StarMod,_StartFun}} = es_node_item:get_start_cmd_info(CurNodeItem),
  Cmd = es_node_cmd_builder:build_node_start_cmd_with_shell(CurNodeItem),
  write_to_file("start_with_shell",Cmd).
%% es_game_test:start_daemon().
start_daemon()->
  ?OK = file:set_cwd(?GameRoot),
  io:format("root path :~p~n",[file:get_cwd()]),

  CurNodeItem = es_node_item:new_svr_node(),
  {_NodeName,_Cookie,_PaList,{_StarMod,_StartFun}} = es_node_item:get_start_cmd_info(CurNodeItem),
  Cmd = es_node_cmd_builder:build_node_start_cmd_daemon(CurNodeItem),
  write_to_file("start_daemon",Cmd).
%% es_game_test:attach().
attach()->
  ?OK = file:set_cwd(?GameRoot),
  io:format("root path :~p~n",[file:get_cwd()]),

  TargetNodeItem = es_node_item:new_svr_node(),
  {TargetNodeName,_Cookie,_PaList,_} = es_node_item:get_start_cmd_info(TargetNodeItem),
  CurNodeItem = es_node_item:new_attach_node(),
  Cmd = es_node_cmd_builder:build_node_attach_cmd(CurNodeItem,TargetNodeName),
  write_to_file("attach",Cmd).
%% es_game_test:stop().
stop()->
  ?OK = file:set_cwd(?GameRoot),
  io:format("root path :~p~n",[file:get_cwd()]),

  Args = "stop",
  priv_print_rpc("stop",Args).

priv_print_rpc(FileName,Args)->
  TargetNodeItem = es_node_item:new_svr_node(),
  {TargetNodeName,_Cookie,_PaList,_} = es_node_item:get_start_cmd_info(TargetNodeItem),
  CurRpcNodeItem = es_node_item:new_rpc_node(),
  Cmd = es_node_cmd_builder:build_node_rpc_cmd(CurRpcNodeItem,TargetNodeName,Args),
  write_to_file(FileName,Cmd).

write_to_file(FileName,Text) ->
  OutPufFile = "D:/allen_github/yinye1024/gfrw/proj/es_game/test/"++ FileName ++".txt",
  case file:open(OutPufFile, [write, create]) of
    {ok, File} ->
      file:write(File, Text),
      file:close(File),
      ok;
    {error, Reason} ->
      {error, Reason}
  end.







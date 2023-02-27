%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_pc_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/1]).
-export([get_tcp_client_gen/0, set_tcp_client_gen/1]).
-export([get_userId/0]).
-export([get_client_role_info/0, update_client_role_info/1]).
-export([get_svr_role_info/0,update_svr_role_info/1]).
-export([on_gw_active/0, is_gw_active/0]).
-export([get_svr_mid/0,set_svr_mid/1]).
-export([set_is_miss_client_pack/1]).
-export([send_msg/1,reset_client_mid/1,get_client_mid/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(UserId)->
  robot_pc_dao:init(UserId),
  ?OK.

get_userId()->
  Data = priv_get_data(),
  robot_pc_pojo:get_id(Data).

get_client_role_info()->
  Data = priv_get_data(),
  robot_pc_pojo:get_client_role_info(Data).
update_client_role_info(ClientRoleInfoItem)->
  Data = priv_get_data(),
  NewData = robot_pc_pojo:set_client_role_info(ClientRoleInfoItem,Data),
  priv_update(NewData).

get_svr_role_info()->
  Data = priv_get_data(),
  robot_pc_pojo:get_svr_role_info(Data).
update_svr_role_info(SvrRoleInfoItem)->
  Data = priv_get_data(),
  NewData = robot_pc_pojo:set_svr_role_info(SvrRoleInfoItem,Data),
  priv_update(NewData).

get_svr_mid()->
  Data = priv_get_data(),
  robot_pc_pojo:get_svr_mid(Data).
set_svr_mid(SvrMid)->
  Data = priv_get_data(),
  NewData = robot_pc_pojo:set_svr_mid(SvrMid,Data),
  priv_update(NewData).






get_tcp_client_gen()->
  Data = priv_get_data(),
  ClientGen = robot_pc_pojo:get_tcp_client_gen(Data),
  ClientGen.

set_tcp_client_gen(TcpClientGen)->
  Data = priv_get_data(),
  NewData = robot_pc_pojo:set_tcp_client_gen(TcpClientGen,Data),
  priv_update(NewData),
  ?OK.

send_msg({C2SId,BinData})->
  MsgId = priv_get_and_incr_msgId(),
%%  ?LOG_INFO({"client send msg:",{MsgId,C2SId,BinData}}),
  ClientGen = get_tcp_client_gen(),
  yynw_tcp_client_api:send(ClientGen,{MsgId,C2SId,BinData}),
%%  case priv_is_miss_client_pack() of
%%    ?TRUE ->
%%      ?OK;
%%    ?FALSE ->
%%      ClientGen = get_tcp_client_gen(),
%%      yynw_tcp_client_api:send(ClientGen,{MsgId,C2SId,BinData}),
%%      ?OK
%%  end,
  ?OK.

priv_get_and_incr_msgId()->
  Data = priv_get_data(),
  {MsgId,Data_1} = robot_pc_pojo:get_and_incr_msgId(Data),
  priv_update(Data_1),
  MsgId.
get_client_mid()->
  Data = priv_get_data(),
  MsgId = robot_pc_pojo:get_client_mid(Data),
  MsgId.

set_is_miss_client_pack(IsDoMiss) when is_boolean(IsDoMiss)->
  Data = priv_get_data(),
  NewData = robot_pc_pojo:set_is_miss_client_pack(IsDoMiss,Data),
  priv_update(NewData).
priv_is_miss_client_pack()->
  Data = priv_get_data(),
  robot_pc_pojo:is_miss_client_pack(Data).


reset_client_mid(ClientMid)->
  Data = priv_get_data(),
  Data_1= robot_pc_pojo:set_client_mid(ClientMid,Data),
  priv_update(Data_1),
  ?OK.


is_gw_active() ->
  Data = priv_get_data(),
  robot_pc_pojo:is_active(Data).

on_gw_active() ->
  Data = priv_get_data(),
  NewData = robot_pc_pojo:set_is_active(?TRUE,Data),
  priv_update(NewData),
  ?OK.

priv_get_data()->
  Data = robot_pc_dao:get_data(),
  Data.

priv_update(Data)->
  robot_pc_dao:put_data(Data),
  ?OK.
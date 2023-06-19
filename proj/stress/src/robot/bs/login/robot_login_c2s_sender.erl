%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_login_c2s_sender).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/login_pb.hrl").

-include_lib("game_proto/include/cmd_map.hrl").
%% API functions defined
-export([role_login_c2s/2,create_role_c2s/2,role_logout_c2s/0,role_reconnect_c2s/3,reset_gw_mid_c2s/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
create_role_c2s(Name,Gender) when is_integer(Gender)->
  Record = #create_role_c2s{name = Name,
    gender = Gender
  },
  BinData = login_pb:encode_msg(Record),
  {C2SId,BinData} = {?CREATE_ROLE_C2S,BinData},
  ?LOG_INFO({"send create_role_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.

role_login_c2s(UId,UName) ->
  {Plat,GameId,SvrId} = {"tx","g_1",1},
  Machine = #p_machineInfo{
    device = "robot",
    device_id = "T100",
    device_name = "a nuo"
  },
  Record = #role_login_c2s{uid = UId,
    uname = UName,
    plat = Plat,
    game_id = GameId,
    svrId = SvrId,
    machine_info = Machine
    },
  BinData = login_pb:encode_msg(Record),
  {C2SId,BinData} = {?ROLE_LOGIN_C2S,BinData},
  ?LOG_INFO({"send role_login_c2s  ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.

role_logout_c2s() ->
  Record = #role_logout_c2s{
    },
  BinData = login_pb:encode_msg(Record),
  {C2SId,BinData} = {?ROLE_LOGOUT_C2S,BinData},
  ?LOG_INFO({"send role_logout_c2s  ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.

role_reconnect_c2s(UId,ClientMid,SvrMid)->
  Record = #role_reconnect_c2s{
    client_mid = ClientMid,
    svr_mid = SvrMid,
    svr_id = 1,
    uid = UId
  },
  BinData = login_pb:encode_msg(Record),
  {C2SId,BinData} = {?ROLE_RECONNECT_C2S,BinData},
  ?LOG_INFO({"send role_reconnect_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.

reset_gw_mid_c2s(ClientMid)->
  Record = #reset_gw_mid_c2s{
    mid = ClientMid
  },
  BinData = login_pb:encode_msg(Record),
  {C2SId,BinData} = {?RESET_GW_MID_C2S,BinData},
  ?LOG_INFO({"send reset_gw_mid_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.




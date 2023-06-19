%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_gm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/cmd_map.hrl").
-include_lib("game_proto/include/gm_pb.hrl").

%% API functions defined
-export([gm_cmd_c2s/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
gm_cmd_c2s(RpcCmd)->
  Record = #gm_cmd_c2s{cmd = RpcCmd},
  BinData = gm_pb:encode_msg(Record),
  {C2SId,BinData} = {?GM_CMD_C2S,BinData},
  ?LOG_INFO({"send gm_cmd_c2s ++++++++++++++",RpcCmd}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.
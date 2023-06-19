%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_prop_c2s_sender).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/prop_pb.hrl").
-include_lib("game_proto/include/cmd_map.hrl").

%% API functions defined
-export([role_prop_player_c2s/0]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================


role_prop_player_c2s() ->
  Record = #role_prop_player_c2s{},

  BinData = prop_pb:encode_msg(Record),
  {C2SId,BinData} = {?ROLE_PROP_PLAYER_C2S,BinData},
  ?LOG_INFO({"send role_prop_player_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.



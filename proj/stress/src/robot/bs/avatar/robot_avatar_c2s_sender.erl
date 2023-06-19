%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_avatar_c2s_sender).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/avatar_pb.hrl").
-include_lib("game_proto/include/cmd_map.hrl").

%% API functions defined
-export([avatar_heart_beat_c2s/0]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
avatar_heart_beat_c2s() ->
  Record = #avatar_heart_beat_c2s{svr_time = yyu_time:now_seconds()},

  BinData = avatar_pb:encode_msg(Record),
  {C2SId,BinData} = {?AVATAR_HEART_BEAT_C2S,BinData},
%%  ?LOG_INFO({"send avatar_heart_beat_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.




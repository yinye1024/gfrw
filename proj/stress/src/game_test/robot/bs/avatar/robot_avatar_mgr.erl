%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_avatar_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([send_heart_beat/0]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
send_heart_beat() ->
  robot_avatar_c2s_sender:avatar_heart_beat_c2s(),
  ?OK.




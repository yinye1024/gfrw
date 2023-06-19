%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_prop_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([role_prop_player_c2s/0, role_prop_player_s2c/1,role_prop_player_changed_s2c/1]).
-export([get_data/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
role_prop_player_c2s() ->
  robot_prop_c2s_sender:role_prop_player_c2s(),
  ?OK.
role_prop_player_s2c(BinData)->
  robot_prop_s2c_handler:role_prop_player_s2c(BinData),
  ?OK.
role_prop_player_changed_s2c(BinData)->
  robot_prop_s2c_handler:role_prop_player_changed_s2c(BinData),
  ?OK.

get_data()->
  robot_prop_data_mgr:get_data().

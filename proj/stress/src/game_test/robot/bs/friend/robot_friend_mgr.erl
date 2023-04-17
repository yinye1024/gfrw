%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_friend_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([friend_apply_list_c2s/0,friend_apply_list_s2c/1]).
-export([friend_new_apply_c2s/1,friend_new_apply_s2c/1]).
-export([friend_handle_apply_c2s/2,friend_handle_apply_s2c/1]).
-export([friend_list_c2s/0,friend_list_s2c/1]).
-export([get_data/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
friend_apply_list_c2s() ->
  robot_friend_c2s_sender:friend_apply_list_c2s(),
  ?OK.
friend_apply_list_s2c(BinData)->
  robot_friend_s2c_handler:friend_apply_list_s2c(BinData),
  ?OK.


friend_new_apply_c2s(FriendRoleId) ->
  robot_friend_c2s_sender:friend_new_apply_c2s(FriendRoleId),
  ?OK.
friend_new_apply_s2c(BinData)->
  robot_friend_s2c_handler:friend_new_apply_s2c(BinData),
  ?OK.


friend_handle_apply_c2s(ApplyId,IsAccept) ->
  robot_friend_c2s_sender:friend_handle_apply_c2s(ApplyId,IsAccept),
  ?OK.
friend_handle_apply_s2c(BinData)->
  robot_friend_s2c_handler:friend_handle_apply_s2c(BinData),
  ?OK.

friend_list_c2s() ->
  robot_friend_c2s_sender:friend_list_c2s(),
  ?OK.
friend_list_s2c(BinData)->
  robot_friend_s2c_handler:friend_list_s2c(BinData),
  ?OK.


get_data()->
  robot_friend_data_mgr:get_data().
%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_friend_c2s_sender).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/friend_pb.hrl").
-include_lib("game_proto/include/cmd_map.hrl").

%% API functions defined
-export([friend_apply_list_c2s/0,friend_new_apply_c2s/1,friend_handle_apply_c2s/2,friend_list_c2s/0]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
friend_apply_list_c2s() ->
  Record = #friend_apply_list_c2s{},

  BinData = friend_pb:encode_msg(Record),
  {C2SId,BinData} = {?FRIEND_APPLY_LIST_C2S,BinData},
  ?LOG_INFO({"send friend_apply_list_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.
friend_new_apply_c2s(FriendRoleId) ->
  Record = #friend_new_apply_c2s{friend_uid = FriendRoleId},

  BinData = friend_pb:encode_msg(Record),
  {C2SId,BinData} = {?FRIEND_NEW_APPLY_C2S,BinData},
  ?LOG_INFO({"send friend_new_apply_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.
friend_handle_apply_c2s(ApplyId,IsAccept) when is_integer(ApplyId)->
  Record = #friend_handle_apply_c2s{
    apply_id = ApplyId,
    is_accept = IsAccept},

  BinData = friend_pb:encode_msg(Record),
  {C2SId,BinData} = {?FRIEND_HANDLE_APPLY_C2S,BinData},
  ?LOG_INFO({"send friend_handle_apply_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.

friend_list_c2s() ->
  Record = #friend_list_c2s{},

  BinData = friend_pb:encode_msg(Record),
  {C2SId,BinData} = {?FRIEND_LIST_C2S,BinData},
  ?LOG_INFO({"send friend_list_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.


%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_friend_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/friend_pb.hrl").


%% API functions defined

-export([friend_apply_list_s2c/1,friend_new_apply_s2c/1,friend_handle_apply_s2c/1,friend_list_s2c/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================

friend_apply_list_s2c(BinData)->
  #friend_apply_list_s2c{
    apply_list = ApplyList
  } = friend_pb:decode_msg(BinData,friend_apply_list_s2c),
  BsData = robot_friend_data_mgr:get_data(),
  BsData_1 = robot_friend_data:set_apply_list(ApplyList,BsData),
  robot_friend_data_mgr:put_data(BsData_1),
  ?LOG_INFO({"friend_apply_list_s2c,{apply_list}",{ApplyList}}),
  ?OK.

friend_new_apply_s2c(BinData)->
  #friend_new_apply_s2c{
    success = Success
  } = friend_pb:decode_msg(BinData,friend_new_apply_s2c),
  ?LOG_INFO({"friend_new_apply_s2c {success}",{Success}}),
  ?OK.

friend_handle_apply_s2c(BinData)->
  #friend_handle_apply_s2c{
    success = Success
  } = friend_pb:decode_msg(BinData,friend_handle_apply_s2c),
  ?LOG_INFO({"friend_handle_apply_s2c {success}",{Success}}),
  ?OK.

friend_list_s2c(BinData)->
  #friend_list_s2c{
    friend_list = FriendList
  } = friend_pb:decode_msg(BinData,friend_list_s2c),
  BsData = robot_friend_data_mgr:get_data(),
  BsData_1 = robot_friend_data:set_friend_list(FriendList,BsData),
  robot_friend_data_mgr:put_data(BsData_1),
  ?LOG_INFO({"friend_list_s2c,{friend_list}",{FriendList}}),
  ?OK.
%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_mail_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/mail_pb.hrl").


%% API functions defined

-export([mail_list_s2c/1,mail_open_s2c/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
mail_list_s2c(BinData)->
  #mail_list_s2c{
    mail_list = FriendList
  } = mail_pb:decode_msg(BinData,mail_list_s2c),
  BsData = robot_mail_data_mgr:get_data(),
  BsData_1 = robot_mail_data:set_mail_list(FriendList,BsData),
  robot_mail_data_mgr:put_data(BsData_1),
  ?LOG_INFO({"mail_list_s2c,{mail_list}",{FriendList}}),
  ?OK.
mail_open_s2c(BinData)->
  #mail_open_s2c{
    success = IsSuccess
  } = mail_pb:decode_msg(BinData,mail_open_s2c),

  ?LOG_INFO({"mail_open_s2c,{IsSuccess}",{IsSuccess}}),
  ?OK.

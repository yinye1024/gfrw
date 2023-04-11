%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(friend_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/friend_pb.hrl").
%% API
-export([friend_apply_list_s2c/2]).

friend_apply_list_s2c(IsSuccess,{HeadId,HeadBorder})->
  Result = ?IF(IsSuccess,0,1),
  RCS2C = #friend_apply_list_s2c{
    apply_list = Result
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).


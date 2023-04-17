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
-export([friend_apply_list_s2c/1,friend_new_apply_s2c/1,friend_handle_apply_s2c/1,friend_list_s2c/1]).

friend_apply_list_s2c(PApplyInfoList)->
  ?LOG_ERROR({"PApplyInfoList ================ ",PApplyInfoList}),
  RCS2C = #friend_apply_list_s2c{
    apply_list = PApplyInfoList
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).

friend_new_apply_s2c(IsSuccess)->
  RCS2C = #friend_new_apply_s2c{
    success = IsSuccess
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).
friend_handle_apply_s2c(IsSuccess)->
  RCS2C = #friend_handle_apply_s2c{
    success = IsSuccess
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).

friend_list_s2c(PFriendInfoList)->
  RCS2C = #friend_list_s2c{
    friend_list = PFriendInfoList
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).

%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(mail_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/mail_pb.hrl").
%% API
-export([mail_list_s2c/1,mail_open_s2c/1]).

mail_list_s2c(PMailInfoList)->
  ?LOG_ERROR({"mail_list_s2c ================ ", PMailInfoList}),
  RCS2C = #mail_list_s2c{
    mail_list = PMailInfoList
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).

mail_open_s2c(IsSuccess)->
  RCS2C = #mail_open_s2c{
    success = IsSuccess
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).

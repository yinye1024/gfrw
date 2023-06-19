%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(avatar_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/avatar_pb.hrl").
%% API
-export([avatar_head_change_s2c/2,svr_open_time_s2c/1]).

avatar_head_change_s2c(IsSuccess,{HeadId,HeadBorder})->
  Result = ?IF(IsSuccess,0,1),
  RCS2C = #avatar_head_change_s2c{
    result = Result,
    head_id = HeadId,
    head_border = HeadBorder
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).

svr_open_time_s2c(OpenTime)->
  RCS2C = #svr_open_time_s2c{
    open_time = OpenTime
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).
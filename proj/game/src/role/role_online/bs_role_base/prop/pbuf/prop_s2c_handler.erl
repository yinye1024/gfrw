%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(prop_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/prop_pb.hrl").
%% API
-export([role_prop_player_s2c/1,role_prop_player_changed_s2c/1]).

role_prop_player_s2c(PKVList)->
  ?LOG_ERROR({"prop_list_s2c ================ ", PKVList}),
  RCS2C = #role_prop_player_s2c{
    kv_list = PKVList
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).

role_prop_player_changed_s2c(PKVList)->
  ?LOG_ERROR({"prop_list_s2c ================ ", PKVList}),
  RCS2C = #role_prop_player_changed_s2c{
    kv_list = PKVList
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).

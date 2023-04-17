%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 14. 4月 2023 15:01
%%%-------------------------------------------------------------------
-module(probuf_tester).
-author("yinye").
-include_lib("protobuf/include/friend_pb.hrl").

%% API probuf_tester:do().
-export([do/0]).
do()->

  RCS2C = #friend_apply_list_s2c{
    apply_list = [{p_applyInfo,3,5,<<"name_1001">>,1},{p_applyInfo,4,5,<<"name_1001">>,1},{p_applyInfo,5,5,<<"name_1001">>,1}]
  },
  Bin = friend_pb:encode_msg(RCS2C),
  S2c = friend_pb:decode_msg(Bin,friend_apply_list_s2c),
  {Bin,S2c}.



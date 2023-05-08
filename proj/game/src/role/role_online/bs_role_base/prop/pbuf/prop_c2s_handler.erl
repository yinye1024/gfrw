%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(prop_c2s_handler).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/prop_pb.hrl").

%% API
-export([role_prop_player_c2s/1]).

role_prop_player_c2s(C2SRD = #role_prop_player_c2s{})->
  ?LOG_INFO({"role_prop_player_c2s,",C2SRD}),
  PropMap = role_prop_mgr:get_plyaer_propMap(),
  PKVList = prop_pbuf_helper:to_p_prop_kv_list(yyu_map:to_kv_list(PropMap)),
  prop_s2c_handler:role_prop_player_s2c(PKVList),
  ?OK.

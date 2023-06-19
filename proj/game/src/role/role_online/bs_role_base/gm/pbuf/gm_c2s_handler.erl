%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(gm_c2s_handler).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/gm_pb.hrl").

%% API
-export([gm_cmd_c2s/1]).

gm_cmd_c2s(C2SRD = #gm_cmd_c2s{cmd = RpcCmd})->
  ?LOG_INFO({"gm_cmd_c2s,",C2SRD}),
  role_gm_mgr:gm_cmd(RpcCmd),
  ?OK.


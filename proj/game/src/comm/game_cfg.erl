%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 13. 1月 2023 14:46
%%%-------------------------------------------------------------------
-module(game_cfg).
-author("yinye").

%% API
-export([is_open_debug/0,get_svrId/0,get_svr_open_time/0]).

is_open_debug()->
  true.

get_svrId()->
  1.
get_svr_open_time()->
  yyu_time:now_seconds()+3600.
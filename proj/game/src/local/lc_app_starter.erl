%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 05. 1月 2023 15:13
%%%-------------------------------------------------------------------
-module(lc_app_starter).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API
-export([start_svr/0]).


start_svr()->
  priv_ets_init(),
  priv_start_svr(),
  ?OK.

priv_ets_init()->
  lc_role_app_api:ets_init(),
  lc_friend_app_api:ets_init(),
  ?OK.

priv_start_svr()->
  lc_role_app_api:start_svr(),
  lc_friend_app_api:start_svr(),
  ?OK.
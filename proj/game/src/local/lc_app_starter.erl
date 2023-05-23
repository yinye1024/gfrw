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
-export([ets_init/0,start_svr/0,stop_svr/0]).



ets_init()->
  lc_role_app_api:ets_init(),
  lc_friend_app_api:ets_init(),
  lc_mail_app_api:ets_init(),
  ?OK.

start_svr()->
  lc_monitor_app_api:start_svr(),
%%  lc_role_app_api:start_svr(),
%%  lc_friend_app_api:start_svr(),
%%  lc_mail_app_api:start_svr(),
  ?OK.

stop_svr()->
  lc_monitor_app_api:stop_svr(),
%%  lc_role_app_api:stop_svr(),
%%  lc_friend_app_api:stop_svr(),
%%  lc_mail_app_api:stop_svr(),
  ?OK.

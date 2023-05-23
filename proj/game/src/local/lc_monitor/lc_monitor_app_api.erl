%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_monitor_app_api).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([start_svr/0, stop_svr/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%%
start_svr()->
  gs_lc_monitor_top_mgr:start_sup_link(),
  ?OK.

stop_svr()->
  gs_lc_monitor_top_mgr:stop(),
  ?OK.

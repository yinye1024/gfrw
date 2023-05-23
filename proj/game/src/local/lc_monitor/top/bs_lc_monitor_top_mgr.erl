%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_lc_monitor_top_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/0, loop_tick/0,persistent/0,terminate/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  lc_monitor_top_mgr:init(),
  lc_monitor_top_ticker_mgr:init(),
  lc_monitor_top_ticker_mgr:add_loop(1,{30,fun lc_monitor_top_mgr:on_new_loop/0}),
  ?OK.

loop_tick()->
  lc_monitor_top_ticker_mgr:tick(),
  ?OK.

persistent()->
  ?OK.

terminate()->
  ?OK.











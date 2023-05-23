%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gs_lc_monitor_top_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([start_sup_link/0,stop/0]).
-export([call_fun/1,cast_fun/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
start_sup_link()->
  lc_monitor_top_sup:start_link(),
  ?OK.

stop()->
  lc_monitor_top_gen:do_stop(),
  ?OK.

call_fun({WorkFun,Param})->
  Result = lc_monitor_top_gen:call_fun({WorkFun,Param}),
  Result.
cast_fun({WorkFun,Param})->
  lc_monitor_top_gen:cast_fun({WorkFun,Param}),
  ?OK.

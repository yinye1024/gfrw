%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gs_tpl_single_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([start_sup_link/0,stop/0]).
-export([call_fun/1,cast_fun/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
start_sup_link()->
  tpl_single_sup:start_link(),
  ?OK.

stop()->
  tpl_single_gen:do_stop(),
  ?OK.

call_fun({WorkFun,Param})->
  Result = tpl_single_gen:call_fun({WorkFun,Param}),
  Result.
cast_fun({WorkFun,Param})->
  tpl_single_gen:cast_fun({WorkFun,Param}),
  ?OK.

%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_tpl_multi_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([ets_init/0,start_sup_link/0,new_child/1, stop/1]).
-export([call_fun/2,cast_fun/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
ets_init()->
  gs_tpl_multi_mgr:ets_init(),
  ?OK.
start_sup_link()->
  gs_tpl_multi_mgr:start_sup_link(),
  ?OK.

new_child({MultiId, MultiInitArgs})when is_integer(MultiId)->
  Pid = gs_tpl_multi_mgr:new_child({MultiId, MultiInitArgs}),
  Pid.

stop(MultiId) when is_integer(MultiId)->
  gs_tpl_multi_mgr:stop(MultiId),
  ?OK.

call_fun(MultiId,{WorkFun,Param}) when is_integer(MultiId)->
  Result = gs_tpl_multi_mgr:call_fun(MultiId,{WorkFun,Param}),
  Result.
cast_fun(MultiId,{WorkFun,Param}) when is_integer(MultiId)->
  gs_tpl_multi_mgr:cast_fun(MultiId,{WorkFun,Param}),
  ?OK.

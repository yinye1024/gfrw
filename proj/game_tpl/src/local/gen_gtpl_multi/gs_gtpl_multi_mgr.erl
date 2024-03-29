%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gs_gtpl_multi_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([ets_init/0,start_sup_link/0,new_child/1, stop/1]).
-export([call_fun/2,cast_fun/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
ets_init()->
  gtpl_multi_pid_mgr:ets_init(),
  ?OK.
start_sup_link()->
  gtpl_multi_sup:start_link(),
  ?OK.

new_child({GenId,GenInitArgs})->
  {?OK,Pid} = gtpl_multi_sup:new_child({GenId,GenInitArgs}),
  Pid.

stop(MultiId)->
  case gtpl_multi_pid_mgr:get_pid(MultiId) of
    ?NOT_SET ->?FAIL;
    CursorPid ->  gtpl_multi_gen:do_stop(CursorPid),
      ?OK
  end,
  ?OK.

call_fun(MultiId,{WorkFun,Param})->
  Result =
  case gtpl_multi_pid_mgr:get_pid(MultiId) of
    ?NOT_SET ->?FAIL;
    CursorPid -> gtpl_multi_gen:call_fun(CursorPid,{WorkFun,Param})
  end,
  Result.
cast_fun(MultiId,{WorkFun,Param})->
  case gtpl_multi_pid_mgr:get_pid(MultiId) of
    ?NOT_SET ->?FAIL;
    CursorPid -> gtpl_multi_gen:cast_fun(CursorPid,{WorkFun,Param}),
      ?OK
  end,
  ?OK.

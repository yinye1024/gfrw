%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gs_lc_offmsg_worker_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([ets_init/0,start_sup_link/0,new_child/1, stop/1]).
-export([call_fun/2,cast_fun/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
ets_init()->
  lc_offmsg_worker_pid_mgr:ets_init(),
  ?OK.
start_sup_link()->
  lc_offmsg_worker_sup:start_link(),
  ?OK.

new_child({GenId})->
  {?OK,Pid} = lc_offmsg_worker_sup:new_child({GenId}),
  Pid.

stop(GenId)->
  case lc_offmsg_worker_pid_mgr:get_pid(GenId) of
    ?NOT_SET ->?FAIL;
    CursorPid ->  lc_offmsg_worker_gen:do_stop(CursorPid),
      ?OK
  end,
  ?OK.

call_fun(GenId,{WorkFun, ParamList})->
  Result =
  case lc_offmsg_worker_pid_mgr:get_pid(GenId) of
    ?NOT_SET ->?FAIL;
    CursorPid -> lc_offmsg_worker_gen:call_fun(CursorPid,{WorkFun, ParamList})
  end,
  Result.
cast_fun(GenId,{WorkFun, ParamList})->
  case lc_offmsg_worker_pid_mgr:get_pid(GenId) of
    ?NOT_SET ->?FAIL;
    CursorPid -> lc_offmsg_worker_gen:cast_fun(CursorPid,{WorkFun, ParamList}),
      ?OK
  end,
  ?OK.

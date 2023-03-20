%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_tpl_worker_gen).
-author("yinye").

-behavior(gen_server).
-include_lib("yyutils/include/yyu_gs.hrl").
-include_lib("yyutils/include/yyu_comm.hrl").


-define(SERVER,?MODULE).

-record(state,{genId}).

%% API functions defined
-export([get_mod/0,start_link/1]).
-export([do_stop/1,cast_fun/2,call_fun/2]).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->?MODULE.
start_link({GenId})->
  PidName = yyu_misc:build_gen_name(?MODULE,GenId),
  gen_server:start_link({local,PidName},?MODULE, {GenId},[]).

do_stop(Pid)->
  priv_call(Pid,{stop}).

call_fun(Pid,{Fun, ParamList})->
  Msg = ?DO_FUN(Fun, ParamList),
  priv_call(Pid,Msg).

cast_fun(Pid,{Fun, ParamList})->
  Msg = ?DO_FUN(Fun, ParamList),
  priv_cast(Pid,Msg).

priv_call(Pid,Msg)->
  gen_server:call(Pid,Msg,?GEN_CALL_TIMEOUT).
priv_cast(Pid,Msg)->
  gen_server:cast(Pid,Msg).

%% ===================================================================================
%% Behavioural functions implements
%% ===================================================================================
init({GenId})->
  erlang:process_flag(trap_exit,true),
  bs_lc_tpl_worker_mgr:init({GenId}),
  lc_tpl_worker_pid_mgr:reg(GenId,self()),
  erlang:send_after(?GEN_TICK_SPAN,self(),{loop_tick}),
  erlang:send_after(?GEN_PERSIST_SPAN,self(),{persistent}),
  {?OK,#state{genId =GenId}}.

terminate(Reason,_State=#state{genId = GenId})->
  ?LOG_INFO({"gen terminate",[reason,Reason]}),
  ?TRY_CATCH(begin
               bs_lc_tpl_worker_mgr:terminate(),
               lc_tpl_worker_pid_mgr:unReg(GenId)
              end),
  ?OK.

code_change(_OldVsn,State,_Extra)->
  {?OK,State}.

handle_call(Msg,_From,State)->
  ?DO_HANDLE_CALL(Msg,State).

handle_cast(Msg,State)->
  ?DO_HANDLE_CAST(Msg,State).

handle_info(Msg,State)->
  ?DO_HANDLE_INFO(Msg,State).

%% ===================================================================================
%% internal functions implements
%% ===================================================================================
do_handle_call({stop},State)->
  {?STOP,?NORMAL,?OK,State};
do_handle_call(Msg,State)->
  Reply =
    case yyu_fun:call_do_fun(Msg) of
      ?UNKNOWN -> ?LOG_WARNING({"unknown info fun",[Msg]}),
        ?UNKNOWN;
      Result->Result
    end,
  {?REPLY,Reply,State}.


do_handle_cast(Msg,State)->
  case yyu_fun:cast_do_fun(Msg) of
    ?UNKNOWN -> ?LOG_WARNING({"unknown info fun",[Msg]});
    _->?OK
  end,
  {?NO_REPLY,State}.

do_handle_info({stop},State)->
  {?STOP,?NORMAL,State};
do_handle_info({persistent},State)->
  ?TRY_CATCH(bs_lc_tpl_worker_mgr:persistent()),
  erlang:send_after(?GEN_PERSIST_SPAN,self(),{persistent}),
  {?NO_REPLY,State};
do_handle_info({loop_tick},State)->
  ?TRY_CATCH(bs_lc_tpl_worker_mgr:loop_tick()),
  erlang:send_after(?GEN_TICK_SPAN,self(),{loop_tick}),
  {?NO_REPLY,State};
do_handle_info(Msg,State)->
  case yyu_fun:info_do_fun(Msg) of
    ?UNKNOWN -> ?LOG_WARNING({"unknown info fun",[Msg]});
    _->?OK
  end,
  {?NO_REPLY,State}.





%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_worker_gen).
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
  Mail = ?DO_FUN(Fun, ParamList),
  priv_call(Pid,Mail).

cast_fun(Pid,{Fun, ParamList})->
  Mail = ?DO_FUN(Fun, ParamList),
  priv_cast(Pid,Mail).

priv_call(Pid,Mail)->
  gen_server:call(Pid,Mail,?GEN_CALL_TIMEOUT).
priv_cast(Pid,Mail)->
  gen_server:cast(Pid,Mail).

%% ===================================================================================
%% Behavioural functions implements
%% ===================================================================================
init({GenId})->
  erlang:process_flag(trap_exit,true),
  bs_lc_mail_worker_mgr:init({GenId}),
  lc_mail_worker_pid_mgr:reg(GenId,self()),
  erlang:send_after(?GEN_TICK_SPAN,self(),{loop_tick}),
  erlang:send_after(?GEN_PERSIST_SPAN,self(),{persistent}),
  {?OK,#state{genId =GenId}}.

terminate(Reason,_State=#state{genId = GenId})->
  ?LOG_INFO({"gen terminate",[reason,Reason]}),
  ?TRY_CATCH(begin
               bs_lc_mail_worker_mgr:terminate(),
               lc_mail_worker_pid_mgr:unReg(GenId)
              end),
  ?OK.

code_change(_OldVsn,State,_Extra)->
  {?OK,State}.

handle_call(Mail,_From,State)->
  ?DO_HANDLE_CALL(Mail,State).

handle_cast(Mail,State)->
  ?DO_HANDLE_CAST(Mail,State).

handle_info(Mail,State)->
  ?DO_HANDLE_INFO(Mail,State).

%% ===================================================================================
%% internal functions implements
%% ===================================================================================
do_handle_call({stop},State)->
  {?STOP,?NORMAL,?OK,State};
do_handle_call(Mail,State)->
  Reply =
    case yyu_fun:call_do_fun(Mail) of
      ?UNKNOWN -> ?LOG_WARNING({"unknown info fun",[Mail]}),
        ?UNKNOWN;
      Result->Result
    end,
  {?REPLY,Reply,State}.


do_handle_cast(Mail,State)->
  case yyu_fun:cast_do_fun(Mail) of
    ?UNKNOWN -> ?LOG_WARNING({"unknown info fun",[Mail]});
    _->?OK
  end,
  {?NO_REPLY,State}.

do_handle_info({stop},State)->
  {?STOP,?NORMAL,State};
do_handle_info({persistent},State)->
  ?TRY_CATCH(bs_lc_mail_worker_mgr:persistent()),
  erlang:send_after(?GEN_PERSIST_SPAN,self(),{persistent}),
  {?NO_REPLY,State};
do_handle_info({loop_tick},State)->
  ?TRY_CATCH(bs_lc_mail_worker_mgr:loop_tick()),
  erlang:send_after(?GEN_TICK_SPAN,self(),{loop_tick}),
  {?NO_REPLY,State};
do_handle_info(Mail,State)->
  case yyu_fun:info_do_fun(Mail) of
    ?UNKNOWN -> ?LOG_WARNING({"unknown info fun",[Mail]});
    _->?OK
  end,
  {?NO_REPLY,State}.





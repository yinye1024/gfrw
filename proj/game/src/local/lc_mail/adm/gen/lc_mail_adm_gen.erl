%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_adm_gen).
-author("yinye").

-behavior(gen_server).
-include_lib("yyutils/include/yyu_gs.hrl").
-include_lib("yyutils/include/yyu_comm.hrl").


-define(SERVER,?MODULE).

-record(state,{}).

%% API functions defined
-export([get_mod/0,start_link/0]).
-export([do_stop/0,cast_fun/1,call_fun/1]).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->?MODULE.
start_link()->
  gen_server:start_link({local,?MODULE},?MODULE, [],[]).

do_stop()->
  priv_call({stop}).

call_fun({Fun,Param})->
  mail = ?DO_FUN(Fun,Param),
  priv_call(mail).

cast_fun({Fun,Param})->
  mail = ?DO_FUN(Fun,Param),
  priv_cast(mail).

priv_call(mail)->
  gen_server:call(?MODULE,mail,?GEN_CALL_TIMEOUT).
priv_cast(mail)->
  gen_server:cast(?MODULE,mail).

%% ===================================================================================
%% Behavioural functions implements
%% ===================================================================================
init(_Args)->
  erlang:process_flag(trap_exit,true),
  bs_lc_mail_adm_mgr:init(),
  erlang:send_after(?GEN_TICK_SPAN,self(),{loop_tick}),
  erlang:send_after(?GEN_PERSIST_SPAN,self(),{persistent}),
  {?OK,#state{}}.

terminate(Reason,_State=#state{})->
  ?LOG_INFO({"gen terminate",[reason,Reason]}),
  ?TRY_CATCH(bs_lc_mail_adm_mgr:terminate()),
  ?OK.

code_change(_OldVsn,State,_Extra)->
  {?OK,State}.

handle_call(mail,_From,State)->
  ?DO_HANDLE_CALL(mail,State).

handle_cast(mail,State)->
  ?DO_HANDLE_CAST(mail,State).

handle_info(mail,State)->
  ?DO_HANDLE_INFO(mail,State).

%% ===================================================================================
%% internal functions implements
%% ===================================================================================
do_handle_call({stop},State)->
  {?STOP,?NORMAL,?OK,State};
do_handle_call(mail,State)->
  Reply =
    case yyu_fun:call_do_fun(mail) of
      ?UNKNOWN -> ?LOG_WARNING({"unknown info fun",[mail]}),
        ?UNKNOWN;
      Result->Result
    end,
  {?REPLY,Reply,State}.


do_handle_cast(mail,State)->
  case yyu_fun:cast_do_fun(mail) of
    ?UNKNOWN -> ?LOG_WARNING({"unknown info fun",[mail]});
    _->?OK
  end,
  {?NO_REPLY,State}.

do_handle_info({stop},State)->
  {?STOP,?NORMAL,State};
do_handle_info({persistent},State)->
  ?TRY_CATCH(bs_lc_mail_adm_mgr:persistent()),
  erlang:send_after(?GEN_PERSIST_SPAN,self(),{persistent}),
  {?NO_REPLY,State};
do_handle_info({loop_tick},State)->
  ?TRY_CATCH(bs_lc_mail_adm_mgr:loop_tick()),
  erlang:send_after(?GEN_TICK_SPAN,self(),{loop_tick}),
  {?NO_REPLY,State};
do_handle_info(mail,State)->
  case yyu_fun:info_do_fun(mail) of
    ?UNKNOWN -> ?LOG_WARNING({"unknown info fun",[mail]});
    _->?OK
  end,
  {?NO_REPLY,State}.





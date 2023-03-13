%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_online_gen).
-author("yinye").

-behavior(gen_server).
-include_lib("yyutils/include/yyu_gs.hrl").
-include_lib("yyutils/include/yyu_comm.hrl").

-define(SERVER,?MODULE).
-record(state,{roleId}).


%% API functions defined
-export([get_mod/0,start_link/1]).
-export([do_stop/1,cast_fun/2,call_fun/2]).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->?MODULE.
start_link({RoleId,TcpGen})->
  gen_server:start_link(?MODULE, {RoleId,TcpGen},[]).

do_stop(Pid)->
  priv_call(Pid,{stop}).

call_fun(Pid,{Fun,Param})->
  Msg = ?DO_FUN(Fun,Param),
  priv_call(Pid,Msg).

cast_fun(Pid,{Fun,Param})->
  Msg = ?DO_FUN(Fun,Param),
  priv_cast(Pid,Msg).

priv_call(Pid,Msg)->
  gen_server:call(Pid,Msg,?GEN_CALL_TIMEOUT).
priv_cast(Pid,Msg)->
  gen_server:cast(Pid,Msg).

%% ===================================================================================
%% Behavioural functions implements
%% ===================================================================================
init({RoleId,TcpGen})->
  erlang:process_flag(trap_exit,true),
  bs_role_online_mgr:init({RoleId,TcpGen}),

  erlang:send_after(?GEN_TICK_SPAN,self(),{loop_tick}),
  erlang:send_after(?GEN_PERSIST_SPAN,self(),{persistent}),
  {?OK,#state{roleId = RoleId}}.

terminate(Reason,_State=#state{roleId = RoleId})->
  ?LOG_INFO({"gen terminate",[reason,Reason]}),
  ?TRY_CATCH(bs_role_online_mgr:terminate(RoleId)),
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
  ?TRY_CATCH(bs_role_online_mgr:persistent()),
  erlang:send_after(?GEN_PERSIST_SPAN,self(),{persistent}),
  {?NO_REPLY,State};
do_handle_info({loop_tick},State)->
  ?TRY_CATCH(bs_role_online_mgr:loop_tick()),
  erlang:send_after(?GEN_TICK_SPAN,self(),{loop_tick}),
  {?NO_REPLY,State};
do_handle_info(Msg,State)->
  case yyu_fun:info_do_fun(Msg) of
    ?UNKNOWN -> ?LOG_WARNING({"unknown info fun",[Msg]});
    _->?OK
  end,
  {?NO_REPLY,State}.





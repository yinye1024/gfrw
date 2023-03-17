%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_lc_mail_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([start_sup_link/0, stop/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%%
start_sup_link()->
  gs_lc_mail_adm_mgr:start_sup_link(),
  ?OK.

stop()->
  gs_lc_mail_adm_mgr:stop(),
  ?OK.

%%priv_call_fun(CursorPid,{WorkFun,Param})->
%%  Result = gs_lc_mail_adm_mgr:call_fun(CursorPid,{WorkFun,Param}),
%%  Result.
%%priv_cast_fun(CursorPid,{WorkFun,Param})->
%%  gs_lc_mail_adm_mgr:cast_fun(CursorPid,{WorkFun,Param}),
%%  ?OK.

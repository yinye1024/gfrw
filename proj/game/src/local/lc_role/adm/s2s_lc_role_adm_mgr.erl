%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_lc_role_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([ets_init/0,start_sup_link/0, stop/0]).
-export([get_data/1, update_if_in_ets_time_cache/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%%
ets_init()->
  lc_role_adm_mgr:ets_init(),
  ?OK.

start_sup_link()->
  gs_lc_role_adm_mgr:start_sup_link(),
  ?OK.

stop()->
  gs_lc_role_adm_mgr:stop(),
  ?OK.

get_data(RoleId)->
  RolePdbPojo = lc_role_adm_mgr:get_data(RoleId),
  RolePdbPojo.
update_if_in_ets_time_cache(RolePdbPojo)->
  lc_role_adm_mgr:update_if_in_ets_time_cache(RolePdbPojo),
  RolePdbPojo.

%%priv_call_fun(CursorPid,{WorkFun,Param})->
%%  Result = gs_lc_role_adm_mgr:call_fun(CursorPid,{WorkFun,Param}),
%%  Result.
%%priv_cast_fun(CursorPid,{WorkFun,Param})->
%%  gs_lc_role_adm_mgr:cast_fun(CursorPid,{WorkFun,Param}),
%%  ?OK.

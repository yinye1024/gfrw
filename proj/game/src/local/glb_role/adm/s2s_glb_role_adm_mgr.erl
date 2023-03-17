%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_glb_role_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([start_sup_link/0, stop/0]).
-export([get_data/1,put_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%%
start_sup_link()->
  gs_glb_role_adm_mgr:start_sup_link(),
  ?OK.

stop()->
  gs_glb_role_adm_mgr:stop(),
  ?OK.

get_data(RoleId)->
  RolePdbPojo = glb_role_adm_mgr:get_data(RoleId),
  RolePdbPojo.
put_data(RolePdbPojo)->
  RolePdbPojo = glb_role_adm_mgr:put_data(RolePdbPojo),
  RolePdbPojo.

%%priv_call_fun(CursorPid,{WorkFun,Param})->
%%  Result = gs_glb_role_adm_mgr:call_fun(CursorPid,{WorkFun,Param}),
%%  Result.
%%priv_cast_fun(CursorPid,{WorkFun,Param})->
%%  gs_glb_role_adm_mgr:cast_fun(CursorPid,{WorkFun,Param}),
%%  ?OK.

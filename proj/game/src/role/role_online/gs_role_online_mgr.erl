%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gs_role_online_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/0,new_child/1,close/1]).
-export([route_c2s/2,route_s2s/2,send_data/4]).
-export([call_reconnect/4,call_login/1,call_re_login/2]).
-export([get_role_pid/1]).

-define(MAX_IDLE_TIME, 30).   %% 最大闲置时间30秒，超过就退出进程，回收cursor。

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  role_online_sup:start_link(),
  role_online_gen_mgr:init(),
  ?OK.

new_child({RoleId,TcpGen}) when is_integer(RoleId)->
  case role_online_gen_mgr:get_pid(RoleId) of
    ?NOT_SET ->
      {?OK,Pid} = role_online_sup:new_child({RoleId,TcpGen}),
      Pid;
    Pid->
      Pid
  end.

close(RoleId)->
  case role_online_gen_mgr:get_pid(RoleId) of
    ?NOT_SET ->
      ?LOG_DEBUG({"role gen not found, id:",RoleId}),
      ?OK;
    RolePid->
      role_online_gen:do_stop(RolePid),
      ?OK
  end,
  ?OK.

route_c2s(RolePid,C2SMsg) when is_pid(RolePid)->
  priv_cast_fun(RolePid,{fun bs_role_online_mgr:route_c2s/1,[C2SMsg]}),
  ?OK.

route_s2s(RoleIdOrPid,{CastFun,ParamList})->
  priv_cast_fun(RoleIdOrPid,{CastFun,ParamList}),
  ?OK.

send_data(RoleIdOrRolePid,MsgId,C2SId,BinData)->
  priv_cast_fun(RoleIdOrRolePid,{fun bs_role_online_mgr:send_msg/1,[{MsgId,C2SId,BinData}]}),
  ?OK.

call_reconnect(RolePid,TcpGen,ClientMid,SvrMid)->
  Result =  priv_call_fun(RolePid,{fun bs_role_online_mgr:reconnect/1,[{TcpGen,ClientMid,SvrMid}]}),
  Result.
call_re_login(RolePid,TcpGen)->
  Result =  priv_call_fun(RolePid,{fun bs_role_online_mgr:re_login/1,[{TcpGen}]}),
  Result.
call_login(RolePid)->
  Result =  priv_call_fun(RolePid,{fun bs_role_online_mgr:login/1,[{}]}),
  Result.

priv_cast_fun(RolePid,{CastFun,ParamList})when is_pid(RolePid)->
  role_online_gen:cast_fun(RolePid,{CastFun,ParamList}),
  ?OK;
priv_cast_fun(RoleId,{CastFun,ParamList})->
  case get_role_pid(RoleId) of
    ?NOT_SET ->
      ?LOG_DEBUG({"role gen not found, id:",RoleId}),
      ?FAIL;
    RolePid->
      role_online_gen:cast_fun(RolePid,{CastFun,ParamList}),
      ?OK
  end.
priv_call_fun(RolePid,{CastFun,ParamList})when is_pid(RolePid)->
  role_online_gen:call_fun(RolePid,{CastFun,ParamList}),
  ?OK;
priv_call_fun(RoleId,{CastFun,ParamList})->
  case get_role_pid(RoleId) of
    ?NOT_SET ->
      ?LOG_DEBUG({"role gen not found, id:",RoleId}),
      ?FAIL;
    RolePid->
      role_online_gen:call_fun(RolePid,{CastFun,ParamList}),
      ?OK
  end.

get_role_pid(RoleId)->
  role_online_gen_mgr:get_pid(RoleId).


%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%       放一些角色相关的杂项，简单，KV数据
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_role_offmsg_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([callback_from_lc_msg/2]).
-export([apply_msg/2,notify_new_msg/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
callback_from_lc_msg(LocalPid,{LocalParam,CbParam})->
  {CastFun,ParamList} = {fun role_offmsg_cb_handler:handle_callback/1,[{LocalParam,CbParam}]},
  gs_role_online_mgr:route_s2s(LocalPid,{CastFun,ParamList}),
  ?OK.


apply_msg(RoleIdOrPid,Msg)->
  case Msg of
    {do_fun,CastFun,ParamList}->
        gs_role_online_mgr:route_s2s(RoleIdOrPid,{CastFun,ParamList}),
        ?OK;
    _Other ->
      ?LOG_ERROR({"unknown msg",RoleIdOrPid,Msg}),
      ?OK
  end,
  ?OK.

notify_new_msg(RoleIdOrPid)->
  {CastFun,ParamList} = {fun role_offmsg_mgr:notify_new_msg/0,[]},
  gs_role_online_mgr:route_s2s(RoleIdOrPid,{CastFun,ParamList}),
  ?OK.


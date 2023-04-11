%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%       放一些角色相关的杂项，简单，KV数据
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_role_pay_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([callback_from_lc_pay/2]).
-export([notify_new_pay/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
callback_from_lc_pay(LocalPid,{LocalParam,CbParam})->
  {CastFun,ParamList} = {fun role_pay_cb_handler:handle_callback/1,[{LocalParam,CbParam}]},
  gs_role_online_mgr:route_s2s(LocalPid,{CastFun,ParamList}),
  ?OK.

notify_new_pay(RoleIdOrPid)->
  {CastFun,ParamList} = {fun role_pay_mgr:notify_new_pay/0,[]},
  gs_role_online_mgr:route_s2s(RoleIdOrPid,{CastFun,ParamList}),
  ?OK.


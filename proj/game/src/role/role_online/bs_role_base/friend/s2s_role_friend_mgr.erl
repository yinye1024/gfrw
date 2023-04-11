%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%       放一些角色相关的杂项，简单，KV数据
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_role_friend_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([callback_from_lc_friend/2]).
-export([notify_new_apply/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
callback_from_lc_friend(LocalPid,{LocalParam,CbParam})->
  {CastFun,ParamList} = {fun role_friend_cb_handler:handle_callback/1,[{LocalParam,CbParam}]},
  gs_role_online_mgr:route_s2s(LocalPid,{CastFun,ParamList}),
  ?OK.



notify_new_apply(RoleIdOrPid)->
  {CastFun,ParamList} = {fun role_friend_mgr:notify_new_apply/0,[]},
  gs_role_online_mgr:route_s2s(RoleIdOrPid,{CastFun,ParamList}),
  ?OK.


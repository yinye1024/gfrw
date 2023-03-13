%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_role_tpl_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([do_s2s/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
do_s2s(RoleId,Params) when is_integer(RoleId) ->
  gs_role_online_mgr:route_s2s(RoleId,{fun role_tpl_pc_mgr:do_s2s/1,Params}),
  ?OK.
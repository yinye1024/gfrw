%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(glb_role_app_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([ets_init/0, gen_init/0, stop/0]).
-export([get_data/1]).
-export([new_role/1,update_role/1,set_online/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%%
ets_init()->
  s2s_glb_role_mgr:ets_init(),
  ?OK.

gen_init()->
  s2s_glb_role_mgr:start_sup_link(),
  s2s_glb_role_adm_mgr:start_sup_link(),
  ?OK.

stop()->
  gs_glb_role_adm_mgr:stop(),
  ?OK.

get_data(RoleId)->
  RolePdbPojo = glb_role_adm_mgr:get_data(RoleId),
  RolePdbPojo.

new_role(GlbRolePojo)->
  s2s_glb_role_mgr:new_role(GlbRolePojo),
  ?OK.
update_role(GlbRolePojo)->
  s2s_glb_role_mgr:update_role(GlbRolePojo),
  ?OK.
set_online(RoleId,IsOnline)->
  s2s_glb_role_mgr:set_online(RoleId,IsOnline),
  ?OK.

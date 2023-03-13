%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc

%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_glb_role_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/1, loop_tick/0,persistent/0,terminate/0]).
-export([new_role/1,update_role/1, set_online/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init({GenId})->
  glb_role_plrudb_mgr:proc_init(GenId),

  glb_role_ticker_mgr:init(),
  role_ticker_mgr:add_loop(1,{3600,fun glb_role_plrudb_mgr:check_lru/0}),
  ?OK.

loop_tick()->
  glb_role_ticker_mgr:tick(),
  ?OK.

persistent()->
  glb_role_plrudb_mgr:update_to_db(),
  ?OK.

terminate()->
  glb_role_plrudb_mgr:update_to_db(),
  ?OK.

new_role({GlbRolePojo})->
  glb_role_plrudb_mgr:new_role(GlbRolePojo),
  ?OK.
update_role({GlbRolePojo})->
  glb_role_plrudb_mgr:update_role(GlbRolePojo),
  ?OK.
set_online({RoleId,IsOnline})->
  glb_role_plrudb_mgr:set_online(RoleId,IsOnline),
  ?OK.
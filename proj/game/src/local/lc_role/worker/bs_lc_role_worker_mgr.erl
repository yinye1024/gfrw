%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc

%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_lc_role_worker_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/1, loop_tick/0,persistent/0,terminate/0]).
-export([update_or_new/1, set_online/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init({GenId})->
  lc_role_plrudb_mgr:proc_init(GenId),

  lc_role_worker_ticker_mgr:init(),
  lc_role_worker_ticker_mgr:add_loop(1,{3600,fun lc_role_plrudb_mgr:check_lru/0}),
  ?OK.

loop_tick()->
  lc_role_worker_ticker_mgr:tick(),
  ?OK.

persistent()->
  lc_role_plrudb_mgr:update_to_db(),
  ?OK.

terminate()->
  lc_role_plrudb_mgr:update_to_db(),
  ?OK.

update_or_new({LcRolePojo})->
  RoleId = lc_role_pdb_pojo:get_id(LcRolePojo),
  case lc_role_plrudb_mgr:get_role(RoleId) of
    ?NOT_SET ->
      lc_role_plrudb_mgr:new_role(LcRolePojo),
      ?OK;
    _->
      lc_role_plrudb_mgr:update_role(LcRolePojo),
      ?OK
  end,
  ?OK.
set_online({RoleId,IsOnline})->
  lc_role_plrudb_mgr:set_online(RoleId,IsOnline),
  ?OK.

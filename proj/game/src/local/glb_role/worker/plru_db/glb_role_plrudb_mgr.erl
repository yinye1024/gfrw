%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(glb_role_plrudb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/1,update_to_db/0,check_lru/0]).
-export([new_role/1,set_online/2, update_role/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(_GenId)->
  glb_role_plrudb_holder:proc_init(),
  ?OK.
update_to_db()->
  glb_role_plrudb_holder:update_to_db(),
  ?OK.
check_lru()->
  glb_role_plrudb_holder:check_lru(),
  ?OK.



new_role(GlbRole)->
  glb_role_plrudb_holder:put_data(GlbRole),
  ?OK.

set_online(RoleId,IsOnline)->
  GlbRole = priv_get_data(RoleId),
  NewGlbRole = glb_role_pdb_pojo:set_is_online(IsOnline,GlbRole),
  update_role(NewGlbRole),
  ?OK.

priv_get_data(RoleId)->
  Data = glb_role_plrudb_holder:get_data(RoleId),
  Data.

update_role(GlbRole)->
  NewGlbRole = glb_role_pdb_pojo:incr_ver(GlbRole),
  glb_role_plrudb_holder:put_data(NewGlbRole),
  ?OK.


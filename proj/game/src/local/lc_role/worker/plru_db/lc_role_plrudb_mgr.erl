%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_role_plrudb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/1,update_to_db/0,check_lru/0]).
-export([new_role/1,set_online/2, update_role/1, get_role/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(_GenId)->
  lc_role_plrudb_holder:proc_init(),
  ?OK.
update_to_db()->
  lc_role_plrudb_holder:update_to_db(),
  ?OK.
check_lru()->
  lc_role_plrudb_holder:do_lru(),
  ?OK.



set_online(RoleId,IsOnline)->
  LcRole = get_role(RoleId),
  NewLcRole = lc_role_pdb_pojo:set_is_online(IsOnline,LcRole),
  update_role(NewLcRole),
  ?OK.

get_role(RoleId)->
  Data = lc_role_plrudb_holder:get_data(RoleId),
  Data.

new_role(LcRole)->
  lc_role_plrudb_holder:create(LcRole),
  ?OK.
update_role(LcRole)->
  NewLcRole = lc_role_pdb_pojo:incr_ver(LcRole),
  lc_role_plrudb_holder:update(NewLcRole),
  s2s_lc_role_adm_mgr:update_if_in_ets_time_cache(NewLcRole),
  ?OK.




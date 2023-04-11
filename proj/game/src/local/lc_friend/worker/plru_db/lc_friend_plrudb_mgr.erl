%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_friend_plrudb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/1,update_to_db/0,check_lru/0]).

-export([add_blackId/1,rm_blackId/1]).
-export([add_friendId/1,rm_friendId/1]).
-export([get_all_apply/1,add_apply/1,rm_apply_byIndex/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(_GenId)->
  lc_friend_plrudb_holder:proc_init(),
  ?OK.
update_to_db()->
  lc_friend_plrudb_holder:update_to_db(),
  ?OK.
check_lru()->
  lc_friend_plrudb_holder:do_lru(),
  ?OK.


add_blackId({RoleId,BlackRoleId})->
  Data = priv_get_data(RoleId),
  NewData = lc_friend_pdb_pojo:add_blackId(BlackRoleId,Data),
  priv_update_data(NewData),
  ?OK.
rm_blackId({RoleId,BlackRoleId})->
  Data = priv_get_data(RoleId),
  NewData = lc_friend_pdb_pojo:rm_blackId(BlackRoleId,Data),
  priv_update_data(NewData),
  ?OK.

add_friendId({RoleId,FriendRoleId})->
  Data = priv_get_data(RoleId),
  NewData = lc_friend_pdb_pojo:add_friendId(FriendRoleId,Data),
  priv_update_data(NewData),
  ?OK.
rm_friendId({RoleId,FriendRoleId})->
  Data = priv_get_data(RoleId),
  NewData = lc_friend_pdb_pojo:rm_friendId(FriendRoleId,Data),
  priv_update_data(NewData),
  ?OK.

get_all_apply({RoleId,LocalCbPojo})->
  Data = priv_get_data(RoleId),
  ApplyList = lc_friend_pdb_pojo:get_all_apply(Data),
  yyu_local_callback_pojo:do_callback(ApplyList,LocalCbPojo),
  ?OK.

add_apply({RoleId,ApplyItem})->
  Data = priv_get_data(RoleId),
  NewData = lc_friend_pdb_pojo:add_apply(ApplyItem,Data),
  priv_update_data(NewData),
  %% 通知玩家进程过来处理数据
  s2s_role_friend_mgr:notify_new_apply(RoleId),
  ?OK.
rm_apply_byIndex({RoleId,Index})->
  Data = priv_get_data(RoleId),
  NewData = lc_friend_pdb_pojo:rm_apply_byIndex(Index,Data),
  priv_update_data(NewData),
  ?OK.

priv_get_data(RoleId)->
  Data = lc_friend_plrudb_holder:get_data(RoleId),
  Data.

priv_update_data(Data)->
  NewData = lc_friend_pdb_pojo:incr_ver(Data),
  lc_friend_plrudb_holder:put_data(NewData),
  %% 同时更新已经在ets cache中的数据
  lc_friend_app_api:update_if_in_cache(NewData),
  ?OK.


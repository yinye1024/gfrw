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
  priv_update(NewData),
  ?OK.
rm_blackId({RoleId,BlackRoleId})->
  Data = priv_get_data(RoleId),
  NewData = lc_friend_pdb_pojo:rm_blackId(BlackRoleId,Data),
  priv_update(NewData),
  ?OK.

add_friendId({RoleId,FriendRoleId})->
  Data = priv_get_data(RoleId),
  NewData = lc_friend_pdb_pojo:add_friendId(FriendRoleId,Data),
  priv_update(NewData),
  ?OK.
rm_friendId({RoleId,FriendRoleId})->
  Data = priv_get_data(RoleId),
  NewData = lc_friend_pdb_pojo:rm_friendId(FriendRoleId,Data),
  priv_update(NewData),
  ?OK.

get_all_apply({RoleId,LocalCbPojo})->
  Data = priv_get_data(RoleId),
  ApplyList = lc_friend_pdb_pojo:get_all_apply(Data),
  ApplyIndex = lc_friend_pdb_pojo:get_apply_index(Data),
  yyu_local_callback_pojo:do_callback({ApplyIndex,ApplyList},LocalCbPojo),
  ?OK.

add_apply({RoleId,ApplyItem})->
  Data = priv_get_data(RoleId),
  ApplyRoleId = lc_friend_apply_item:get_roleId(ApplyItem),
  ?LOG_INFO({"is_apply_exist",RoleId,ApplyRoleId,lc_friend_pdb_pojo:is_apply_exist(ApplyRoleId,Data)}),
  case lc_friend_pdb_pojo:is_apply_exist(ApplyRoleId,Data) of
    ?TRUE ->
      %% 申请已存在，不做处理
      ?OK;
    ?FALSE ->
      NewData = lc_friend_pdb_pojo:add_apply(ApplyItem,Data),
      priv_update(NewData),
      %% 通知玩家进程过来处理数据
      s2s_role_friend_mgr:notify_new_apply(RoleId),
      ?OK
  end,
  ?OK.
rm_apply_byIndex({RoleId,Index})->
  Data = priv_get_data(RoleId),
  NewData = lc_friend_pdb_pojo:rm_apply_byIndex(Index,Data),
  priv_update(NewData),
  ?OK.

priv_get_data(RoleId)->
  Data =
  case lc_friend_plrudb_holder:get_data(RoleId) of
    ?NOT_SET ->
      DataTmp = lc_friend_pdb_pojo:new_pojo(RoleId),
      lc_friend_plrudb_holder:create(DataTmp),
      DataTmp;
    DataTmp -> DataTmp
  end,
  Data.

priv_update(Data)->
  NewData = lc_friend_pdb_pojo:incr_ver(Data),
  lc_friend_plrudb_holder:update(NewData),

  s2s_lc_friend_adm_mgr:put_to_ets_time_cache(NewData),
  ?OK.


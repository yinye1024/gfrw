%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_friend_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/1]).
-export([send_get_all_apply/0, notify_new_apply/0, cbk_on_get_all_apply/1]).
-export([new_apply/1,handle_apply/2,get_all_apply/0]).
-export([get_friendList/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(RoleId)->
  role_friend_pdb_holder:init(RoleId),
  ?OK.

notify_new_apply()->
  send_get_all_apply(),
  ?OK.

send_get_all_apply()->
  RoleId = role_adm_mgr:get_roleId(),
  LocalCbPojo = role_friend_cb_handler:get_cb_on_get_all_apply(),
  lc_friend_app_api:get_all_apply(RoleId,LocalCbPojo),
  ?OK.

cbk_on_get_all_apply({NewLastIndex,ApplyItemList})->
  RoleId = role_adm_mgr:get_roleId(),

  RoleFriendData = priv_get_data(),
  LastIndex = role_friend_pdb_pojo:get_last_index(RoleFriendData),
  ApplyItemList_1 = yyu_list:filter(fun(ApplyItem) -> lc_friend_apply_item:get_index(ApplyItem) > LastIndex  end,ApplyItemList),

  RoleFriendData_1 = role_friend_pdb_pojo:set_last_index(NewLastIndex,RoleFriendData),
  RoleFriendData_2 = role_friend_pdb_pojo:put_applyList(ApplyItemList_1,RoleFriendData_1),
  priv_update_data(RoleFriendData_2),
  %% 通知 lc friend 移除已完成的friend
  lc_friend_app_api:rm_apply_byIndex(RoleId,NewLastIndex),
  ?OK.

get_all_apply()->
  Data = priv_get_data(),
  ApplyList = role_friend_pdb_pojo:get_all_apply(Data),
  ApplyList.


new_apply(FriendRoleId) when is_integer(FriendRoleId)->
  RolePojo = role_mgr:get_data(),
  RoleId = role_pdb_pojo:get_id(RolePojo),
  Name = role_pdb_pojo:get_name(RolePojo),
  Gender = role_pdb_pojo:get_gender(RolePojo),
  ApplyItem = lc_friend_apply_item:new_pojo({RoleId,Name,Gender}),
  lc_friend_app_api:add_apply(FriendRoleId,ApplyItem),
  ?OK.

handle_apply(ApplyId,IsAccepted) when is_integer(ApplyId)->
  Data = priv_get_data(),
  RoleId = role_friend_pdb_pojo:get_id(Data),
  ApplyItem = role_friend_pdb_pojo:get_apply(ApplyId, Data),
  Data_1 = role_friend_pdb_pojo:rm_apply(ApplyId, Data),
  priv_update_data(Data_1),

  case IsAccepted of
    ?TRUE ->
      %% 双向添加好友
      FriendRoleId = lc_friend_apply_item:get_roleId(ApplyItem),
      ?LOG_INFO({"lc_friend_app_api:add_friendId",RoleId,FriendRoleId}),
      lc_friend_app_api:add_friendId(RoleId, FriendRoleId),
      lc_friend_app_api:add_friendId(FriendRoleId,RoleId),
      ?OK;
    ?FALSE ->?OK
  end,
  ?OK.
get_friendList()->
  RoleId = role_adm_mgr:get_roleId(),
  LcFriend = lc_friend_app_api:get_data(RoleId),
  ?LOG_INFO({"dddddddd",LcFriend}),
  FriendIdList = lc_friend_pdb_pojo:get_friendIdList(LcFriend),
  LcRoleList = lc_role_app_api:get_list(FriendIdList),
  LcRoleList.




priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_friend_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(Data)->
  NewData = role_friend_pdb_pojo:incr_ver(Data),
  role_friend_pdb_holder:put_data(NewData),
  ?OK.



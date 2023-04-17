%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_friend_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/1,is_class/1,has_id/1,get_id/1,get_ver/1,incr_ver/1]).
-export([get_last_index/1,set_last_index/2]).
-export([get_all_apply/1,get_apply/2, update_apply/2,rm_apply/2,put_applyList/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,
    last_index => 0,     %% 最后处理的 index，> index 的认为是新的，需要处理的
    apply_roleId_map => yyu_map:new_map(), %% 在申请列表里的roleId
    apply_map => yyu_map:new_map()  %%{ApplyId,lc_apply_apply_item}
  }.

is_class(ItemMap)->
  yyu_map:get_value(class,ItemMap) == ?Class.

has_id(ItemMap)->
  get_id(ItemMap) =/= ?NOT_SET.

get_id(ItemMap) ->
  yyu_map:get_value('_id', ItemMap).

get_ver(ItemMap) ->
  yyu_map:get_value(ver, ItemMap).
incr_ver(ItemMap) ->
  NewVer = get_ver(ItemMap)+1,
  yyu_map:put_value(ver, NewVer, ItemMap).


get_last_index(ItemMap) ->
  yyu_map:get_value(last_index, ItemMap).

set_last_index(Value, ItemMap) ->
  yyu_map:put_value(last_index, Value, ItemMap).

get_apply(ApplyIndex,ItemMap)->
  ApplyMap = priv_get_apply_map(ItemMap),
  yyu_map:get_value(ApplyIndex,ApplyMap).

get_all_apply(ItemMap)->
  ApplyMap = priv_get_apply_map(ItemMap),
  yyu_map:all_values(ApplyMap).

update_apply(ApplyItem,ItemMap)->
  ApplyMap = priv_get_apply_map(ItemMap),
  ApplyId = lc_friend_apply_item:get_index(ApplyItem),
  ApplyMap_1 = yyu_map:put_value(ApplyId,ApplyItem,ApplyMap),
  priv_set_apply_map(ApplyMap_1,ItemMap).

rm_apply(ApplyId,ItemMap)->
  ApplyMap = priv_get_apply_map(ItemMap),
  ApplyItem = yyu_map:get_value(ApplyId,ApplyMap),
  ApplyMap_1 = yyu_map:remove(ApplyId,ApplyMap),

  RoleIdMap = priv_get_apply_roleId_map(ItemMap),
  ApplyRoleId = lc_friend_apply_item:get_roleId(ApplyItem),
  RoleIdMap_1 = yyu_map:remove(ApplyRoleId,RoleIdMap),

  ItemMap_1 = priv_set_apply_map(ApplyMap_1,ItemMap),
  priv_set_apply_map(RoleIdMap_1,ItemMap_1).


put_applyList(LcApplyItemList,ItemMap)->
  ApplyMap = priv_get_apply_map(ItemMap),
  RoleIdMap = priv_get_apply_roleId_map(ItemMap),
  {ApplyMap_1,AccRoleIdMap_1} = priv_put_applyList(LcApplyItemList,{ApplyMap,RoleIdMap}),

  ItemMap_1 = priv_set_apply_map(ApplyMap_1,ItemMap),
  ItemMap_2 = priv_set_apply_roleId_map(AccRoleIdMap_1,ItemMap_1),
  ItemMap_2.

priv_put_applyList([LcApplyItem|Less],{AccApplyMap,AccRoleIdMap})->
  ApplyId = lc_friend_apply_item:get_index(LcApplyItem),
  ApplyRoleId = lc_friend_apply_item:get_roleId(LcApplyItem),

  {AccApplyMap_2,AccRoleIdMap_2} =
  case yyu_map:has_key(ApplyRoleId,AccRoleIdMap) of
    ?TRUE -> {AccApplyMap,AccRoleIdMap};
    ?FALSE ->
      AccApplyMap_1 = yyu_map:put_value(ApplyId,LcApplyItem,AccApplyMap),
      AccRoleIdMap_1 = yyu_map:put_value(ApplyRoleId,1,AccRoleIdMap),
      {AccApplyMap_1,AccRoleIdMap_1}
  end,
  priv_put_applyList(Less, {AccApplyMap_2,AccRoleIdMap_2});
priv_put_applyList([],{AccApplyMap,AccRoleIdMap})->
  {AccApplyMap,AccRoleIdMap}.

priv_get_apply_map(ItemMap) ->
  yyu_map:get_value(apply_map, ItemMap).

priv_set_apply_map(Value, ItemMap) ->
  yyu_map:put_value(apply_map, Value, ItemMap).

priv_get_apply_roleId_map(ItemMap) ->
  yyu_map:get_value(apply_roleId_map, ItemMap).

priv_set_apply_roleId_map(Value, ItemMap) ->
  yyu_map:put_value(apply_roleId_map, Value, ItemMap).




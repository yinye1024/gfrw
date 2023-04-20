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

is_class(SelfMap)->
  yyu_map:get_value(class,SelfMap) == ?Class.

has_id(SelfMap)->
  get_id(SelfMap) =/= ?NOT_SET.

get_id(SelfMap) ->
  yyu_map:get_value('_id', SelfMap).

get_ver(SelfMap) ->
  yyu_map:get_value(ver, SelfMap).
incr_ver(SelfMap) ->
  NewVer = get_ver(SelfMap)+1,
  yyu_map:put_value(ver, NewVer, SelfMap).


get_last_index(SelfMap) ->
  yyu_map:get_value(last_index, SelfMap).

set_last_index(Value, SelfMap) ->
  yyu_map:put_value(last_index, Value, SelfMap).

get_apply(ApplyIndex,SelfMap)->
  ApplyMap = priv_get_apply_map(SelfMap),
  yyu_map:get_value(ApplyIndex,ApplyMap).

get_all_apply(SelfMap)->
  ApplyMap = priv_get_apply_map(SelfMap),
  yyu_map:all_values(ApplyMap).

update_apply(ApplyItem,SelfMap)->
  ApplyMap = priv_get_apply_map(SelfMap),
  ApplyId = lc_friend_apply_item:get_index(ApplyItem),
  ApplyMap_1 = yyu_map:put_value(ApplyId,ApplyItem,ApplyMap),
  priv_set_apply_map(ApplyMap_1,SelfMap).

rm_apply(ApplyId,SelfMap)->
  ApplyMap = priv_get_apply_map(SelfMap),
  ApplyItem = yyu_map:get_value(ApplyId,ApplyMap),
  ApplyMap_1 = yyu_map:remove(ApplyId,ApplyMap),

  RoleIdMap = priv_get_apply_roleId_map(SelfMap),
  ApplyRoleId = lc_friend_apply_item:get_roleId(ApplyItem),
  RoleIdMap_1 = yyu_map:remove(ApplyRoleId,RoleIdMap),

  SelfMap_1 = priv_set_apply_map(ApplyMap_1,SelfMap),
  priv_set_apply_map(RoleIdMap_1,SelfMap_1).


put_applyList(LcApplyItemList,SelfMap)->
  ApplyMap = priv_get_apply_map(SelfMap),
  RoleIdMap = priv_get_apply_roleId_map(SelfMap),
  {ApplyMap_1,AccRoleIdMap_1} = priv_put_applyList(LcApplyItemList,{ApplyMap,RoleIdMap}),

  SelfMap_1 = priv_set_apply_map(ApplyMap_1,SelfMap),
  SelfMap_2 = priv_set_apply_roleId_map(AccRoleIdMap_1,SelfMap_1),
  SelfMap_2.

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

priv_get_apply_map(SelfMap) ->
  yyu_map:get_value(apply_map, SelfMap).

priv_set_apply_map(Value, SelfMap) ->
  yyu_map:put_value(apply_map, Value, SelfMap).

priv_get_apply_roleId_map(SelfMap) ->
  yyu_map:get_value(apply_roleId_map, SelfMap).

priv_set_apply_roleId_map(Value, SelfMap) ->
  yyu_map:put_value(apply_roleId_map, Value, SelfMap).




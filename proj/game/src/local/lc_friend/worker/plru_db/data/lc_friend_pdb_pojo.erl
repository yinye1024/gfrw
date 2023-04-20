%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_friend_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/1,is_class/1,has_id/1,get_id/1,get_ver/1,incr_ver/1]).
-export([add_blackId/2,rm_blackId/2]).
-export([get_friendIdList/1,add_friendId/2,rm_friendId/2]).
-export([get_all_apply/1,add_apply/2,rm_apply_byIndex/2]).
-export([get_apply_index/1,is_apply_exist/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(Id)->
  #{
    '_id' => Id,ver=>0,class=>?MODULE,
    blackId_map => yyu_map:new_map(),   %% 黑名单    <RoleId,1>
    friendId_map => yyu_map:new_map(),   %% 朋友列表   <RoleId,1>

    apply_index => 1,
    apply_map => yyu_map:new_map()    %% 申请列表     <RoleId,lc_friend_apply_item>
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
  CurVer = get_ver(SelfMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, SelfMap).


add_blackId(RoleId,SelfMap)->
  Map = priv_get_blackId_map(SelfMap),
  Map_1 = yyu_map:put_value(RoleId,1,Map),
  priv_set_blackId_map(Map_1,SelfMap).

rm_blackId(RoleId,SelfMap)->
  Map = priv_get_blackId_map(SelfMap),
  Map_1 = yyu_map:remove(RoleId,Map),
  priv_set_blackId_map(Map_1,SelfMap).
priv_get_blackId_map(SelfMap) ->
  yyu_map:get_value(blackId_map, SelfMap).
priv_set_blackId_map(Value, SelfMap) ->
  yyu_map:put_value(blackId_map, Value, SelfMap).

get_friendIdList(SelfMap)->
  Map = priv_get_friendId_map(SelfMap),
  yyu_map:all_keys(Map).

add_friendId(RoleId,SelfMap)->
  Map = priv_get_friendId_map(SelfMap),
  Map_1 = yyu_map:put_value(RoleId,1,Map),
  priv_set_friendId_map(Map_1,SelfMap).

rm_friendId(RoleId,SelfMap)->
  Map = priv_get_friendId_map(SelfMap),
  Map_1 = yyu_map:remove(RoleId,Map),
  priv_set_friendId_map(Map_1,SelfMap).
priv_get_friendId_map(SelfMap) ->
  yyu_map:get_value(friendId_map, SelfMap).
priv_set_friendId_map(Value, SelfMap) ->
  yyu_map:put_value(friendId_map, Value, SelfMap).

get_all_apply(SelfMap)->
  Map = priv_get_apply_map(SelfMap),
  yyu_map:all_values(Map).

add_apply(ApplyItem,SelfMap)->
  RoleId = lc_friend_apply_item:get_roleId(ApplyItem),
  {NextIndex,SelfMap_1} = priv_incr_and_get_apply_index(SelfMap),
  ApplyItem_1 = lc_friend_apply_item:set_index(NextIndex,ApplyItem),

  Map = priv_get_apply_map(SelfMap_1),
  Map_1 = yyu_map:put_value(RoleId,ApplyItem_1,Map),
  priv_set_apply_map(Map_1,SelfMap_1).

is_apply_exist(RoleId,SelfMap)->
  Map = priv_get_apply_map(SelfMap),
  yyu_map:has_key(RoleId,Map).


rm_apply_byIndex(Index,SelfMap)->
  Map = priv_get_apply_map(SelfMap),
  FilterFun = fun(_RoleId,ApplyItem) -> lc_friend_apply_item:get_index(ApplyItem)>Index end,
  Map_1 = yyu_map:filter(FilterFun,Map),
  priv_set_apply_map(Map_1,SelfMap).
priv_get_apply_map(SelfMap) ->
  yyu_map:get_value(apply_map, SelfMap).
priv_set_apply_map(Value, SelfMap) ->
  yyu_map:put_value(apply_map, Value, SelfMap).
priv_incr_and_get_apply_index(SelfMap)->
  NextIndex = get_apply_index(SelfMap)+1,
  SelfMap_1 = priv_set_apply_index(NextIndex, SelfMap),
  {NextIndex,SelfMap_1}.
get_apply_index(SelfMap) ->
  yyu_map:get_value(apply_index, SelfMap).
priv_set_apply_index(Value, SelfMap) ->
  yyu_map:put_value(apply_index, Value, SelfMap).


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
-export([add_friendId/2,rm_friendId/2]).
-export([get_all_apply/1,add_apply/2,rm_apply_byIndex/2]).

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

is_class(ItemMap)->
  yyu_map:get_value(class,ItemMap) == ?Class.
has_id(ItemMap)->
  get_id(ItemMap) =/= ?NOT_SET.
get_id(ItemMap) ->
  yyu_map:get_value('_id', ItemMap).

get_ver(ItemMap) ->
  yyu_map:get_value(ver, ItemMap).
incr_ver(ItemMap) ->
  CurVer = get_ver(ItemMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, ItemMap).


add_blackId(RoleId,ItemMap)->
  Map = priv_get_blackId_map(ItemMap),
  Map_1 = yyu_map:put_value(RoleId,1,Map),
  priv_set_blackId_map(Map_1,ItemMap).

rm_blackId(RoleId,ItemMap)->
  Map = priv_get_blackId_map(ItemMap),
  Map_1 = yyu_map:remove(RoleId,Map),
  priv_set_blackId_map(Map_1,ItemMap).
priv_get_blackId_map(ItemMap) ->
  yyu_map:get_value(blackId_map, ItemMap).
priv_set_blackId_map(Value, ItemMap) ->
  yyu_map:put_value(blackId_map, Value, ItemMap).


add_friendId(RoleId,ItemMap)->
  Map = priv_get_friendId_map(ItemMap),
  Map_1 = yyu_map:put_value(RoleId,1,Map),
  priv_set_friendId_map(Map_1,ItemMap).

rm_friendId(RoleId,ItemMap)->
  Map = priv_get_friendId_map(ItemMap),
  Map_1 = yyu_map:remove(RoleId,Map),
  priv_set_friendId_map(Map_1,ItemMap).
priv_get_friendId_map(ItemMap) ->
  yyu_map:get_value(friendId_map, ItemMap).
priv_set_friendId_map(Value, ItemMap) ->
  yyu_map:put_value(friendId_map, Value, ItemMap).

get_all_apply(ItemMap)->
  Map = priv_get_apply_map(ItemMap),
  yyu_map:all_values(Map).

add_apply(ApplyItem,ItemMap)->
  RoleId = lc_friend_apply_item:get_roleId(ApplyItem),
  {NextIndex,ItemMap_1} = priv_incr_and_get_apply_index(ItemMap),
  ApplyItem_1 = lc_friend_apply_item:set_index(NextIndex,ApplyItem),

  Map = priv_get_apply_map(ItemMap_1),
  Map_1 = yyu_map:put_value(RoleId,ApplyItem_1,Map),
  priv_set_apply_map(Map_1,ItemMap_1).

rm_apply_byIndex(Index,ItemMap)->
  Map = priv_get_apply_map(ItemMap),
  FilterFun = fun(_RoleId,ApplyItem) -> lc_friend_apply_item:get_index(ApplyItem)>Index end,
  Map_1 = yyu_map:filter(FilterFun,Map),
  priv_set_apply_map(Map_1,ItemMap).
priv_get_apply_map(ItemMap) ->
  yyu_map:get_value(apply_map, ItemMap).
priv_set_apply_map(Value, ItemMap) ->
  yyu_map:put_value(apply_map, Value, ItemMap).
priv_incr_and_get_apply_index(ItemMap)->
  NextIndex = priv_get_apply_index(ItemMap)+1,
  ItemMap_1 = priv_set_apply_index(NextIndex, ItemMap),
  {NextIndex,ItemMap_1}.
priv_get_apply_index(ItemMap) ->
  yyu_map:get_value(apply_index, ItemMap).
priv_set_apply_index(Value, ItemMap) ->
  yyu_map:put_value(apply_index, Value, ItemMap).


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
-export([get_apply/2, update_apply/2,rm_apply/2,put_applyList/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,
    last_index => 0,     %% 最后处理的 index，> index 的认为是新的，需要处理的
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

update_apply(ApplyItem,ItemMap)->
  ApplyMap = priv_get_apply_map(ItemMap),
  ApplyId = lc_friend_apply_item:get_index(ApplyItem),
  ApplyMap_1 = yyu_map:put_value(ApplyId,ApplyItem,ApplyMap),
  priv_set_apply_map(ApplyMap_1,ItemMap).

rm_apply(ApplyId,ItemMap)->
  ApplyMap = priv_get_apply_map(ItemMap),
  ApplyMap_1 = yyu_map:remove(ApplyId,ApplyMap),
  priv_set_apply_map(ApplyMap_1,ItemMap).


put_applyList(LcApplyItemList,ItemMap)->
  ApplyMap = priv_get_apply_map(ItemMap),
  ApplyMap_1 = priv_put_applyList(LcApplyItemList,ApplyMap),
  priv_set_apply_map(ApplyMap_1,ItemMap).

priv_put_applyList([LcApplyItem|Less],AccApplyMap)->
  AccApplyMap_1 = yyu_map:put_value(lc_friend_apply_item:get_index(LcApplyItem),LcApplyItem,AccApplyMap),
  priv_put_applyList(Less,AccApplyMap_1);
priv_put_applyList([],AccApplyMap)->
  AccApplyMap.


priv_get_apply_map(ItemMap) ->
  yyu_map:get_value(apply_map, ItemMap).

priv_set_apply_map(Value, ItemMap) ->
  yyu_map:put_value(apply_map, Value, ItemMap).


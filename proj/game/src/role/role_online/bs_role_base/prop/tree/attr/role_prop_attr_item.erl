%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_attr_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_pojo/1]).
-export([get_id/1,get_ver/1,incr_ver/1,get_prop_map/1]).
-export([put_propMap/2,rm_by_keys/2,put_values/2,get_updated_propMap/2,filter_propMap/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(NodeId)->
  #{
    id=>NodeId,
    prop_map => yyu_map:new_map(),     %% <PropKey,PropValue>
    ver => -1
  }.

get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

incr_ver(SelfMap)->
  NewVer = get_ver(SelfMap)+1,
  priv_set_ver(NewVer,SelfMap).
get_ver(SelfMap) ->
  yyu_map:get_value(ver, SelfMap).
priv_set_ver(Value, SelfMap) ->
  yyu_map:put_value(ver, Value, SelfMap).

get_updated_propMap(?NOT_SET, SelfMap)->
  SelfMap;
get_updated_propMap(LastAttrItem, SelfMap)->
  SelfPropMap = get_prop_map(SelfMap),
  LastPropMap = get_prop_map(LastAttrItem),
  yyu_map:merge(LastPropMap, SelfPropMap).

filter_propMap(?NOT_SET,SelfMap)->
  SelfMap;
filter_propMap(IncludeList,SelfMap)->
  PropMap = get_prop_map(SelfMap),
  FilterFun = fun(PropKey,_PropValue) -> yyu_list:contains(PropKey,IncludeList) end,
  PropMap_1 = yyu_map:filter(FilterFun,PropMap),
  priv_set_prop_map(PropMap_1,SelfMap).

put_propMap(UpdatePropMap,SelfMap)->
  KVList = yyu_map:to_kv_list(UpdatePropMap),
  put_values(KVList,SelfMap).

rm_by_keys(KeyList,SelfMap)->
  PropMap = get_prop_map(SelfMap),
  PropMap_1 = yyu_map:remove_all(KeyList,PropMap),
  priv_set_prop_map(PropMap_1,SelfMap).

put_values(KVList,SelfMap)->
  PropMap = get_prop_map(SelfMap),
  PropMap_1 = priv_put_values(KVList,PropMap),
  priv_set_prop_map(PropMap_1,SelfMap).

priv_put_values([{PropKey,PropValue}|Less], AccPropMap) ->
  AccPropMap_1 = yyu_map:put_value(PropKey,PropValue,AccPropMap),
  priv_put_values(Less, AccPropMap_1);
priv_put_values([], AccPropMap) ->
  AccPropMap.

get_prop_map(SelfMap) ->
  yyu_map:get_value(prop_map, SelfMap).
priv_set_prop_map(Value, SelfMap) ->
  yyu_map:put_value(prop_map, Value, SelfMap).





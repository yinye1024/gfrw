%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_item/2]).
-export([get_id/1,get_cfgId/1,get_type/1]).
-export([get_context/1, set_context/2]).
-export([get_lattice/2, put_lattice/2,get_lattice_list/2,put_lattice_list/2]).
-export([get_ext_data/1,set_ext_data/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_item(ShopId,{ShopType,CfgId,ShopContext,LatticeMap})->
  #{
    id => ShopId,
    cfgId => CfgId,
    type => ShopType,
    context => ShopContext,
    lattice_map => LatticeMap,      %% <LatticeId,role_shop_lattice_item>
    ext_data => ?NOT_SET            %% 每种商店自己的扩展字段，
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_cfgId(ItemMap) ->
  yyu_map:get_value(cfgId, ItemMap).

get_type(ItemMap) ->
  yyu_map:get_value(type, ItemMap).

get_context(ItemMap) ->
  yyu_map:get_value(context, ItemMap).

set_context(Value, ItemMap) ->
  yyu_map:put_value(context, Value, ItemMap).

get_lattice_list(LatticeIdList,ItemMap)->
  priv_get_lattice_list(LatticeIdList,ItemMap,[]).
priv_get_lattice_list([LatticeId|Less],ItemMap,AccList)->
  AccList_1 =
  case  get_lattice(LatticeId,ItemMap) of
    ?NOT_SET ->
      AccList;
    LatticeItem ->
      [LatticeItem|AccList]
  end,
  priv_get_lattice_list(Less,ItemMap,AccList_1);
priv_get_lattice_list([],_ItemMap,AccList)->
  AccList.

get_lattice(LatticeId,ItemMap)->
  Map = priv_get_lattice_map(ItemMap),
  LatticeItem = yyu_map:get_value(LatticeId,Map),
  LatticeItem.

put_lattice_list([LatticeItem|Less],ItemMap)->
  ItemMap_1 = put_lattice(LatticeItem,ItemMap),
  put_lattice_list(Less,ItemMap_1);
put_lattice_list([],ItemMap)->
  ItemMap.

put_lattice(LatticeItem,ItemMap)->
  Map = priv_get_lattice_map(ItemMap),
  LatticeId = role_shop_lattice_item:get_id(LatticeItem),
  Map_1 = yyu_map:put_value(LatticeId,LatticeItem,Map),
  priv_set_lattice_map(Map_1, ItemMap).

priv_get_lattice_map(ItemMap) ->
  yyu_map:get_value(lattice_map, ItemMap).

priv_set_lattice_map(Value, ItemMap) ->
  yyu_map:put_value(lattice_map, Value, ItemMap).


get_ext_data(ItemMap) ->
  yyu_map:get_value(ext_data, ItemMap).

set_ext_data(Value, ItemMap) ->
  yyu_map:put_value(ext_data, Value, ItemMap).


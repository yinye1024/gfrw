%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_context).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_data/2]).
-export([get_id/1]).
-export([get_good_item/2, put_good_item/2]).
-export([get_tick_lattice_id_list/1,put_tick_latticeId/2,rm_tick_latticeId/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_data(ShipId,GoodMap)->
  #{
    id => ShipId,
    tick_lattice_id_map=>yyu_map:new_map(),
    good_map => GoodMap   %% <GoodId,role_shop_good_item>
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_good_item(GoodId,ItemMap)->
  GoodMap = priv_get_good_map(ItemMap),
  GoodItem = yyu_map:get_value(GoodId,GoodMap),
  GoodItem.

put_good_item(GoodItem,ItemMap)->
  GoodMap = priv_get_good_map(ItemMap),
  GoodId = role_shop_good_item:get_id(GoodItem),
  GoodMap_1 = yyu_map:put_value(GoodId,GoodItem,GoodMap),
  priv_set_good_map(GoodMap_1,ItemMap).

priv_get_good_map(ItemMap) ->
  yyu_map:get_value(good_map, ItemMap).

priv_set_good_map(Value, ItemMap) ->
  yyu_map:put_value(good_map, Value, ItemMap).




get_tick_lattice_id_list(ItemMap)->
  Map = priv_get_tick_lattice_id_map(ItemMap),
  yyu_map:all_values(Map).

put_tick_latticeId(LatticeId,ItemMap)->
  GoodMap = priv_get_tick_lattice_id_map(ItemMap),
  GoodMap_1 = yyu_map:put_value(LatticeId,1,GoodMap),
  priv_set_tick_lattice_id_map(GoodMap_1,ItemMap).

rm_tick_latticeId(LatticeId,ItemMap)->
  GoodMap = priv_get_tick_lattice_id_map(ItemMap),
  GoodMap_1 = yyu_map:remove(LatticeId,GoodMap),
  priv_set_tick_lattice_id_map(GoodMap_1,ItemMap).

priv_get_tick_lattice_id_map(ItemMap) ->
  yyu_map:get_value(tick_lattice_id_map, ItemMap).

priv_set_tick_lattice_id_map(Value, ItemMap) ->
  yyu_map:put_value(tick_lattice_id_map, Value, ItemMap).


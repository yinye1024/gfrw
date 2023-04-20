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

get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_cfgId(SelfMap) ->
  yyu_map:get_value(cfgId, SelfMap).

get_type(SelfMap) ->
  yyu_map:get_value(type, SelfMap).

get_context(SelfMap) ->
  yyu_map:get_value(context, SelfMap).

set_context(Value, SelfMap) ->
  yyu_map:put_value(context, Value, SelfMap).

get_lattice_list(LatticeIdList,SelfMap)->
  priv_get_lattice_list(LatticeIdList,SelfMap,[]).
priv_get_lattice_list([LatticeId|Less],SelfMap,AccList)->
  AccList_1 =
  case  get_lattice(LatticeId,SelfMap) of
    ?NOT_SET ->
      AccList;
    LatticeItem ->
      [LatticeItem|AccList]
  end,
  priv_get_lattice_list(Less,SelfMap,AccList_1);
priv_get_lattice_list([],_SelfMap,AccList)->
  AccList.

get_lattice(LatticeId,SelfMap)->
  Map = priv_get_lattice_map(SelfMap),
  LatticeItem = yyu_map:get_value(LatticeId,Map),
  LatticeItem.

put_lattice_list([LatticeItem|Less],SelfMap)->
  SelfMap_1 = put_lattice(LatticeItem,SelfMap),
  put_lattice_list(Less,SelfMap_1);
put_lattice_list([],SelfMap)->
  SelfMap.

put_lattice(LatticeItem,SelfMap)->
  Map = priv_get_lattice_map(SelfMap),
  LatticeId = role_shop_lattice_item:get_id(LatticeItem),
  Map_1 = yyu_map:put_value(LatticeId,LatticeItem,Map),
  priv_set_lattice_map(Map_1, SelfMap).

priv_get_lattice_map(SelfMap) ->
  yyu_map:get_value(lattice_map, SelfMap).

priv_set_lattice_map(Value, SelfMap) ->
  yyu_map:put_value(lattice_map, Value, SelfMap).


get_ext_data(SelfMap) ->
  yyu_map:get_value(ext_data, SelfMap).

set_ext_data(Value, SelfMap) ->
  yyu_map:put_value(ext_data, Value, SelfMap).


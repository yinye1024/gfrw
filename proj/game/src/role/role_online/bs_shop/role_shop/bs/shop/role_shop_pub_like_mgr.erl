%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_pub_like_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include("shop.hrl").

%% API functions defined
-export([init/2,refresh_shop/1,tick/1]).
-export([buy_shop_goods/2,refresh_lattice/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(ShopId,ShopCfgItem)->
  case priv_get_data(ShopId) of
    ?NOT_SET ->
      new_shop(ShopId,ShopCfgItem);
    _Other ->?OK
  end,
  ?OK.

new_shop(ShopId,ShopCfgItem)->
  ShopType = ?ShopType_Pub,
  GoodMap = priv_build_good_map(ShopCfgItem),

  ShopContext = role_shop_context:new_data(ShopId,GoodMap),
  {LatticeMap,ShopContext_1} =priv_build_lattice_map(ShopCfgItem,ShopContext),

  CfgId = role_shop_cfg_item:get_cfgId(ShopCfgItem),
  ShopItem = role_shop_item:new_item(ShopId,{ShopType,CfgId,ShopContext_1,LatticeMap}),
  priv_update_data(ShopItem),
  ?OK.
priv_build_good_map(ShopCfgItem)->
  yyu_map:new_map().
priv_build_lattice_map(ShopCfgItem,ShopContext)->
  {yyu_map:new_map(),ShopContext}.

refresh_shop(ShopId)->
  ShopItem = priv_get_data(ShopId),
  ?OK.

tick(ShopId)->
  ShopItem = priv_get_data(ShopId),
  ShopContext = role_shop_item:get_context(ShopItem),
  LatticeIdList = role_shop_context:get_tick_lattice_id_list(ShopContext),
  LatticeItemList = role_shop_item:get_lattice_list(LatticeIdList, ShopItem),
  [ShopContext_1,LatticeItemList_1] = priv_do_lattice_tick(LatticeItemList,ShopContext,[]),

  ShopItem_1 = role_shop_item:set_context(ShopContext_1,ShopItem),
  ShopItem_2 = role_shop_item:put_lattice_list(LatticeItemList_1,ShopItem_1),
  priv_update_data(ShopItem_2),
  ?OK.
priv_do_lattice_tick([LatticeItem|Less], AccShopContext, AccItemList)->
  {LatticeItem_1,AccShopContext_1} = role_shop_lattice_agent:do_tick(LatticeItem, AccShopContext),
  priv_do_lattice_tick(Less, AccShopContext_1,[LatticeItem_1| AccItemList]);
priv_do_lattice_tick([], AccShopContext, AccItemList)->
  AccShopContext, AccItemList.



buy_shop_goods(ShopId,LatticeId)->
  ShopItem = priv_get_data(ShopId),
  ShopContext = role_shop_item:get_context(ShopItem),
  case role_shop_item:get_lattice(LatticeId,ShopItem) of
    ?NOT_SET ->?OK;
    LatticeItem ->
      {LatticeItem_1,ShopContext_1} = role_shop_lattice_agent:do_buy(LatticeItem,ShopContext),
      ShopItem_1 = role_shop_item:put_lattice(LatticeItem_1,ShopItem),
      ShopItem_2 = role_shop_item:set_context(ShopContext_1,ShopItem_1),
      priv_update_data(ShopItem_2),
      ?OK
  end,
  ?OK.
refresh_lattice(ShopId,LatticeId)->
  ShopItem = priv_get_data(ShopId),
  ShopContext = role_shop_item:get_context(ShopItem),
  case role_shop_item:get_lattice(LatticeId,ShopItem) of
    ?NOT_SET ->?OK;
    LatticeItem ->
      {LatticeItem_1,ShopContext_1} = role_shop_lattice_agent:do_refresh(LatticeItem,ShopContext),
      ShopItem_1 = role_shop_item:put_lattice(LatticeItem_1,ShopItem),
      ShopItem_2 = role_shop_item:set_context(ShopContext_1,ShopItem_1),
      priv_update_data(ShopItem_2),
      ?OK
  end,
  ?OK.

priv_get_data(ShopId)->
  role_shop_pdb_mgr:get_shop_item(ShopId).
priv_update_data(ShopItem)->
  role_shop_pdb_mgr:put_shop_item(ShopItem),
  ?OK.



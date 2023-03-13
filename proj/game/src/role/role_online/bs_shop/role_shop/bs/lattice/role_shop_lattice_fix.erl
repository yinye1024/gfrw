%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_lattice_fix).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([do_tick/2,do_buy/2,do_refresh/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
do_tick(LatticeItem,ShopData)->
  GoodId = role_shop_lattice_item:get_goodId(LatticeItem),
  GoodItem = role_shop_context:get_good_item(GoodId,ShopData),
  {LatticeItem_1,GoodItem_1} = priv_do_tick(LatticeItem,GoodItem),
  ShopData_1 = role_shop_context:put_good_item(GoodItem_1,ShopData),
  {LatticeItem_1,ShopData_1}.
priv_do_tick(LatticeItem,GoodItem)->
  {LatticeItem,GoodItem}.

do_buy(LatticeItem,ShopData)->
  GoodId = role_shop_lattice_item:get_goodId(LatticeItem),
  GoodItem = role_shop_context:get_good_item(GoodId,ShopData),
  {LatticeItem_1,GoodItem_1} = priv_do_buy(LatticeItem,GoodItem),
  ShopData_1 = role_shop_context:put_good_item(GoodItem_1,ShopData),
  {LatticeItem_1,ShopData_1}.
priv_do_buy(LatticeItem,GoodItem)->
  {LatticeItem,GoodItem}.

do_refresh(LatticeItem,ShopData)->
  %% fix的格子 不刷新
  {LatticeItem,ShopData}.

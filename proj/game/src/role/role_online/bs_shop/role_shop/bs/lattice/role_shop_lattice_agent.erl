%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_lattice_agent).
-author("yinye").

-define(LatticeType_Fix,1).
-define(LatticeType_Loop,2).
-define(LatticeType_Rand,3).

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([do_tick/2,do_buy/2,do_refresh/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
do_tick(LatticeItem,ShopData)->
  Type = role_shop_lattice_item:get_type(LatticeItem),
  {LatticeItem_1,ShopData_1} = priv_do_tick(Type,{LatticeItem,ShopData}),
  {LatticeItem_1,ShopData_1}.
priv_do_tick(?LatticeType_Fix,{LatticeItem,ShopData})->
  {LatticeItem_1,ShopData_1} = role_shop_lattice_fix:do_tick(LatticeItem,ShopData),
  {LatticeItem_1,ShopData_1};
priv_do_tick(LatticeType,{LatticeItem,ShopData})->
  ?LOG_ERROR({"unknow lattice type", {LatticeType,LatticeItem,ShopData}}),
  ?OK.

do_buy(LatticeItem,ShopData)->
  Type = role_shop_lattice_item:get_type(LatticeItem),
  {LatticeItem_1,ShopData_1} = priv_do_buy(Type,{LatticeItem,ShopData}),
  {LatticeItem_1,ShopData_1}.
priv_do_buy(?LatticeType_Fix,{LatticeItem,ShopData})->
  {LatticeItem_1,ShopData_1} = role_shop_lattice_fix:do_buy(LatticeItem,ShopData),
  {LatticeItem_1,ShopData_1};
priv_do_buy(LatticeType,{LatticeItem,ShopData})->
  ?LOG_ERROR({"unknow lattice type", {LatticeType,LatticeItem,ShopData}}),
  ?OK.

do_refresh(LatticeItem,ShopData)->
  Type = role_shop_lattice_item:get_type(LatticeItem),
  {LatticeItem_1,ShopData_1} = priv_do_refresh(Type,{LatticeItem,ShopData}),
  {LatticeItem_1,ShopData_1}.
priv_do_refresh(?LatticeType_Fix,{LatticeItem,ShopData})->
  {LatticeItem_1,ShopData_1} = role_shop_lattice_fix:do_refresh(LatticeItem,ShopData),
  {LatticeItem_1,ShopData_1};
priv_do_refresh(LatticeType,{LatticeItem,ShopData})->
  ?LOG_ERROR({"unknow lattice type", {LatticeType,LatticeItem,ShopData}}),
  ?OK.
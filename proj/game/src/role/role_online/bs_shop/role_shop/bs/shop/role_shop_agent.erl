%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_agent).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include("shop.hrl").


%% API functions defined
-export([init/3,tick/2,refresh_shop/2]).

-export([buy_shop_goods/3,refresh_lattice/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(?ShopType_Pub,ShopId,ShopCfgItem)->
  role_shop_pub_like_mgr:init(ShopId,ShopCfgItem),
  ?OK;
init(ShopType,ShopId,CfgId)->
  ?LOG_ERROR({"unknow shop type", {ShopType,ShopId}}),
  ?OK.

tick(?ShopType_Pub,ShopId)->
  role_shop_pub_like_mgr:tick(ShopId),
  ?OK;
tick(ShopType,ShopId)->
  ?LOG_ERROR({"unknow shop type", {ShopType,ShopId}}),
  ?OK.

refresh_shop(?ShopType_Pub,ShopId)->
  role_shop_pub_like_mgr:refresh_shop(ShopId),
  ?OK;
refresh_shop(ShopType,ShopId)->
  ?LOG_ERROR({"unknow shop type", {ShopType,ShopId}}),
  ?OK.

buy_shop_goods(?ShopType_Pub,ShopId,LatticeId)->
  role_shop_pub_like_mgr:buy_shop_goods(ShopId,LatticeId),
  ?OK;
buy_shop_goods(ShopType,ShopItem,LatticeId)->
  ?LOG_ERROR({"unknow shop type", {ShopType,ShopItem,LatticeId}}),
  ?OK.

refresh_lattice(?ShopType_Pub,ShopId,LatticeId)->
  role_shop_pub_like_mgr:refresh_lattice(ShopId,LatticeId),
  ?OK;
refresh_lattice(ShopType,ShopId,LatticeId)->
  ?LOG_ERROR({"unknow shop type", {ShopType,ShopId}}),
  ?OK.

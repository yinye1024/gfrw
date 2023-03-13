%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_pdb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/0]).
-export([put_shop_item/1]).
-export([get_shop_type/1,get_shop_item/1,get_all_shopList/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  RoleId = role_adm_mgr:get_roleId(),
  role_shop_pdb_holder:init(RoleId),
  ?OK.

get_shop_type(ShopId)->
  ShopItem = get_shop_item(ShopId),
  role_shop_item:get_type(ShopItem).

get_shop_item(ShopId)->
  Data = priv_get_data(),
  ShopItem = role_shop_pdb_pojo:get_item(ShopId,Data),
  ShopItem.

put_shop_item(ShopItem)->
  Data = priv_get_data(),
  Data_1 = role_shop_pdb_pojo:put_item(ShopItem,Data),
  priv_update_data(Data_1).

get_all_shopList()->
  Data = priv_get_data(),
  ItemMap = role_shop_pdb_pojo:get_item_map(Data),
  yyu_map:all_values(ItemMap).

priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_shop_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(MultiData)->
  NewMultiData = role_shop_pdb_pojo:incr_ver(MultiData),
  role_shop_pdb_holder:put_data(NewMultiData),
  ?OK.



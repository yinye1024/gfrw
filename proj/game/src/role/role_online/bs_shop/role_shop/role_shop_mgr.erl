%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_mgr).
-author("yinye").
-behavior(role_mgr_behaviour).

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([get_mod/0]).

-export([role_init/1,data_load/1,after_data_load/1,loop_5_seconds/2,clean_midnight/2,clean_week/2,on_login/1]).
-export([get_all_shop_info/0,get_shop_info/1,buy_shop_goods/2,refresh_shop/1,refresh_lattice/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->?MODULE.

%% 角色创建，或者角色进程初始化的时候执行
role_init(_RoleId)->
  ?OK.
%% 角色进程初始化的时候执行
data_load(_RoleId)->
  role_shop_pdb_mgr:proc_init(),
  ?OK.
%% 角色进程初始化，data_load 后执行
after_data_load(_RoleId)->
  priv_init(),
  ?OK.
%% 大约每隔5秒执行一次，具体执行情况要看是否有消息堆积
loop_5_seconds(_RoleId,_NowTime)->
  priv_tick(),
  ?OK.
%% 跨天执行,一般是一些清理业务
clean_midnight(_RoleId,_LastCleanTime)->
  ?OK.
%% 跨周执行,一般是一些清理业务
clean_week(_RoleId,_LastCleanTime)->
  ?OK.
%% 玩家登陆的时候执行
on_login(_RoleId)->
  ?OK.

priv_init()->
  ShopCfgIdList = role_shop_cfg_helper:get_shop_cfgId_list(),
  priv_init_shop(ShopCfgIdList),
  ?OK.
priv_init_shop([CfgId|Less])->
  ShopCfgItem = role_shop_cfg_item:new_from_cfg(CfgId),
  ShopId = role_shop_cfg_item:get_id(ShopCfgItem),
  ShopType = role_shop_cfg_item:get_type(ShopCfgItem),
  role_shop_agent:init(ShopType,ShopId,ShopCfgItem),
  priv_tick_shop(Less);
priv_init_shop([])->
  ?OK.

priv_tick()->
  ShopItemList = role_shop_pdb_mgr:get_all_shopList(),
  priv_tick_shop(ShopItemList),
  ?OK.
priv_tick_shop([ShopItem|Less])->
  ShopType = role_shop_item:get_type(ShopItem),
  ShopId = role_shop_item:get_id(ShopItem),
  role_shop_agent:tick(ShopType,ShopId),
  priv_tick_shop(Less);
priv_tick_shop([])->
  ?OK.

get_all_shop_info()->
  ShopItemList = role_shop_pdb_mgr:get_all_shopList(),
  shop_s2c_handler:send_all_shop_info(ShopItemList),
  ?OK.

get_shop_info(ShopId)->
  ShopItem = role_shop_pdb_mgr:get_shop_item(ShopId),
  shop_s2c_handler:send_all_shop_info([ShopItem]),
  ?OK.

buy_shop_goods(ShopId,LatticeId)->
  ShopType = role_shop_pdb_mgr:get_shop_type(ShopId),
  role_shop_agent:buy_shop_goods(ShopType,ShopId,LatticeId),
  ?OK.

refresh_shop(ShopId)->
  ShopType = role_shop_pdb_mgr:get_shop_type(ShopId),
  role_shop_agent:refresh_shop(ShopType,ShopId),
  ?OK.

refresh_lattice(ShopId,LatticeId)->
  ShopType = role_shop_pdb_mgr:get_shop_type(ShopId),
  role_shop_agent:refresh_lattice(ShopType,ShopId,LatticeId),
  ?OK.

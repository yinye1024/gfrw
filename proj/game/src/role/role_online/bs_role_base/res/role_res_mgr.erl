%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_res_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/0]).
-export([do_bag_exchange/1,use_bagItem/2,get_bag_itemList/0]).
-export([do_wallet_exchange/1,use_walletItem/2,get_wallet_itemList/0]).
-export([add_tmp_bag_item/2,get_and_rm_tmp_bag_item/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  role_bag_mgr:proc_init(),
  role_tmp_bag_mgr:proc_init(),
  role_wallet_mgr:proc_init(),
  ?OK.


use_bagItem(CfgId,Count)->
  ExItem = role_bag_ex_item:new_cost_item(CfgId,Count),
  IsExOk =  do_bag_exchange(ExItem),
  case IsExOk of
    ?TRUE -> role_bag_item_effect_agent:do_item_effect(ExItem),?OK;
    ?FALSE ->?OK
  end,
  IsExOk.
%% role_bag_ex_item
do_bag_exchange(ExItem)when is_map(ExItem)->
  IsExOk = role_bag_mgr:do_exchange(ExItem),
  IsExOk.

get_bag_itemList()->
  ItemList = role_bag_mgr:get_itemList(),
  ItemList.




use_walletItem(CfgId,Count)->
  ExItem = role_wallet_ex_item:new_cost_item(CfgId,Count),
  IsExOk =  do_wallet_exchange(ExItem),
  IsExOk.
%% role_wallet_ex_item
do_wallet_exchange(ExItem) when is_map(ExItem)->
  IsExOk = role_wallet_mgr:do_exchange(ExItem),
  IsExOk.
get_wallet_itemList()->
  ItemList = role_wallet_mgr:get_itemList(),
  ItemList.



add_tmp_bag_item(OnFailReturn,OnSuccessReturn)->
  ItemId = role_tmp_bag_mgr:new_item(OnFailReturn,OnSuccessReturn),
  ItemId.
get_and_rm_tmp_bag_item(ItemId)->
  TmpBagItem = role_tmp_bag_mgr:get_and_rm_item(ItemId),
  TmpBagItem.
%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_bag_item_sum).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/login_pb.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_from_item_list/2]).
-export([get_id/1, get_bind_itemId_list/1, get_bind_count/1, get_unbind_itemId_list/1, get_unbind_count/1]).
-export([get_total_count/1]).
-export([get_bind_item_list/2,get_unbind_item_list/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_from_item_list(CfgId,BagItemList)->
  {BindItemIdLIst,BindCount,UnBindItemIdLIst,UnBindCount} = priv_do_sum_itemList(BagItemList, {[],0,[],0}),
  #{
    id => CfgId,
    bind_itemId_list=>BindItemIdLIst,   %% 绑定状态 itemId 列表
    bind_count => BindCount,        %% 对应cfgId 绑定状态 计数

    unbind_itemId_list=>UnBindItemIdLIst,  %% 非绑定状态 itemId 列表
    unbind_count => UnBindCount      %% 对应cfgId 非绑定状态 计数
  }.
priv_do_sum_itemList([BagItem|Less], {AccBindItemIdList,AccBindCount,AccUnBindItemIdList,AccUnBindCount})->
  {AccBindItemIdList_1,AccBindCount_1,AccUnBindItemIdLIst_1,AccUnBindCount_1} =
  case role_bag_item:is_bind(BagItem) of
    ?TRUE ->
      AccBindItemIdListTmp = [role_bag_item:get_id(BagItem)|AccBindItemIdList],
      AccBindCountTmp = role_bag_item:get_count(BagItem)+AccBindCount,
      {AccBindItemIdListTmp, AccBindCountTmp,AccUnBindItemIdList,AccUnBindCount};
    ?FALSE ->
      AccUnBindItemIdListTmp = [role_bag_item:get_id(BagItem)|AccUnBindItemIdList],
      AccUnBindCountTmp = role_bag_item:get_count(BagItem)+AccUnBindCount,
      {AccBindItemIdList, AccBindCount,AccUnBindItemIdListTmp,AccUnBindCountTmp}
  end,
  priv_do_sum_itemList(Less,{AccBindItemIdList_1,AccBindCount_1,AccUnBindItemIdLIst_1,AccUnBindCount_1});
priv_do_sum_itemList([], {AccBindItemIdList,AccBindCount,AccUnBindItemIdList,AccUnBindCount})->
  {AccBindItemIdList,AccBindCount,AccUnBindItemIdList,AccUnBindCount}.


get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_bind_item_list(BagItemMap,SelfMap)->
  ItemIdList  = get_bind_itemId_list(SelfMap),
  yyu_map:get_value_list(ItemIdList,BagItemMap).
get_unbind_item_list(BagItemMap,SelfMap)->
  ItemIdList  = get_unbind_itemId_list(SelfMap),
  yyu_map:get_value_list(ItemIdList,BagItemMap).
get_total_count(SelfMap)->
  get_bind_count(SelfMap)+get_unbind_count(SelfMap).

get_bind_itemId_list(SelfMap) ->
  yyu_map:get_value(bind_itemId_list, SelfMap).

get_bind_count(SelfMap) ->
  yyu_map:get_value(bind_count, SelfMap).

get_unbind_itemId_list(SelfMap) ->
  yyu_map:get_value(unbind_itemId_list, SelfMap).

get_unbind_count(SelfMap) ->
  yyu_map:get_value(unbind_count, SelfMap).


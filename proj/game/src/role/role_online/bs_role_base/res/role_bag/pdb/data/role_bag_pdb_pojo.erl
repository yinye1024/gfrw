%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_bag_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/login_pb.hrl").


-define(Class, ?MODULE).
%% API functions defined
-export([new_pojo/1, is_class/1, has_id/1, get_id/1, get_ver/1, incr_ver/1]).
-export([add_goods/4]).
-export([is_goods_enough/3,rm_goods/3]).
-export([get_item_map/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId) ->
  #{
    '_id' => RoleId, ver => 0, class => ?MODULE,
    auto_itemId => 0,  %% item 自增id
    item_map => yyu_map:new_map(),        %% <ItemId,role_bag_item>
    sum_map => yyu_map:new_map()          %% <CfgId,role_bag_item_sum>
  }.

is_class(SelfMap) ->
  yyu_map:get_value(class, SelfMap) == ?Class.

has_id(SelfMap) ->
  get_id(SelfMap) =/= ?NOT_SET.

get_id(SelfMap) ->
  yyu_map:get_value('_id', SelfMap).

get_ver(SelfMap) ->
  yyu_map:get_value(ver, SelfMap).
incr_ver(SelfMap) ->
  CurVer = get_ver(SelfMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, SelfMap).

is_goods_enough(CfgId,Count,SelfMap)->
  ItemSum = priv_get_item_sum(CfgId,SelfMap),
  role_bag_item_sum:get_total_count(ItemSum) > Count.

rm_goods(CfgId,Count,SelfMap) ->
  ItemSum = priv_get_item_sum(CfgId,SelfMap),
  BagItemMap = get_item_map(SelfMap),
  %% 先扣绑定的
  BindItemList = role_bag_item_sum:get_bind_item_list(BagItemMap,ItemSum),
  {LeftCount_1, DecrItemList_1} = priv_decr_count(Count,BindItemList,[]),

  DecrItemList_2 =
  case LeftCount_1 > 0 of
    ?TRUE ->
      %% 再扣非绑的
      UnBindItemList = role_bag_item_sum:get_bind_item_list(BagItemMap,ItemSum),
      {LeftCount_2, AccItemListTmp} = priv_decr_count(Count,UnBindItemList, DecrItemList_1),
      %% 跑到这里不应该出现不够扣的情况，非0 直接抛错
      yyu_error:assert_true(LeftCount_2 ==0,"left count should be 0 but not."),
      AccItemListTmp;
    ?FALSE ->
      DecrItemList_1
  end,
  priv_update_item_list(DecrItemList_2,SelfMap).

priv_decr_count(Count,BagItemList,AccItemList)->
  {LeftCount_1,AccItemList_1} =
  case priv_get_min_count_item(BagItemList,{?NOT_SET,?NOT_SET}) of
    {?NOT_SET,?NOT_SET} -> {Count,AccItemList};
    {_CountTmp,BagItemTmp} ->
      {LeftDecrCountTmp, BagItemTmp_1} = role_bag_item:decr_count(Count,BagItemTmp),
      AccItemListTmp = [BagItemTmp_1 | AccItemList],
      case LeftDecrCountTmp > 0  of
        ?TRUE ->
          BagItemListTmp = yyu_list:remove(BagItemTmp,BagItemList),
          priv_decr_count(LeftDecrCountTmp,BagItemListTmp, AccItemListTmp);
        ?FALSE ->
          {0, AccItemListTmp}
      end
  end,
  {LeftCount_1,AccItemList_1}.

priv_get_min_count_item([BagItem|Less],{AccMin,AccBagItem})->
  Count = role_bag_item:get_count(BagItem),
  {AccMin_1,AccBagItem_1} =
  case Count =< 0 of
    ?TRUE ->
      {AccMin,AccBagItem};
    _Other ->
      case AccMin == ?NOT_SET orelse Count < AccMin of
        ?TRUE -> {Count,BagItem};
        ?FALSE ->{AccMin,AccBagItem}
      end
  end,
  priv_get_min_count_item(Less,{AccMin_1,AccBagItem_1});
priv_get_min_count_item([],{AccMin,AccBagItem})->
  {AccMin,AccBagItem}.

add_goods(CfgId,Count,{MaxCount,IsBind,IsCanAcc,ExpiredTime}, SelfMap) ->
  %% 如果有过期时间，BagItem的IsCanAcc 要设成 ?FALSE，不可叠加
  IsCanAcc_1 = ?IF(ExpiredTime > 0, ?FALSE,IsCanAcc),

  {LeftCount,BagItemList} =
  case priv_get_can_add_item_by_cfgId(priv_get_bagItem_list(SelfMap),CfgId,IsBind) of
    ?NOT_SET -> {Count,[]};
    BagItem ->
      {LeftCountTmp,BagItemTmp} =  role_bag_item:add_count(Count,MaxCount,BagItem),
      {LeftCountTmp,[BagItemTmp]}
  end,
  {BagItemList_1,SelfMap_1} = priv_split_count(LeftCount,{CfgId,MaxCount,IsBind,IsCanAcc_1,ExpiredTime},BagItemList,SelfMap),
  priv_update_item_list(BagItemList_1, SelfMap_1).

priv_get_can_add_item_by_cfgId([BagItem | Less], CfgId,IsBind) ->
    case role_bag_item:is_can_add(BagItem)
      andalso role_bag_item:get_cfgId(BagItem) == CfgId
      andalso role_bag_item:is_bind(BagItem) == IsBind of
      ?TRUE -> BagItem;
      _ ->   priv_get_can_add_item_by_cfgId(Less, CfgId,IsBind)
    end;
priv_get_can_add_item_by_cfgId([], _CfgId,_IsBind) ->
  ?NOT_SET.

priv_split_count(LeftCount,{CfgId,MaxCount,IsBind,IsCanAcc,ExpiredTime},AccBagItemList,AccSelfMap) when LeftCount =< MaxCount ->
  {ItemId,AccSelfMap_1} = incr_and_get_itemId(AccSelfMap),
  NewBagItem = role_bag_item:new_item(ItemId,CfgId,LeftCount,{IsBind, IsCanAcc,ExpiredTime}),
  {[NewBagItem|AccBagItemList],AccSelfMap_1};
priv_split_count(LeftCount,{CfgId,MaxCount,IsBind,IsCanAcc,ExpiredTime},AccBagItemList,AccSelfMap)->
  {ItemId,AccSelfMap_1} = incr_and_get_itemId(AccSelfMap),
  NewBagItem = role_bag_item:new_item(ItemId,CfgId,MaxCount,{IsBind, IsCanAcc,ExpiredTime}),
  priv_split_count(LeftCount-MaxCount,{CfgId,MaxCount,IsBind,IsCanAcc,ExpiredTime},[NewBagItem|AccBagItemList],AccSelfMap_1).

%% 放入 新的 BagItem，并对修改过的所有 cfgId 重新做统计
%% 1 count 是 0 的BatItem 会被移除
%% 2 对应cfgId的BagItem 列表为空的sum会被移除
priv_update_item_list(BagItemList, SelfMap) ->
  {CfgIdMap, SelfMap_1} = priv_update_item_list(BagItemList, yyu_map:new_map(), SelfMap),
  SelfMap_2 = priv_do_sum(yyu_map:all_keys(CfgIdMap), SelfMap_1),
  SelfMap_2.

%% 更新 item 并记录 哪些cfgId 被改动了
priv_update_item_list([BagItem | Less], AccCfgIdMap, AccSelfMap) ->
  AccSelfMap_1 =
    case role_bag_item:get_count(BagItem) > 0 of
      ?TRUE -> priv_put_item(BagItem, AccSelfMap);
      ?FALSE ->
        BagId = role_bag_item:get_id(BagItem),
        priv_rm_item(BagId, AccSelfMap)
    end,
  Map_1 = yyu_map:put_value(role_bag_item:get_cfgId(BagItem), 1, AccCfgIdMap),
  priv_update_item_list([BagItem | Less], Map_1, AccSelfMap_1);
priv_update_item_list([], AccCfgIdMap, AccSelfMap) ->
  {AccCfgIdMap, AccSelfMap}.

priv_put_item(BagItem, SelfMap) ->
  BagId = role_bag_item:get_id(BagItem),
  Map = get_item_map(SelfMap),
  Map_1 = yyu_map:put_value(BagId, BagItem, Map),
  priv_set_item_map(Map_1, SelfMap).

priv_rm_item(BagId, SelfMap) ->
  Map = get_item_map(SelfMap),
  Map_1 = yyu_map:remove(BagId, Map),
  priv_set_item_map(Map_1, SelfMap).

get_item_map(SelfMap) ->
  yyu_map:get_value(item_map, SelfMap).

priv_set_item_map(Value, SelfMap) ->
  yyu_map:put_value(item_map, Value, SelfMap).

priv_do_sum([CfgId | Less], AccSelfMap) ->
  AccSelfMap_1 = priv_sum_item_of_cfgId(CfgId, AccSelfMap),
  priv_do_sum(Less, AccSelfMap_1);
priv_do_sum([], AccSelfMap) ->
  AccSelfMap.

priv_sum_item_of_cfgId(CfgId, SelfMap) ->
  SelfMap_1 =
    case priv_get_itemList_by_cfgId(priv_get_bagItem_list(SelfMap), CfgId, []) of
      [] ->
        priv_rm_sum_item(CfgId, SelfMap);
      ItemList ->
        ItemSum = role_bag_item_sum:new_from_item_list(CfgId, ItemList),
        priv_put_sum_item(ItemSum, SelfMap)
    end,
  SelfMap_1.

priv_get_bagItem_list(SelfMap)->
  ItemMap = get_item_map(SelfMap),
  yyu_map:all_values(ItemMap).

priv_get_itemList_by_cfgId([BagItem | Less], CfgId, AccList) ->
  AccList_1 =
    case role_bag_item:get_cfgId(BagItem) of
      CfgId -> [BagItem | AccList];
      _ -> AccList
    end,
  priv_get_itemList_by_cfgId(Less, CfgId, AccList_1);
priv_get_itemList_by_cfgId([], _CfgId, AccList) ->
  AccList.


priv_put_sum_item(ItemSum, SelfMap) ->
  CfgId = role_bag_item_sum:get_id(ItemSum),
  SumMap = priv_get_sum_map(SelfMap),
  SumMap_1 = yyu_map:put_value(CfgId, ItemSum, SumMap),
  priv_set_sum_map(SumMap_1, SelfMap).
priv_rm_sum_item(CfgId, SelfMap) ->
  SumMap = priv_get_sum_map(SelfMap),
  SumMap_1 = yyu_map:remove(CfgId, SumMap),
  priv_set_sum_map(SumMap_1, SelfMap).

priv_get_item_sum(CfgId,SelfMap)->
  Map = priv_get_sum_map(SelfMap),
  yyu_map:get_value(CfgId,Map).

priv_get_sum_map(SelfMap) ->
  yyu_map:get_value(sum_map, SelfMap).

priv_set_sum_map(Value, SelfMap) ->
  yyu_map:put_value(sum_map, Value, SelfMap).

%% return {NextId,NewSelfMap}
incr_and_get_itemId(SelfMap) ->
  NextId = priv_get_auto_itemId(SelfMap) + 1,
  {NextId, priv_set_auto_itemId(NextId, SelfMap)}.

priv_get_auto_itemId(SelfMap) ->
  yyu_map:get_value(auto_itemId, SelfMap).

priv_set_auto_itemId(Value, SelfMap) ->
  yyu_map:put_value(auto_itemId, Value, SelfMap).


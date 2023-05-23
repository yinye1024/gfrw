%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_monitor_top_pc_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/1,get_id/1]).
-export([put_PidTopInfo/3, rm_topItem/2,is_in_data/2, get_item_map/1]).
-export([get_msg_queue_len_top_itemList/1,get_mem_top_itemList/1,get_reds_top_itemList/1,get_incr_reds_top_itemList/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(DataId)->
  #{
    id => DataId,
    item_map => yyu_map:new_map()   %% <Pid,lc_monitor_top_pc_item>
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

put_PidTopInfo(Pid,{MsgQueueLen,MemBytes,Reds,CurFun,CurStk},SelfMap)->
  ItemMap = priv_get_item_map(SelfMap),
  ItemMap_1 =
  case yyu_map:get_value(Pid,ItemMap) of
    ?NOT_SET ->
      GenSupMod = lc_monitor_top_helper:get_sup_mod(Pid),
      CanKilled = lc_monitor_top_cfg_helper:is_gen_can_be_killed(GenSupMod),

      [{initial_call,InitCall},{registered_name,RegName}] = recon:info(Pid,[initial_call,registered_name]),

      TopItemTmp = lc_monitor_top_pc_item:new_pojo(Pid,{CanKilled,RegName,InitCall}),
      TopItemTmp_1 = lc_monitor_top_pc_item:set_new_values({MsgQueueLen,MemBytes,Reds},{CurFun,CurStk},TopItemTmp),
      ItemMapTmp = yyu_map:put_value(Pid, TopItemTmp_1,ItemMap),
      ItemMapTmp;
    TopItemTmp ->
      TopItemTmp_1 = lc_monitor_top_pc_item:set_new_values({MsgQueueLen,MemBytes,Reds},{CurFun,CurStk},TopItemTmp),
      ItemMapTmp = yyu_map:put_value(Pid, TopItemTmp_1,ItemMap),
      ItemMapTmp
  end,
  SelfMap_1 = priv_set_item_map(ItemMap_1,SelfMap),
  SelfMap_1.


rm_topItem(Pid,SelfMap)->
  ItemMap = priv_get_item_map(SelfMap),
  ItemMap_1 = yyu_map:remove(Pid,ItemMap),
  priv_set_item_map(ItemMap_1,SelfMap).

is_in_data(Pid,SelfMap)->
  ItemMap = priv_get_item_map(SelfMap),
  yyu_map:has_key(Pid,ItemMap).

get_item_map(SelfMap)->
  ItemMap = priv_get_item_map(SelfMap),
  ItemMap.

priv_get_item_map(SelfMap) ->
  yyu_map:get_value(item_map, SelfMap).

priv_set_item_map(Value, SelfMap) ->
  yyu_map:put_value(item_map, Value, SelfMap).

get_msg_queue_len_top_itemList(SelfMap)->
  ItemMap = priv_get_item_map(SelfMap),
  Val_ItemList = yyu_list:map(fun(TopItemTmp) -> {lc_monitor_top_pc_item:get_message_queue_len(TopItemTmp),TopItemTmp} end, yyu_map:all_values(ItemMap)),
  TopSize = 10,
  TopItemList = lc_monitor_top_helper:find_all_top_list(TopSize,Val_ItemList),
  TopItemList.
get_mem_top_itemList(SelfMap)->
  ItemMap = priv_get_item_map(SelfMap),
  Val_ItemList = yyu_list:map(fun(TopItemTmp) -> {lc_monitor_top_pc_item:get_memory(TopItemTmp),TopItemTmp} end, yyu_map:all_values(ItemMap)),
  TopSize = 10,
  TopItemList = lc_monitor_top_helper:find_all_top_list(TopSize,Val_ItemList),
  TopItemList.
get_reds_top_itemList(SelfMap)->
  ItemMap = priv_get_item_map(SelfMap),
  Val_ItemList = yyu_list:map(fun(TopItemTmp) -> {lc_monitor_top_pc_item:get_reductions(TopItemTmp),TopItemTmp} end, yyu_map:all_values(ItemMap)),
  TopSize = 10,
  TopItemList = lc_monitor_top_helper:find_all_top_list(TopSize,Val_ItemList),
  TopItemList.
get_incr_reds_top_itemList(SelfMap)->
  ItemMap = priv_get_item_map(SelfMap),
  Val_ItemList = yyu_list:map(fun(TopItemTmp) -> {lc_monitor_top_pc_item:get_incr_reductions(TopItemTmp),TopItemTmp} end, yyu_map:all_values(ItemMap)),
  TopSize = 10,
  TopItemList = lc_monitor_top_helper:find_all_top_list(TopSize,Val_ItemList),
  TopItemList.

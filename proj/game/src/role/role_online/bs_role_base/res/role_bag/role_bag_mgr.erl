%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%    存放玩家在在游戏中获取的物件
%%    1 物品添加字段指定绑定和非绑两种通用状态，相互不能叠加，消费会指定先消费绑定状态的物品，再消费非绑的物品。
%%    2 物品添加字段指定在一个格子里可叠加的最大数量是多少，超过可叠加数量要拆成几个格子，消费物品的时候按叠加数从小到大消费。
%%    3 物品添加字段指定是否可以叠加，不可叠加的物品可以在获得的同时设定数量，该格子的物品只能消耗不能叠加，不同格子的该相同物品也不能相互叠加。
%%    4 物品添加的时候可设置过期时间，有过期时间的物品会同时设置成不可叠加的。
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_bag_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/0]).

-export([do_exchange/1]).
-export([get_itemList/0,get_item/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  RoleId = role_adm_mgr:get_roleId(),
  role_bag_pdb_holder:init(RoleId),
  ?OK.

do_exchange(ExItem)->
  Data = priv_get_data(),
  ?LOG_INFO({"do_exchange_111",Data}),
  {IsCostOk,Data_1}=
  case role_bag_ex_item:get_cost_kv_list(ExItem) of
    []->{?TRUE,Data};
    CostKvList ->
      case priv_is_goods_enough(CostKvList,Data) of
        ?TRUE ->
          DataTmp = priv_do_cost(CostKvList,Data),
          {?TRUE,DataTmp};
        ?FALSE ->
          {?FALSE,Data}
      end
  end,
  ?LOG_INFO({"do_exchange_112",{IsCostOk,Data_1}}),
  IsExOk =
  case IsCostOk of
    ?TRUE ->
      EXKvList = role_bag_ex_item:get_add_kv_list(ExItem),
      ?LOG_INFO({"do_exchange_113",EXKvList}),
      Data_2 = priv_do_add(EXKvList,Data_1),
      ?LOG_INFO({"do_exchange_114",Data_2}),
      priv_update_data(Data_2),
      ?TRUE;
    ?FALSE ->
      ?FALSE
  end,

  IsExOk.

priv_is_goods_enough([{CfgId,Count}|Less],Data)->
  case role_bag_pdb_pojo:is_goods_enough(CfgId,Count,Data) of
    ?FALSE ->?FALSE;
    ?TRUE -> priv_is_goods_enough(Less,Data)
  end;
priv_is_goods_enough([],_Data)->
  ?TRUE.

priv_do_cost([{CfgId,Count}|Less],Data)->
  Data_1 = role_bag_pdb_pojo:rm_goods(CfgId,Count,Data),
  priv_do_cost(Less,Data_1);
priv_do_cost([],Data)->
  Data.
priv_do_add([{CfgId,Count,{MaxCount,IsBind,IsCanAcc,ExpiredTime}}|Less],Data)->
  ?LOG_INFO({"dddddtttt 1"}),
  Data_1 = role_bag_pdb_pojo:add_goods(CfgId,Count,{MaxCount,IsBind,IsCanAcc,ExpiredTime},Data),
  priv_do_add(Less,Data_1);
priv_do_add([],Data)->
  ?LOG_INFO({"dddddtttt 2"}),
  Data.

get_itemList()->
  Data = priv_get_data(),
  ItemMap = role_bag_pdb_pojo:get_item_map(Data),
  yyu_map:all_values(ItemMap).

get_item(ItemId)->
  Data = priv_get_data(),
  role_bag_pdb_pojo:get_item(ItemId,Data).

priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_bag_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(BagData)->
  ?LOG_INFO({"new role bag data",BagData}),
  BagData_1 = role_bag_pdb_pojo:incr_ver(BagData),
  role_bag_pdb_holder:put_data(BagData_1),
  ?OK.



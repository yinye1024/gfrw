%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%    存放玩家的各种货币
%%    1 每个item 一种货币，货币可叠加，上限是 int64。
%%    2 每种货币分绑定和非绑两种，消费的时候先消费绑定货币，再消费非绑货币。
%%    3 货币没有过期时间
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_wallet_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/0]).

-export([do_exchange/1]).
-export([get_itemList/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  RoleId = role_adm_mgr:get_roleId(),
  role_wallet_pdb_holder:init(RoleId),
  ?OK.

do_exchange(ExItem)->
  Data = priv_get_data(),
  {IsCostOk,Data_1}=
  case role_wallet_ex_item:get_cost_kv_list(ExItem) of
    []->{?TRUE,Data};
    CostKvList ->
      case priv_is_goods_enough(CostKvList,Data) of
        ?TRUE ->
          ?LOG_INFO({"do_exchange111111",CostKvList,Data}),
          DataTmp = priv_do_cost(CostKvList,Data),
          {?TRUE,DataTmp};
        ?FALSE ->
          ?LOG_INFO({"do_exchange111122",Data}),
          {?FALSE,Data}
      end
  end,
  IsExOk =
  case IsCostOk of
    ?TRUE ->
      ?LOG_INFO({"do_exchange1111333",Data_1}),
      AddKvList = role_wallet_ex_item:get_add_kv_list(ExItem),
      Data_2 = priv_do_add(AddKvList,Data_1),
      ?LOG_INFO({"do_exchange1111444",Data_2}),
      priv_update_data(Data_2),
      ?TRUE;
    ?FALSE ->
      ?FALSE
  end,
  IsExOk.

priv_is_goods_enough([{CfgId,Count}|Less],Data)->
  case role_wallet_pdb_pojo:is_goods_enough(CfgId,Count,Data) of
    ?FALSE ->?FALSE;
    ?TRUE -> priv_is_goods_enough(Less,Data)
  end;
priv_is_goods_enough([],_Data)->
  ?TRUE.

priv_do_cost([{CfgId,Count}|Less],Data)->
  Data_1 = role_wallet_pdb_pojo:rm_goods(CfgId,Count,Data),
  priv_do_cost(Less,Data_1);
priv_do_cost([],Data)->
  Data.
priv_do_add([{CfgId,Count,IsBind}|Less],Data)->
  Data_1 = role_wallet_pdb_pojo:add_goods(CfgId,Count,IsBind,Data),
  priv_do_add(Less,Data_1);
priv_do_add([],Data)->
  Data.

get_itemList()->
  Data = priv_get_data(),
  SelfMap = role_wallet_pdb_pojo:get_item_map(Data),
  yyu_map:all_values(SelfMap).

priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_wallet_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(MultiData)->
  NewMultiData = role_wallet_pdb_pojo:incr_ver(MultiData),
  role_wallet_pdb_holder:put_data(NewMultiData),
  ?OK.

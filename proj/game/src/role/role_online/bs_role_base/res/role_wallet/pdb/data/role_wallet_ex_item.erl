%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_wallet_ex_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


-export([new_add_item/3,new_cost_item/2,new_item/2]).
-export([get_cost_kv_list/1, get_add_kv_list/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_add_item(CfgId,Count,IsBind)->
  new_item([],[{CfgId,Count,IsBind}]).

new_cost_item(CfgId,Count)->
  new_item([{CfgId,Count}],[]).

new_item(CostKvList,AddKvList)->
  #{
    cost_kv_list => CostKvList,   %% 消耗物品列表 [{CfgId,Count}...]
    add_kv_list => AddKvList      %% 添加物品列表 [{CfgId,Count}...]
  }.

get_cost_kv_list(SelfMap) ->
  yyu_map:get_value(cost_kv_list, SelfMap).

get_add_kv_list(SelfMap) ->
  yyu_map:get_value(add_kv_list, SelfMap).


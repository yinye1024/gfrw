%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_good_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_item/3]).
-export([get_id/1,get_cfgId/1,is_can_buy/1, add_buy_count/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_item(ItemId,CfgId,MaxBuyCount)->
  #{
    id => ItemId,
    cfgId => CfgId,
    buy_count => 0,                %% 已购买次数
    max_buy_count => MaxBuyCount   %% 最大可购买次数
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_cfgId(ItemMap) ->
  yyu_map:get_value(cfgId, ItemMap).

is_can_buy(ItemMap)->
  priv_get_buy_count(ItemMap) < priv_get_max_buy_count(ItemMap).

add_buy_count(ItemMap)->
  BuyCount =   priv_get_buy_count(ItemMap) + 1,
  priv_set_buy_count(BuyCount, ItemMap).

priv_get_buy_count(ItemMap) ->
  yyu_map:get_value(buy_count, ItemMap).

priv_set_buy_count(Value, ItemMap) ->
  yyu_map:put_value(buy_count, Value, ItemMap).

priv_get_max_buy_count(ItemMap) ->
  yyu_map:get_value(max_buy_count, ItemMap).



%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_pay_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(PayStatus_New,0).
-define(PayStatus_Finish,1).


-export([new_item/3]).
-export([get_index/1,set_index/2]).
-export([
  get_order_id/1,
  get_game_id/1,
  get_svr_id/1,
  get_pm_id/1,
  get_role_id/1,
  get_pay_way/1,
  get_amount/1,
  get_product_id/1,
  get_pay_time/1,
  get_status/1,set_status/2,set_pay_done/1
]).

new_item(OrderId, {GameId,SvrId,PlatformId,RoleId},{PayWay,Amount,ProductId,PayTime})->
  #{
    index => 0,
    order_id => OrderId,
    game_id=>GameId,   %% 游戏id
    svr_id=>SvrId,     %% 服Id
    pm_id=>PlatformId, %% 平台Id
    role_id=>RoleId,   %% 玩家Id

    pay_way => PayWay, %% 支付渠道
    amount => Amount,  %% 支付总数
    product_id => ProductId, %%产品id
    pay_time => PayTime, %% 支付时间

    status => ?PayStatus_New
  }.


get_index(ItemMap) ->
  yyu_map:get_value(index, ItemMap).

set_index(Value, ItemMap) ->
  yyu_map:put_value(index, Value, ItemMap).

get_order_id(ItemMap) ->
  yyu_map:get_value(order_id, ItemMap).

get_game_id(ItemMap) ->
  yyu_map:get_value(game_id, ItemMap).

get_svr_id(ItemMap) ->
  yyu_map:get_value(svr_id, ItemMap).

get_pm_id(ItemMap) ->
  yyu_map:get_value(pm_id, ItemMap).

get_role_id(ItemMap) ->
  yyu_map:get_value(role_id, ItemMap).

get_pay_way(ItemMap) ->
  yyu_map:get_value(pay_way, ItemMap).

get_amount(ItemMap) ->
  yyu_map:get_value(amount, ItemMap).

get_product_id(ItemMap) ->
  yyu_map:get_value(product_id, ItemMap).

get_pay_time(ItemMap) ->
  yyu_map:get_value(pay_time, ItemMap).

get_status(ItemMap) ->
  yyu_map:get_value(status, ItemMap).


set_pay_done(ItemMap)->
  set_status(?PayStatus_Finish, ItemMap).
set_status(Value, ItemMap) ->
  yyu_map:put_value(status, Value, ItemMap).




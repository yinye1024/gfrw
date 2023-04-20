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


get_index(SelfMap) ->
  yyu_map:get_value(index, SelfMap).

set_index(Value, SelfMap) ->
  yyu_map:put_value(index, Value, SelfMap).

get_order_id(SelfMap) ->
  yyu_map:get_value(order_id, SelfMap).

get_game_id(SelfMap) ->
  yyu_map:get_value(game_id, SelfMap).

get_svr_id(SelfMap) ->
  yyu_map:get_value(svr_id, SelfMap).

get_pm_id(SelfMap) ->
  yyu_map:get_value(pm_id, SelfMap).

get_role_id(SelfMap) ->
  yyu_map:get_value(role_id, SelfMap).

get_pay_way(SelfMap) ->
  yyu_map:get_value(pay_way, SelfMap).

get_amount(SelfMap) ->
  yyu_map:get_value(amount, SelfMap).

get_product_id(SelfMap) ->
  yyu_map:get_value(product_id, SelfMap).

get_pay_time(SelfMap) ->
  yyu_map:get_value(pay_time, SelfMap).

get_status(SelfMap) ->
  yyu_map:get_value(status, SelfMap).


set_pay_done(SelfMap)->
  set_status(?PayStatus_Finish, SelfMap).
set_status(Value, SelfMap) ->
  yyu_map:put_value(status, Value, SelfMap).




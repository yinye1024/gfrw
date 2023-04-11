%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_pay_plrudb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/1,update_to_db/0,check_lru/0]).
-export([add_pay/1,remove_by_index/1,get_all_pay/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(_GenId)->
  lc_pay_plrudb_holder:proc_init(),
  ?OK.
update_to_db()->
  lc_pay_plrudb_holder:update_to_db(),
  ?OK.
check_lru()->
  lc_pay_plrudb_holder:do_lru(),
  ?OK.


add_pay({RoleId,PayItem})->
  PayPojo = priv_get_data(RoleId),
  NewPay = lc_pay_pojo:add_pay(PayItem,PayPojo),
  priv_update_pay(NewPay),
  ?OK.

remove_by_index({RoleId,PayIndex})->
  PayPojo = priv_get_data(RoleId),
  NewPayPojo = lc_pay_pojo:remove_by_index(PayIndex,PayPojo),
  priv_update_pay(NewPayPojo),
  ?OK.

get_all_pay({RoleId,LocalCbPojo})->
  PayPojo = priv_get_data(RoleId),
  yyu_local_callback_pojo:do_callback(PayPojo,LocalCbPojo),
  ?OK.

priv_get_data(RoleId)->
  Data =
  case lc_pay_plrudb_holder:get_data(RoleId) of
    ?NOT_SET ->
      PayPojo = lc_pay_pojo:new_pojo(RoleId),
      priv_update_pay(PayPojo),
      PayPojo;
    DataTmp->DataTmp
  end,
  Data.

priv_update_pay(PayPojo)->
  NewPayPojo = lc_pay_pojo:incr_ver(PayPojo),
  lc_pay_plrudb_holder:put_data(NewPayPojo),
  ?OK.


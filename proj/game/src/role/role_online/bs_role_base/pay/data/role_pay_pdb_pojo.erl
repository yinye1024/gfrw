%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_pay_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/1,is_class/1,has_id/1,get_id/1,get_ver/1,incr_ver/1]).
-export([get_last_index/1,set_last_index/2]).
-export([get_pay/2, update_pay/2,put_payList/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,
    last_index => 0,     %% 最后处理的 index，> index 的pay认为是新的，需要处理的
    pay_map => yyu_map:new_map()  %%{index,lc_pay_item}
  }.

is_class(SelfMap)->
  yyu_map:get_value(class,SelfMap) == ?Class.

has_id(SelfMap)->
  get_id(SelfMap) =/= ?NOT_SET.

get_id(SelfMap) ->
  yyu_map:get_value('_id', SelfMap).

get_ver(SelfMap) ->
  yyu_map:get_value(ver, SelfMap).
incr_ver(SelfMap) ->
  NewVer = get_ver(SelfMap)+1,
  yyu_map:put_value(ver, NewVer, SelfMap).


get_last_index(SelfMap) ->
  yyu_map:get_value(last_index, SelfMap).

set_last_index(Value, SelfMap) ->
  yyu_map:put_value(last_index, Value, SelfMap).

get_pay(PayIndex,SelfMap)->
  PayMap = priv_get_pay_map(SelfMap),
  yyu_map:get_value(PayIndex,PayMap).

update_pay(PayItem,SelfMap)->
  PayMap = priv_get_pay_map(SelfMap),
  PayId = lc_pay_item:get_index(PayItem),
  PayMap_1 = yyu_map:put_value(PayId,PayItem,PayMap),
  priv_set_pay_map(PayMap_1,SelfMap).

put_payList(LcPayItemList,SelfMap)->
  PayMap = priv_get_pay_map(SelfMap),
  PayMap_1 = priv_put_payList(LcPayItemList,PayMap),
  priv_set_pay_map(PayMap_1,SelfMap).

priv_put_payList([LcPayItem|Less],AccPayMap)->
  AccPayMap_1 = yyu_map:put_value(lc_pay_item:get_index(LcPayItem),LcPayItem,AccPayMap),
  priv_put_payList(Less,AccPayMap_1);
priv_put_payList([],AccPayMap)->
  AccPayMap.


priv_get_pay_map(SelfMap) ->
  yyu_map:get_value(pay_map, SelfMap).

priv_set_pay_map(Value, SelfMap) ->
  yyu_map:put_value(pay_map, Value, SelfMap).


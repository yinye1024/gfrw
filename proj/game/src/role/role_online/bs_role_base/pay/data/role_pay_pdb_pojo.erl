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

is_class(ItemMap)->
  yyu_map:get_value(class,ItemMap) == ?Class.

has_id(ItemMap)->
  get_id(ItemMap) =/= ?NOT_SET.

get_id(ItemMap) ->
  yyu_map:get_value('_id', ItemMap).

get_ver(ItemMap) ->
  yyu_map:get_value(ver, ItemMap).
incr_ver(ItemMap) ->
  NewVer = get_ver(ItemMap)+1,
  yyu_map:put_value(ver, NewVer, ItemMap).


get_last_index(ItemMap) ->
  yyu_map:get_value(last_index, ItemMap).

set_last_index(Value, ItemMap) ->
  yyu_map:put_value(last_index, Value, ItemMap).

get_pay(PayIndex,ItemMap)->
  PayMap = priv_get_pay_map(ItemMap),
  yyu_map:get_value(PayIndex,PayMap).

update_pay(PayItem,ItemMap)->
  PayMap = priv_get_pay_map(ItemMap),
  PayId = lc_pay_item:get_index(PayItem),
  PayMap_1 = yyu_map:put_value(PayId,PayItem,PayMap),
  priv_set_pay_map(PayMap_1,ItemMap).

put_payList(LcPayItemList,ItemMap)->
  PayMap = priv_get_pay_map(ItemMap),
  PayMap_1 = priv_put_payList(LcPayItemList,PayMap),
  priv_set_pay_map(PayMap_1,ItemMap).

priv_put_payList([LcPayItem|Less],AccPayMap)->
  AccPayMap_1 = yyu_map:put_value(lc_pay_item:get_index(LcPayItem),LcPayItem,AccPayMap),
  priv_put_payList(Less,AccPayMap_1);
priv_put_payList([],AccPayMap)->
  AccPayMap.


priv_get_pay_map(ItemMap) ->
  yyu_map:get_value(pay_map, ItemMap).

priv_set_pay_map(Value, ItemMap) ->
  yyu_map:put_value(pay_map, Value, ItemMap).


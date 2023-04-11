%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_pay_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/1,is_class/1,has_id/1,get_id/1,get_ver/1,incr_ver/1]).
-export([add_pay/2,remove_by_index/2,get_pay_list/1,get_pay_index/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,
    pay_index => 0,
    pay_list => []
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
  CurVer = get_ver(ItemMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, ItemMap).

add_pay(PayItem,ItemMap) ->
  {NextIndex,ItemMap_1} = priv_incr_and_get_nextId(ItemMap),
  PayItem_1 = lc_pay_item:set_index(NextIndex, PayItem),
  ItemMap_2 = priv_add_pay_item(PayItem_1,ItemMap_1),
  ItemMap_2.

get_pay_list(ItemMap) ->
  List = priv_get_pay_list(ItemMap),
  yyu_list:reverse(List).

remove_by_index(Index,ItemMap) ->
  Pred = fun(Item) -> lc_pay_item:get_index(Item) > Index end,
  List = priv_get_pay_list(ItemMap),
  List_1 = yyu_list:filter(Pred,List),
  priv_set_pay_list(List_1,ItemMap).

priv_incr_and_get_nextId(ItemMap)->
  NextIndex = get_pay_index(ItemMap)+1,
  ItemMap_1 = priv_set_pay_index(NextIndex,ItemMap),
  {NextIndex,ItemMap_1}.
get_pay_index(ItemMap) ->
  yyu_map:get_value(pay_index, ItemMap).
priv_set_pay_index(Value, ItemMap) ->
  yyu_map:put_value(pay_index, Value, ItemMap).

priv_add_pay_item(PayItem,ItemMap)->
  List = priv_get_pay_list(ItemMap),
  priv_set_pay_list([PayItem|List],ItemMap).
priv_get_pay_list(ItemMap) ->
  yyu_map:get_value(pay_list, ItemMap).
priv_set_pay_list(Value, ItemMap) ->
  yyu_map:put_value(pay_list, Value, ItemMap).




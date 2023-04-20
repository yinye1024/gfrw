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

is_class(SelfMap)->
  yyu_map:get_value(class,SelfMap) == ?Class.
has_id(SelfMap)->
  get_id(SelfMap) =/= ?NOT_SET.
get_id(SelfMap) ->
  yyu_map:get_value('_id', SelfMap).

get_ver(SelfMap) ->
  yyu_map:get_value(ver, SelfMap).
incr_ver(SelfMap) ->
  CurVer = get_ver(SelfMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, SelfMap).

add_pay(PayItem,SelfMap) ->
  {NextIndex,SelfMap_1} = priv_incr_and_get_nextId(SelfMap),
  PayItem_1 = lc_pay_item:set_index(NextIndex, PayItem),
  SelfMap_2 = priv_add_pay_item(PayItem_1,SelfMap_1),
  SelfMap_2.

get_pay_list(SelfMap) ->
  List = priv_get_pay_list(SelfMap),
  yyu_list:reverse(List).

remove_by_index(Index,SelfMap) ->
  Pred = fun(Item) -> lc_pay_item:get_index(Item) > Index end,
  List = priv_get_pay_list(SelfMap),
  List_1 = yyu_list:filter(Pred,List),
  priv_set_pay_list(List_1,SelfMap).

priv_incr_and_get_nextId(SelfMap)->
  NextIndex = get_pay_index(SelfMap)+1,
  SelfMap_1 = priv_set_pay_index(NextIndex,SelfMap),
  {NextIndex,SelfMap_1}.
get_pay_index(SelfMap) ->
  yyu_map:get_value(pay_index, SelfMap).
priv_set_pay_index(Value, SelfMap) ->
  yyu_map:put_value(pay_index, Value, SelfMap).

priv_add_pay_item(PayItem,SelfMap)->
  List = priv_get_pay_list(SelfMap),
  priv_set_pay_list([PayItem|List],SelfMap).
priv_get_pay_list(SelfMap) ->
  yyu_map:get_value(pay_list, SelfMap).
priv_set_pay_list(Value, SelfMap) ->
  yyu_map:put_value(pay_list, Value, SelfMap).




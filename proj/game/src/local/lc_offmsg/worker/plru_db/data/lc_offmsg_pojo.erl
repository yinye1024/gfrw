%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_offmsg_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/1,get_id/1,get_ver/1,incr_ver/1]).
-export([add_msg/2,remove_by_index/2,get_msg_list/1,get_msg_index/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(Id)->
  #{
    '_id' => Id,
    ver=>0,
    msg_index => 0,
    msg_list => []
  }.

get_id(ItemMap) ->
  yyu_map:get_value('_id', ItemMap).

get_ver(ItemMap) ->
  yyu_map:get_value(ver, ItemMap).
incr_ver(ItemMap) ->
  CurVer = get_ver(ItemMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, ItemMap).

add_msg(Msg,ItemMap) ->
  {NextIndex,ItemMap_1} = priv_incr_and_get_nextId(ItemMap),
  MsgItem = lc_offmsg_item:new_pojo(NextIndex,Msg),
  ItemMap_2 = priv_add_msg_item(MsgItem,ItemMap_1),
  ItemMap_2.

get_msg_list(ItemMap) ->
  List = priv_get_msg_list(ItemMap),
  yyu_list:reverse(List).

remove_by_index(Index,ItemMap) ->
  Pred = fun(Item) -> lc_offmsg_item:get_index(Item) > Index end,
  List = priv_get_msg_list(ItemMap),
  List_1 = yyu_list:filter(Pred,List),
  priv_set_msg_list(List_1,ItemMap).

priv_incr_and_get_nextId(ItemMap)->
  NextIndex = get_msg_index(ItemMap)+1,
  ItemMap_1 = priv_set_msg_index(NextIndex,ItemMap),
  {NextIndex,ItemMap_1}.
get_msg_index(ItemMap) ->
  yyu_map:get_value(msg_index, ItemMap).
priv_set_msg_index(Value, ItemMap) ->
  yyu_map:put_value(msg_index, Value, ItemMap).

priv_add_msg_item(MsgItem,ItemMap)->
  List = priv_get_msg_list(ItemMap),
  priv_set_msg_list([MsgItem|List],ItemMap).
priv_get_msg_list(ItemMap) ->
  yyu_map:get_value(msg_list, ItemMap).
priv_set_msg_list(Value, ItemMap) ->
  yyu_map:put_value(msg_list, Value, ItemMap).




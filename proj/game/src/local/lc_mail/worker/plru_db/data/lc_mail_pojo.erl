%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/1,is_class/1,has_id/1,get_id/1,get_ver/1,incr_ver/1]).
-export([add_mail/2,remove_by_index/2,get_mail_list/1,get_mail_index/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,
    mail_index => 0,
    mail_list => []
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

add_mail(Mail,ItemMap) ->
  {NextIndex,ItemMap_1} = priv_incr_and_get_nextId(ItemMap),
  MailItem = lc_mail_item:new_pojo(NextIndex,Mail),
  ItemMap_2 = priv_add_mail_item(MailItem,ItemMap_1),
  ItemMap_2.

get_mail_list(ItemMap) ->
  List = priv_get_mail_list(ItemMap),
  yyu_list:reverse(List).

remove_by_index(Index,ItemMap) ->
  Pred = fun(Item) -> lc_mail_item:get_index(Item) > Index end,
  List = priv_get_mail_list(ItemMap),
  List_1 = yyu_list:filter(Pred,List),
  priv_set_mail_list(List_1,ItemMap).

priv_incr_and_get_nextId(ItemMap)->
  NextIndex = get_mail_index(ItemMap)+1,
  ItemMap_1 = priv_set_mail_index(NextIndex,ItemMap),
  {NextIndex,ItemMap_1}.
get_mail_index(ItemMap) ->
  yyu_map:get_value(mail_index, ItemMap).
priv_set_mail_index(Value, ItemMap) ->
  yyu_map:put_value(mail_index, Value, ItemMap).

priv_add_mail_item(MailItem,ItemMap)->
  List = priv_get_mail_list(ItemMap),
  priv_set_mail_list([MailItem|List],ItemMap).
priv_get_mail_list(ItemMap) ->
  yyu_map:get_value(mail_list, ItemMap).
priv_set_mail_list(Value, ItemMap) ->
  yyu_map:put_value(mail_list, Value, ItemMap).




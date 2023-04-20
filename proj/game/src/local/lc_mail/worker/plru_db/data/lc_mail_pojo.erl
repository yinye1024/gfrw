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
-export([add_mailList/2,add_mail/2,remove_by_index/2,get_mail_list/1,get_mail_index/1]).
-export([get_to_all_mail_index/1,set_to_all_mail_index/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,

    to_all_mail_index =>0,  %% 已同步的 全服邮件index

    mail_index => 0,
    mail_list => []
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

add_mailList([Mail|Less],SelfMap)->
  SelfMap_1 = add_mail(Mail,SelfMap),
  add_mailList(Less,SelfMap_1);
add_mailList([],SelfMap)->
  SelfMap.

add_mail(Mail,SelfMap) ->
  {NextIndex,SelfMap_1} = priv_incr_and_get_nextId(SelfMap),
  MailItem = lc_mail_item:new_pojo(NextIndex,Mail),
  SelfMap_2 = priv_add_mail_item(MailItem,SelfMap_1),
  SelfMap_2.

get_mail_list(SelfMap) ->
  List = priv_get_mail_list(SelfMap),
  yyu_list:reverse(List).

remove_by_index(Index,SelfMap) ->
  Pred = fun(Item) -> lc_mail_item:get_index(Item) > Index end,
  List = priv_get_mail_list(SelfMap),
  List_1 = yyu_list:filter(Pred,List),
  priv_set_mail_list(List_1,SelfMap).

priv_incr_and_get_nextId(SelfMap)->
  NextIndex = get_mail_index(SelfMap)+1,
  SelfMap_1 = priv_set_mail_index(NextIndex,SelfMap),
  {NextIndex,SelfMap_1}.
get_mail_index(SelfMap) ->
  yyu_map:get_value(mail_index, SelfMap).
priv_set_mail_index(Value, SelfMap) ->
  yyu_map:put_value(mail_index, Value, SelfMap).

priv_add_mail_item(MailItem,SelfMap)->
  List = priv_get_mail_list(SelfMap),
  priv_set_mail_list([MailItem|List],SelfMap).
priv_get_mail_list(SelfMap) ->
  yyu_map:get_value(mail_list, SelfMap).
priv_set_mail_list(Value, SelfMap) ->
  yyu_map:put_value(mail_list, Value, SelfMap).



get_to_all_mail_index(SelfMap) ->
  yyu_map:get_value(to_all_mail_index, SelfMap).

set_to_all_mail_index(Value, SelfMap) ->
  yyu_map:put_value(to_all_mail_index, Value, SelfMap).



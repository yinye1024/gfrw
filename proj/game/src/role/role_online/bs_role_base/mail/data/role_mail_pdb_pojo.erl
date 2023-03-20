%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_mail_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/1,is_class/1,has_id/1,get_id/1,get_ver/1,incr_ver/1]).
-export([get_last_index/1,set_last_index/2]).
-export([get_mail/2, update_mail/2,put_mailList/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,
    last_index => 0,     %% 最后处理的 index，> index 的mail认为是新的，需要处理的
    mail_map => yyu_map:new_map()  %%{MailId,role_mail_item}
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

get_mail(MailIndex,ItemMap)->
  MailMap = priv_get_mail_map(ItemMap),
  yyu_map:get_value(MailIndex,MailMap).

update_mail(MailItem,ItemMap)->
  MailMap = priv_get_mail_map(ItemMap),
  MailId = role_mail_item:get_id(MailItem),
  MailMap_1 = yyu_map:put_value(MailId,MailItem,MailMap),
  priv_set_mail_map(MailMap_1,ItemMap).

put_mailList(LcMailItemList,ItemMap)->
  MailMap = priv_get_mail_map(ItemMap),
  MailMap_1 = priv_put_mailList(LcMailItemList,MailMap),
  priv_set_mail_map(MailMap_1,ItemMap).

priv_put_mailList([LcMailItem|Less],AccMailMap)->
  AccMailMap_1 = yyu_map:put_value(role_mail_item:get_id(LcMailItem),LcMailItem,AccMailMap),
  priv_put_mailList(Less,AccMailMap_1);
priv_put_mailList([],AccMailMap)->
  AccMailMap.


priv_get_mail_map(ItemMap) ->
  yyu_map:get_value(mail_map, ItemMap).

priv_set_mail_map(Value, ItemMap) ->
  yyu_map:put_value(mail_map, Value, ItemMap).


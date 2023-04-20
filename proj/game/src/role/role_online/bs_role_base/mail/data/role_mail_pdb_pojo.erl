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
-export([get_mail/2, get_all_mails/1,update_mail/2, put_mailList/2]).
-export([clean_expired/2,clean_readed_and_extracted/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,
    last_index => 0,     %% 最后处理的 index，> index 的mail认为是新的，需要处理的
    mail_map => yyu_map:new_map()  %%{MailId,role_mail_item}
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

get_mail(MailIndex,SelfMap)->
  MailMap = priv_get_mail_map(SelfMap),
  yyu_map:get_value(MailIndex,MailMap).
get_all_mails(SelfMap)->
  MailMap = priv_get_mail_map(SelfMap),
  yyu_map:all_values(MailMap).

clean_expired(NowTime,SelfMap)->
  MailMap = priv_get_mail_map(SelfMap),
  FilterFun = fun(_MailId,RoleMailItem) -> not role_mail_item:is_expired(NowTime,RoleMailItem) end,
  MailMap_1 = yyu_map:filter(FilterFun,MailMap),
  priv_set_mail_map(MailMap_1,SelfMap).

clean_readed_and_extracted(SelfMap)->
  MailMap = priv_get_mail_map(SelfMap),
  FilterFun = fun (_MailId,RoleMailItem) ->
    not (role_mail_item:is_read(RoleMailItem) andalso role_mail_item:is_extract(RoleMailItem))  end,
  MailMap_1 = yyu_map:filter(FilterFun,MailMap),
  priv_set_mail_map(MailMap_1,SelfMap).

update_mail(MailItem,SelfMap)->
  MailMap = priv_get_mail_map(SelfMap),
  MailId = role_mail_item:get_id(MailItem),
  MailMap_1 = yyu_map:put_value(MailId,MailItem,MailMap),
  priv_set_mail_map(MailMap_1,SelfMap).

put_mailList(LcMailItemList,SelfMap)->
  MailMap = priv_get_mail_map(SelfMap),
  MailMap_1 = priv_put_mailList(LcMailItemList,MailMap),
  priv_set_mail_map(MailMap_1,SelfMap).

priv_put_mailList([LcMailItem|Less],AccMailMap)->
  AccMailMap_1 = yyu_map:put_value(role_mail_item:get_id(LcMailItem),LcMailItem,AccMailMap),
  priv_put_mailList(Less,AccMailMap_1);
priv_put_mailList([],AccMailMap)->
  AccMailMap.


priv_get_mail_map(SelfMap) ->
  yyu_map:get_value(mail_map, SelfMap).

priv_set_mail_map(Value, SelfMap) ->
  yyu_map:put_value(mail_map, Value, SelfMap).


%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_adm_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/1,get_id/1,get_ver/1,incr_ver/1]).
-export([add_to_all_mail/2,get_all_mails/1,get_auto_id/1,clean_expired/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(DataId)->
  #{
    '_id' => DataId,ver=>0,
    auto_id => 1,
    to_all_mail_map => yyu_map:new_map()  %% 全服邮件
  }.

get_id(SelfMap) ->
  yyu_map:get_value('_id', SelfMap).

get_ver(SelfMap) ->
  yyu_map:get_value(ver, SelfMap).
incr_ver(SelfMap) ->
  CurVer = get_ver(SelfMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, SelfMap).

get_all_mails(SelfMap)->
  MailMap = priv_get_to_all_mail_map(SelfMap),
  yyu_map:all_values(MailMap).

clean_expired(NowTime,SelfMap)->
  MailMap = priv_get_to_all_mail_map(SelfMap),
  MailMap_1 = yyu_map:filter(fun(_MailId,MailItem) -> not lc_mail_to_all_item:is_expired(NowTime,MailItem) end,MailMap),
  SelfMap_2 = priv_set_to_all_mail_map(MailMap_1, SelfMap),
  SelfMap_2.


add_to_all_mail(RoleMailItem,SelfMap)->
  {NextId,SelfMap_1} = priv_incr_and_get_auto_id(SelfMap),
  ToAllMail = lc_mail_to_all_item:new_pojo(NextId,RoleMailItem),
  MailMap = priv_get_to_all_mail_map(SelfMap_1),
  MailMap_1 = yyu_map:put_value(NextId,ToAllMail,MailMap),

  SelfMap_2 = priv_set_to_all_mail_map(MailMap_1, SelfMap_1),
  SelfMap_2.

priv_incr_and_get_auto_id(SelfMap)->
  NextId = get_auto_id(SelfMap)+1,
  SelfMap_1 = priv_set_auto_id(NextId, SelfMap),
  {NextId,SelfMap_1}.
get_auto_id(SelfMap) ->
  yyu_map:get_value(auto_id, SelfMap).
priv_set_auto_id(Value, SelfMap) ->
  yyu_map:put_value(auto_id, Value, SelfMap).


priv_get_to_all_mail_map(SelfMap) ->
  yyu_map:get_value(to_all_mail_map, SelfMap).
priv_set_to_all_mail_map(Value, SelfMap) ->
  yyu_map:put_value(to_all_mail_map, Value, SelfMap).



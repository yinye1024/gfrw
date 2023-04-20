%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_plrudb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/1,update_to_db/0,check_lru/0]).
-export([add_mail/1,remove_by_index/1, syn_role_mails/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(_GenId)->
  lc_mail_plrudb_holder:proc_init(),
  ?OK.
update_to_db()->
  lc_mail_plrudb_holder:update_to_db(),
  ?OK.
check_lru()->
  lc_mail_plrudb_holder:do_lru(),
  ?OK.


add_mail({RoleId, RoleMailItem})->
  MailPojo = priv_get_data(RoleId),
  NewMail = lc_mail_pojo:add_mail(RoleMailItem,MailPojo),
  priv_update_mail(NewMail),
  ?OK.

remove_by_index({RoleId,MailIndex})->
  MailPojo = priv_get_data(RoleId),
  NewMail = lc_mail_pojo:remove_by_index(MailIndex,MailPojo),
  priv_update_mail(NewMail),
  ?OK.

syn_role_mails({RoleId,LocalCbPojo})->
  MailPojo = priv_get_data(RoleId),
  MailPojo_1 = priv_syn_to_all_mails(MailPojo),
  yyu_local_callback_pojo:do_callback(MailPojo_1,LocalCbPojo),
  ?OK.
priv_syn_to_all_mails(MailPojo)->
  LastMailIndex = lc_mail_pojo:get_to_all_mail_index(MailPojo),
  NewMailPojo =
  case s2s_lc_mail_adm_mgr:get_to_all_mails(LastMailIndex) of
    {LastMailIndex,?NOT_SET}->
      MailPojo;
    {NewMailIndex,MailList}->
      NewMailTmp_1 = lc_mail_pojo:add_mailList(MailList,MailPojo),
      NewMailTmp_2 = lc_mail_pojo:set_to_all_mail_index(NewMailIndex,NewMailTmp_1),
      priv_update_mail(NewMailTmp_2),
      NewMailTmp_2
  end,
  NewMailPojo.

priv_get_data(RoleId)->
  Data =
  case lc_mail_plrudb_holder:get_data(RoleId) of
    ?NOT_SET ->
      Mail = lc_mail_pojo:new_pojo(RoleId),
      priv_update_mail(Mail),
      Mail;
    DataTmp->DataTmp
  end,
  Data.

priv_update_mail(Mail)->
  NewMail = lc_mail_pojo:incr_ver(Mail),
  lc_mail_plrudb_holder:put_data(NewMail),
  ?OK.


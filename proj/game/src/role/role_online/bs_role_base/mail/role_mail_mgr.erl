%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_mail_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/1, syn_mails_from_lc/0,notify_new_mail/0, cb_on_syn_role_mails/1]).
-export([on_mail_read/1,on_mail_extract/1]).
-export([get_all_mails/0]).
-export([clean_expired/0,clean_readed_and_extracted/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(RoleId)->
  role_mail_pdb_holder:init(RoleId),
  ?OK.

clean_expired()->
  RoleMailData = priv_get_data(),
  RoleMailData_1 = role_mail_pdb_pojo:clean_expired(yyu_time:now_seconds(),RoleMailData),
  priv_update_data(RoleMailData_1),
  ?OK.

clean_readed_and_extracted()->
  RoleMailData = priv_get_data(),
  RoleMailData_1 = role_mail_pdb_pojo:clean_readed_and_extracted(RoleMailData),
  priv_update_data(RoleMailData_1),
  ?OK.

notify_new_mail()->
  syn_mails_from_lc(),
  ?OK.

syn_mails_from_lc()->
  RoleId = role_adm_mgr:get_roleId(),
  LocalCbPojo = role_mail_cb_handler:get_cb_on_syn_role_mails(),
  lc_mail_app_api:syn_role_mails(RoleId,LocalCbPojo),
  ?OK.

cb_on_syn_role_mails(MailPojo)->
  RoleId = role_adm_mgr:get_roleId(),
  LcMailItemList = lc_mail_pojo:get_mail_list(MailPojo),
  NewLastIndex = lc_mail_pojo:get_mail_index(MailPojo),

  RoleMailData = priv_get_data(),
  LastIndex = role_mail_pdb_pojo:get_last_index(RoleMailData),
  RoleMailItemList_1 = priv_get_new_role_mailList(LcMailItemList,LastIndex,[]),
  RoleMailData_1 = role_mail_pdb_pojo:set_last_index(NewLastIndex,RoleMailData),
  RoleMailData_2 = role_mail_pdb_pojo:put_mailList(RoleMailItemList_1,RoleMailData_1),
  priv_update_data(RoleMailData_2),
  %% 通知 lc mail 移除已完成的mail
  lc_mail_app_api:remove_by_index(RoleId,NewLastIndex),
  ?OK.
priv_get_new_role_mailList([LcMailItem |Less],LastIndex,AccItemList) ->
  AccItemList_1 =
  case lc_mail_item:get_index(LcMailItem) > LastIndex of
    ?TRUE ->
      RoleMailItem = lc_mail_item:to_role_mail(LcMailItem),
      [RoleMailItem|AccItemList];
    ?FALSE -> AccItemList
  end,
  priv_get_new_role_mailList(Less,LastIndex,AccItemList_1);
priv_get_new_role_mailList([],_LastIndex,AccItemList) ->
    AccItemList.

on_mail_read(MailId)->
  RoleMailData = priv_get_data(),
  RoleMailItem = role_mail_pdb_pojo:get_mail(MailId,RoleMailData),
  RoleMailItem_1 = role_mail_item:on_read(RoleMailItem),
  RoleMailData_1 = role_mail_pdb_pojo:update_mail(RoleMailItem_1,RoleMailData),
  priv_update_data(RoleMailData_1),
  ?OK.

on_mail_extract(MailId)->
  RoleMailData = priv_get_data(),
  RoleMailItem = role_mail_pdb_pojo:get_mail(MailId,RoleMailData),
  AttachItemList = role_mail_item:get_attach_item_list(RoleMailItem),
  RoleMailItem_1 = role_mail_item:on_extract(RoleMailItem),
  RoleMailData_1 = role_mail_pdb_pojo:update_mail(RoleMailItem_1,RoleMailData),
  priv_update_data(RoleMailData_1),

  %% 更新状态再读取附件，避免出错的时候会重复读取附件，
  yyu_list:foreach(fun(AttachItem) -> role_mail_attach_agent:do_attach(AttachItem) end,AttachItemList),
  ?OK.

get_all_mails()->
  RoleMailData = priv_get_data(),
  role_mail_pdb_pojo:get_all_mails(RoleMailData).


priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_mail_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(MultiData)->
  NewMultiData = role_mail_pdb_pojo:incr_ver(MultiData),
  role_mail_pdb_holder:put_data(NewMultiData),
  ?OK.



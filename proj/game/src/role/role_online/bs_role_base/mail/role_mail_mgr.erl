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
-behavior(role_mgr_behaviour).

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([get_mod/0]).

-export([role_init/1,data_load/1,after_data_load/1,loop_5_seconds/2,clean_midnight/2,clean_week/2,on_login/1]).
-export([notify_new_mail/0, cb_on_Get_All_Mail/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->?MODULE.

%% 角色创建，或者角色进程初始化的时候执行
role_init(_RoleId)->
  ?OK.
%% 角色进程初始化的时候执行
data_load(_RoleId)->
  ?OK.
%% 角色进程初始化，data_load 后执行
after_data_load(_RoleId)->
  ?OK.
%% 大约每隔5秒执行一次，具体执行情况要看是否有消息堆积
loop_5_seconds(_RoleId,_NowTime)->
  ?OK.
%% 跨天执行,一般是一些清理业务
clean_midnight(_RoleId,_LastCleanTime)->
  ?OK.
%% 跨周执行,一般是一些清理业务
clean_week(_RoleId,_LastCleanTime)->
  ?OK.
%% 玩家登陆的时候执行
on_login(_RoleId)->
  handle_mail(),
  ?OK.


notify_new_mail()->
  ?OK.
handle_mail()->
  RoleId = role_adm_mgr:get_roleId(),
  LocalCbPojo = role_mail_cb_handler:get_cb_on_Get_All_Mail(),
  lc_mail_app_api:get_data(RoleId,LocalCbPojo),
  ?OK.

cb_on_Get_All_Mail(MailPojo)->
  RoleId = role_adm_mgr:get_roleId(),
  MailItemList = lc_mail_pojo:get_mail_list(MailPojo),
  NewLastIndex = lc_mail_pojo:get_mail_index(MailPojo),

  RoleMailData = priv_get_data(),
  LastIndex = role_mail_pdb_pojo:get_last_index(RoleMailData),
  MailItemList_1 = priv_get_new_mailList(MailItemList,LastIndex,[]),
  RoleMailData_1 = role_mail_pdb_pojo:set_last_index(NewLastIndex,RoleMailData),
  RoleMailData_2 = role_mail_pdb_pojo:put_mailList(MailItemList_1,RoleMailData_1),
  priv_update_data(RoleMailData_2),
  %% 通知 lc mail 移除已完成的mail
  lc_mail_app_api:remove_by_index(RoleId,NewLastIndex),
  ?OK.
priv_get_new_mailList([MailItem|Less],LastIndex,AccItemList) ->
  AccItemList_1 =
  case lc_mail_item:get_index(MailItem) > LastIndex of
    ?TRUE ->
      [MailItem|AccItemList];
    ?FALSE -> AccItemList
  end,
  priv_get_new_mailList(Less,LastIndex,AccItemList_1);
priv_get_new_mailList([],_LastIndex,AccItemList) ->
    AccItemList.


priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_mail_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(MultiData)->
  NewMultiData = role_mail_pdb_pojo:incr_ver(MultiData),
  role_mail_pdb_holder:put_data(NewMultiData),
  ?OK.



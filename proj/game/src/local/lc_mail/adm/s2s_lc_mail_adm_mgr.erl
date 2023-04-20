%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_lc_mail_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([ets_init/0,start_sup_link/0, stop/0]).
-export([add_to_all_mail/1,get_to_all_mails/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%%
ets_init()->
  lc_mail_adm_mgr:ets_init(),
  ?OK.

start_sup_link()->
  gs_lc_mail_adm_mgr:start_sup_link(),
  ?OK.

stop()->
  gs_lc_mail_adm_mgr:stop(),
  ?OK.

add_to_all_mail(RoleMailItem)->
  WorkFun = fun lc_mail_adm_mgr:add_to_all_mail/1,
  priv_cast_fun({WorkFun,[{RoleMailItem}]}),
  ?OK.

get_to_all_mails(LastMailIndex)->
  LcMailAdmPojo = lc_mail_adm_mgr:get_data(),
  NewMailIndex = lc_mail_adm_pojo:get_auto_id(LcMailAdmPojo),
  MailList =
  case NewMailIndex > LastMailIndex of
    ?TRUE ->
      MailListTmp = lc_mail_adm_pojo:get_all_mails(LcMailAdmPojo),
      FilterFun = fun(ToAllMailItem) -> lc_mail_to_all_item:get_id(ToAllMailItem) > LastMailIndex end,
      MailListTmp_1 = yyu_list:filter( FilterFun,MailListTmp),
      MailListTmp_1;
    ?FALSE ->
      ?NOT_SET
  end,
  {NewMailIndex,MailList}.







%%priv_call_fun({WorkFun,Param})->
%%  Result = gs_lc_mail_adm_mgr:call_fun({WorkFun,Param}),
%%  Result.
priv_cast_fun({WorkFun,Param})->
  gs_lc_mail_adm_mgr:cast_fun({WorkFun,Param}),
  ?OK.

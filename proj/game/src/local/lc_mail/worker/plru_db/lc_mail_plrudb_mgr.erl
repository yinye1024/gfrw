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
-export([add_mail/1,remove_by_index/1,get_all_mail/1]).

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


add_mail({RoleId,Mail})->
  Mail = priv_get_data(RoleId),
  NewMail = lc_mail_pojo:add_mail(Mail,Mail),
  priv_update_mail(NewMail),
  ?OK.

remove_by_index({RoleId,MailIndex})->
  Mail = priv_get_data(RoleId),
  NewMail = lc_mail_pojo:remove_by_index(MailIndex,Mail),
  priv_update_mail(NewMail),
  ?OK.

get_all_mail({RoleId,LocalCbPojo})->
  Mail = priv_get_data(RoleId),
  yyu_local_callback_pojo:do_callback(Mail,LocalCbPojo),
  ?OK.

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
  %% 每次更新要同时更新ets缓存
  s2s_lc_mail_adm_mgr:put_data(NewMail),
  ?OK.


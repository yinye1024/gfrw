%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     全服邮件
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_to_all_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/2]).
-export([get_id/1, get_mail/1, is_started/2, is_expired/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(Id,RoleMailItem)->
  #{
    id=>Id,
    mail=>RoleMailItem
  }.


get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_mail(SelfMap) ->
  yyu_map:get_value(mail, SelfMap).

is_started(NowTime,SelfMap) ->
  RoleMail = get_mail(SelfMap),
  role_mail_item:is_started(NowTime,RoleMail).


is_expired(NowTime,SelfMap)->
  RoleMail = get_mail(SelfMap),
  role_mail_item:is_expired(NowTime,RoleMail).

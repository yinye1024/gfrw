%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/2]).
-export([get_index/1, get_mail/1,to_role_mail/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(Index,Mail)->
  #{
    index => Index,
    mail => Mail      %% role_mail_item
  }.

get_index(SelfMap) ->
  yyu_map:get_value(index, SelfMap).

get_mail(SelfMap) ->
  yyu_map:get_value(mail, SelfMap).

to_role_mail(SelfMap)->
  RoleMailItem = get_mail(SelfMap),
  RoleMailItem_1 = role_mail_item:set_id(get_index(SelfMap),RoleMailItem),
  RoleMailItem_1.



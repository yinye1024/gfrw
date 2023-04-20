%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([ets_init/0,proc_init/0]).
-export([add_to_all_mail/1,get_data/0,clean_expired/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
ets_init()->
  lc_mail_adm_holder:ets_init(),
  ?OK.

proc_init()->
  lc_mail_adm_holder:proc_init(),
  ?OK.

clean_expired()->
  Data = get_data(),
  Data_1 = lc_mail_adm_pojo:clean_expired(yyu_time:now_seconds(),Data),
  priv_update(Data_1),
  ?OK.

add_to_all_mail({RoleMailItem})->
  Data = get_data(),
  Data_1 = lc_mail_adm_pojo:add_to_all_mail(RoleMailItem,Data),
  priv_update(Data_1),
  ?OK.


get_data()->
  Data = lc_mail_adm_holder:get_data(),
  Data.

priv_update(Data) ->
  NewData = lc_mail_adm_pojo:incr_ver(Data),
  lc_mail_adm_holder:update_data(NewData),
  ?OK.
%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 14:26
%%%-------------------------------------------------------------------
-module(gs_role_gen_life_cycle_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(LifeCycleMgrList, [
  role_life_cycle:get_mod()
  , role_res_life_cycle_mgr:get_mod()
  ,role_avatar_life_cycle:get_mod()
  ,role_friend_life_cycle:get_mod()
  ,role_mail_life_cycle:get_mod()
]).
%% API
-export([role_init/0,data_load/0,after_data_load/0,loop_5_seconds/0,clean_midnight/1,clean_week/1,on_login/0]).

role_init()->
  RoleId = role_adm_mgr:get_roleId(),
  priv_do_fun(?LifeCycleMgrList,role_init,RoleId),
  ?OK.

data_load()->
  RoleId = role_adm_mgr:get_roleId(),
  priv_do_fun(?LifeCycleMgrList,data_load,RoleId),
  ?OK.

after_data_load()->
  RoleId = role_adm_mgr:get_roleId(),
  priv_do_fun(?LifeCycleMgrList,after_data_load,RoleId),
  ?OK.

loop_5_seconds()->
  RoleId = role_adm_mgr:get_roleId(),
  NowTime = yyu_time:now_seconds(),
  priv_do_fun(?LifeCycleMgrList,loop_5_seconds,RoleId,NowTime),
  ?OK.

clean_midnight(LastCleanTime)->
  RoleId = role_adm_mgr:get_roleId(),
  priv_do_fun(?LifeCycleMgrList,clean_midnight,RoleId,LastCleanTime),
  ?OK.

clean_week(LastCleanTime)->
  RoleId = role_adm_mgr:get_roleId(),
  priv_do_fun(?LifeCycleMgrList,clean_week,RoleId,LastCleanTime),
  ?OK.

on_login()->
  RoleId = role_adm_mgr:get_roleId(),
  priv_do_fun(?LifeCycleMgrList,on_login,RoleId),
  ?OK.

priv_do_fun([Mod|Less], Method, RoleId) ->
  case yyu_fun:is_fun_exported(Mod,Method,1) of
    ?TRUE ->
      Mod:Method(RoleId),
      ?OK;
    ?FALSE ->
      ?OK
  end,
  priv_do_fun(Less, Method, RoleId);
priv_do_fun([], _Method, _RoleId) ->
  ?OK.

priv_do_fun([Mod|Less], Method, RoleId,Args) ->
  case yyu_fun:is_fun_exported(Mod,Method,2) of
    ?TRUE ->
      Mod:Method(RoleId,Args),
      ?OK;
    ?FALSE ->
      ?OK
  end,
  priv_do_fun(Less, Method, RoleId,Args);
priv_do_fun([], _Method, _RoleId,_Args) ->
  ?OK.

%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_pdb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/1]).
-export([get_active_heroIdList/0, save_active_heroIdList/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(RoleId)->
  role_prop_pdb_holder:init(RoleId),
  ?OK.

get_active_heroIdList() ->
  PdbData = priv_get_pdata(),
  HeroIdList = role_prop_pdb_pojo:get_active_heroIdList(PdbData),
  HeroIdList.

save_active_heroIdList(HeroIdList) ->
  PdbData = priv_get_pdata(),
  PdbData_1 = role_prop_pdb_pojo:set_active_heroIdList(HeroIdList,PdbData),
  priv_update_pdata(PdbData_1).


priv_get_pdata()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_prop_pdb_holder:get_data(RoleId),
  Data.

priv_update_pdata(MultiData)->
  NewMultiData = role_prop_pdb_pojo:incr_ver(MultiData),
  role_prop_pdb_holder:put_data(NewMultiData),
  ?OK.



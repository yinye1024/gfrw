%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_avatar_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/1]).
-export([do_head_change/2, update_or_new_lc_role/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(RoleId)->
  role_avatar_pdb_holder:init(RoleId),
  ?OK.

do_head_change(HeadId,HeadBorder)->
  DataPojo = priv_get_data(),
  DataPojo_1 = role_avatar_pdb_pojo:set_headId(HeadId,DataPojo),
  DataPojo_2 = role_avatar_pdb_pojo:set_head_border(HeadBorder,DataPojo_1),
  priv_update_data(DataPojo_2),
  update_or_new_lc_role(),
  {?TRUE,HeadId,HeadBorder}.

update_or_new_lc_role()->
  RoleId = role_adm_mgr:get_roleId(),
  LcRole = lc_role_app_api:get_data(RoleId),
  [RolePdbPojo, RoleAvatarPdbPojo] = [role_mgr:get_data(),priv_get_data()],
  LcRolePojo = lc_role_pdb_pojo:update_from_role(RolePdbPojo, RoleAvatarPdbPojo,LcRole),
  lc_role_app_api:update_or_new_role(LcRolePojo),
  ?OK.


priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_avatar_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(Data)->
  NewData = role_avatar_pdb_pojo:incr_ver(Data),
  role_avatar_pdb_holder:put_data(NewData),
  ?OK.



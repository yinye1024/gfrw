%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 13. 1月 2023 17:23
%%%-------------------------------------------------------------------
-module(role_create_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API
-export([raw_create/1,raw_get/1,raw_get_by_name/1,raw_get_by_user/2]).
%% 直接创建，不放入进程字典，此时玩家进程还没有启动
raw_create(RoleCreateItem)->
  UserId = role_create_item:get_userId(RoleCreateItem),
  RoleId = game_autoId_mgr:get_role_autoId(),
  SvrId = game_config:get_svrId(),
  {Name,Gender} = role_create_item:get_create_info(RoleCreateItem),
  RolePojo = role_pdb_pojo:new_pojo(RoleId,{UserId,SvrId,Name,Gender}),
  role_pdb_dao:create(RolePojo),
  {?OK,RolePojo}.
raw_get(RoleId)->
  role_pdb_dao:get_by_id(RoleId).
raw_get_by_name(Name)->
  role_pdb_dao:get_by_name(Name).
raw_get_by_user(UserId,SvrId)->
  role_pdb_dao:get_by_user(UserId,SvrId).
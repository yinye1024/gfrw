%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_login_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/login_pb.hrl").

%% API functions defined
-export([login_or_create/0, role_logout_c2s/0, start_miss_client_pack/0,role_reconnect_c2s/0]).

-export([on_login_success/1, on_created_success/0,on_logout_s2c/0]).
-export([on_recv_role_info/1]).
-export([on_role_reconnect_s2c/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
login_or_create()->
  RoleInfo = robot_pc_mgr:get_client_role_info(),

  ?LOG_ERROR({" login_or_create ++++++++ is_login",robot_client_role_item:is_login(RoleInfo) }),
  case robot_client_role_item:is_login(RoleInfo) of
    ?FALSE ->
      UserId = robot_client_role_item:get_id(RoleInfo),
      UName = robot_client_role_item:get_name(RoleInfo),
      %% 每次重登需要重新建立链接
      robot_role_client:new_role_client(UserId),
      robot_login_c2s_sender:role_login_c2s(UserId,UName),
      ?OK;
    ?TRUE ->
     ?OK
  end,
  ?OK.

priv_do_create_role(RoleInfo) ->
  UName = robot_client_role_item:get_name(RoleInfo),
  Gender = 1,
  robot_login_c2s_sender:create_role_c2s(UName,Gender),
  ?OK.

role_logout_c2s()->
  ?LOG_ERROR({"send role_logout_c2s"}),
  robot_login_c2s_sender:role_logout_c2s(),
  ?OK.

start_miss_client_pack()->
  robot_pc_mgr:set_is_miss_client_pack(?TRUE),
  ?OK.

role_reconnect_c2s()->
  ?LOG_ERROR({"send role_reconnect_c2s"}),
  RoleInfo = robot_pc_mgr:get_client_role_info(),
  UserId = robot_client_role_item:get_id(RoleInfo),
  {ClientMid,SvrMid} = {robot_pc_mgr:get_client_mid(),robot_pc_mgr:get_svr_mid()},
  %% 每次重登需要重新建立链接
  robot_role_client:new_role_client(UserId),
  robot_login_c2s_sender:role_reconnect_c2s(UserId,ClientMid,SvrMid),
  ?OK.



on_login_success(ExistRole)->
  priv_set_login_status(?TRUE),

  ?LOG_ERROR({"on_login_success success",{ExistRole}}),
  case ExistRole of
    ?TRUE ->
      ?OK;
    _Other ->
      ?LOG_ERROR({" no role",{_Other}}),
      RoleInfo = robot_pc_mgr:get_client_role_info(),
      priv_do_create_role(RoleInfo),
      ?OK
  end,
  ?OK.

priv_set_login_status(IsLogin) when is_boolean(IsLogin) ->
  ClientRole = robot_pc_mgr:get_client_role_info(),
  NewClientRole = robot_client_role_item:set_is_login(IsLogin, ClientRole),
  robot_pc_mgr:update_client_role_info(NewClientRole).

on_created_success()->
  ?LOG_ERROR({"create role success"}),
  ?OK.

on_recv_role_info(RoleInfo)->
  SvrRoleInfoItem = robot_svr_role_item:new_pojo(RoleInfo),
  robot_pc_mgr:update_svr_role_info(SvrRoleInfoItem),
  ?OK.

on_logout_s2c()->
  priv_set_login_status(?FALSE),
  ?OK.

on_role_reconnect_s2c(NeedLogin,_HasPack, LastClientMid)->
  case NeedLogin of
    ?TRUE ->
      SetIsLogin = not NeedLogin,
      priv_set_login_status(SetIsLogin),
      ?OK;
    ?FALSE ->
      robot_pc_mgr:reset_client_mid(LastClientMid),
      robot_login_c2s_sender:reset_gw_mid_c2s(LastClientMid),
      ?OK
  end,
  ?OK.
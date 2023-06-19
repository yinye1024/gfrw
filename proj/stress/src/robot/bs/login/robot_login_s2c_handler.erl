%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_login_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/login_pb.hrl").


%% API functions defined
-export([create_role_s2c/1,role_login_s2c/1,role_logout_s2c/1,role_info_s2c/1,role_reconnect_s2c/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
role_login_s2c(BinData)->
  #role_login_s2c{
    result_code = ResultCode,
    main_svr_id = _MainSvrId,
    exist_role = ExistRole
  } = login_pb:decode_msg(BinData,role_login_s2c),
  case ResultCode of
    0 -> robot_login_mgr:on_login_success(ExistRole);
    FailCode ->
      ?LOG_INFO({"login fail, FailCode :",FailCode}),
      ?OK
  end,
  ?OK.
create_role_s2c(BinData)->
  #create_role_s2c{
    result_code = ResultCode
  } = login_pb:decode_msg(BinData,create_role_s2c),

  case ResultCode of
    0 -> robot_login_mgr:on_created_success();
    FailCode ->
      ?LOG_INFO({"create role fail, FailCode :",FailCode}),
      ?OK
  end,
  ?OK.

role_logout_s2c(BinData)->
  #role_logout_s2c{
    code = LogoutCode
  } = login_pb:decode_msg(BinData,role_logout_s2c),
  ?LOG_INFO({"role logout, Code :",LogoutCode}),
  robot_login_mgr:on_logout_s2c(),
  ?OK.


role_info_s2c(BinData)->
  #role_info_s2c{
    role_info = RoleInfo
  } = login_pb:decode_msg(BinData,role_info_s2c),
  ?LOG_INFO({"role_info_s2c:",RoleInfo}),
  robot_login_mgr:on_recv_role_info(RoleInfo),
  ?OK.

role_reconnect_s2c(BinData)->
  #role_reconnect_s2c{
    need_login = NeedLogin,
    has_pack = HasPack,
    last_client_mid = LastClientMid
  } = login_pb:decode_msg(BinData,role_reconnect_s2c),
  ?LOG_INFO({"role_reconnect_s2c,{need_login,cur_client_mid}",{NeedLogin, LastClientMid}}),
  robot_login_mgr:on_role_reconnect_s2c(NeedLogin,HasPack,LastClientMid),
  ?OK.



%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 10. 1月 2023 11:29
%%%-------------------------------------------------------------------
-module(role_gw_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/login_pb.hrl").
-include("role/role_gw/login.hrl").


%% API
-export([send_connect_active_s2c/1]).
-export([send_login_success/1, send_login_fail/1, send_role_logout_s2c/1, send_create_role_s2c/1]).
-export([call_stop/1,cast_stop/1]).

%% 通知客户端链接激活结果，
send_connect_active_s2c(ResultCode)->
  RoleLoginS2C = #connect_active_s2c{
    result_code = ResultCode
  },
  {S2CId, PBufBin} = cmd_map:encode_s2c(RoleLoginS2C),
  Mid = ?Svr_Side_MID,
  priv_send({Mid,S2CId,PBufBin}).

send_login_success(ExistRole) when is_boolean(ExistRole)->
  RoleLoginS2C = #role_login_s2c{
    result_code = 0,
    exist_role = ExistRole,
    main_svr_id = game_cfg:get_svrId()
  },
  {S2CId, PBufBin} = cmd_map:encode_s2c(RoleLoginS2C),
  Mid = ?Svr_Side_MID,
  priv_send({Mid,S2CId,PBufBin}).

%% 通知客户端登陆失败，ErrorCode
send_login_fail(ErrorCode)->
  RoleLoginS2C = #role_login_s2c{
    result_code = ErrorCode,
    main_svr_id = game_cfg:get_svrId()
  },
  {S2CId, PBufBin} = cmd_map:encode_s2c(RoleLoginS2C),
  Mid = ?Svr_Side_MID,
  priv_send({Mid,S2CId,PBufBin}).

%% 通知客户端玩家登出,ReasonCode
send_role_logout_s2c(ReasonCode)->
  RoleLogoutS2C = #role_logout_s2c{
    code = ReasonCode
  },
  {S2CId, PBufBin} = cmd_map:encode_s2c(RoleLogoutS2C),
  Mid = ?Svr_Side_MID,
  priv_send({Mid,S2CId,PBufBin}).

%% 通知客户端创角结果
send_create_role_s2c(ResultCode)->
  CreateRoleS2C = #create_role_s2c{
    result_code = ResultCode
  },
  {S2CId, PBufBin} = cmd_map:encode_s2c(CreateRoleS2C),
  Mid = ?Svr_Side_MID,
  priv_send({Mid,S2CId,PBufBin}).

priv_send(BsData = {_Mid,_S2CId,_PBufBin} )->
  yynw_tcp_gw_api:inner_send(BsData),
  ?OK.

call_stop(Reason)->
  ?LOG_ERROR({stop,Reason}),
  yynw_tcp_gw_api:call_stop(self()),
  ?OK.
cast_stop(Reason)->
  ?LOG_ERROR({stop,Reason}),
  yynw_tcp_gw_api:cast_stop(self()),
  ?OK.


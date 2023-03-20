%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(role_s2c_handler).
-author("yinye").

-include_lib("protobuf/include/login_pb.hrl").
-include_lib("yyutils/include/yyu_comm.hrl").
%% API
-export([send_role_logout_s2c/1, send_role_info_s2c/1, send_role_reconnect_s2c/3]).


%% 通知客户端玩家登出,ReasonCode
send_role_logout_s2c(ReasonCode)->
  RoleLogoutS2C = #role_logout_s2c{
    code = ReasonCode
  },
  role_inner_misc:inner_mark_send_RecordData(RoleLogoutS2C).


%% 发送roleInfo 给客户端
send_role_info_s2c(RolePdbPojo)->
  ?LOG_INFO({rolePojo,RolePdbPojo}),
  RoleInfoS2C = #role_info_s2c{
    role_info = role_pdb_pojo:to_p_roleInfo(RolePdbPojo)
  },
  role_inner_misc:inner_mark_send_RecordData(RoleInfoS2C).

send_role_reconnect_s2c(IsNeedLogin,HasPack, LastClientMId)->
  RecordS2C = #role_reconnect_s2c{
    need_login = IsNeedLogin,
    has_pack = HasPack,
    last_client_mid = LastClientMId
  },
  ?LOG_INFO("send_role_reconnect_s2c"),
  role_inner_misc:inner_mark_send_RecordData(RecordS2C).


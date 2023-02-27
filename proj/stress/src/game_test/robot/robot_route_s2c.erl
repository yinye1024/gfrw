%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_route_s2c).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game/include/login.hrl").

-include_lib("protobuf/include/cmd_map.hrl").

%% API functions defined
-export([route_s2c/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
route_s2c({SvrMsgId,S2CId, BinData})->
  ?LOG_INFO({"received msg from svr:",{SvrMsgId,S2CId, BinData}}),
  robot_pc_mgr:set_svr_mid(SvrMsgId),
  priv_route_s2c(S2CId,BinData).

priv_route_s2c(?CONNECT_ACTIVE_S2C, _BinData)->
  ?LOG_INFO({"tcp actived +++++++++++++++"}),
  robot_pc_mgr:on_gw_active(),
  ?OK;
priv_route_s2c(?CREATE_ROLE_S2C, BinData)->
  robot_login_s2c_handler:create_role_s2c(BinData),
  ?OK;
priv_route_s2c(?ROLE_LOGIN_S2C, BinData)->
  robot_login_s2c_handler:role_login_s2c(BinData),
  ?OK;
priv_route_s2c(?ROLE_LOGOUT_S2C, BinData)->
  robot_login_s2c_handler:role_logout_s2c(BinData),
  ?OK;
priv_route_s2c(?ROLE_INFO_S2C, BinData)->
  robot_login_s2c_handler:role_info_s2c(BinData),
  ?OK;
priv_route_s2c(?ROLE_RECONNECT_S2C, BinData)->
  robot_login_s2c_handler:role_reconnect_s2c(BinData),
  ?OK;
priv_route_s2c(S2CId, BinData)->
  ?LOG_INFO({"unhandle msg ",{S2CId,BinData}}),
  ?OK.

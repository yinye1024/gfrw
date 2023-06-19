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
-include_lib("game/include/role/role_gw/login.hrl").

-include_lib("game_proto/include/cmd_map.hrl").

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

%%login.proto
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

%%friend.proto
priv_route_s2c(?FRIEND_APPLY_LIST_S2C, BinData)->
  robot_friend_mgr:friend_apply_list_s2c(BinData),
  ?OK;
priv_route_s2c(?FRIEND_NEW_APPLY_S2C, BinData)->
  robot_friend_mgr:friend_new_apply_s2c(BinData),
  ?OK;
priv_route_s2c(?FRIEND_HANDLE_APPLY_S2C, BinData)->
  robot_friend_mgr:friend_handle_apply_s2c(BinData),
  ?OK;
priv_route_s2c(?FRIEND_LIST_S2C, BinData)->
  robot_friend_mgr:friend_list_s2c(BinData),
  ?OK;

%%mail.proto
priv_route_s2c(?MAIL_LIST_S2C, BinData)->
  robot_mail_mgr:mail_list_s2c(BinData),
  ?OK;
priv_route_s2c(?MAIL_OPEN_S2C, BinData)->
  robot_mail_mgr:mail_open_s2c(BinData),
  ?OK;


%%res.proto
priv_route_s2c(?RES_LIST_BAG_S2C, BinData)->
  robot_res_mgr:res_list_bag_s2c(BinData),
  ?OK;
priv_route_s2c(?RES_LIST_WALLET_S2C, BinData)->
  robot_res_mgr:res_list_wallet_s2c(BinData),
  ?OK;
priv_route_s2c(?RES_USE_BAG_ITEM_S2C, BinData)->
  robot_res_mgr:res_use_bagItem_s2c(BinData),
  ?OK;
priv_route_s2c(?RES_USE_WALLET_ITEM_S2C, BinData)->
  robot_res_mgr:res_use_walletItem_s2c(BinData),
  ?OK;

%%prop.proto
priv_route_s2c(?ROLE_PROP_PLAYER_S2C, BinData)->
  robot_prop_mgr:role_prop_player_s2c(BinData),
  ?OK;
priv_route_s2c(?ROLE_PROP_PLAYER_CHANGED_S2C, BinData)->
  robot_prop_mgr:role_prop_player_changed_s2c(BinData),
  ?OK;

priv_route_s2c(S2CId, BinData)->
  ?LOG_INFO({"unhandle msg ",{S2CId,BinData}}),
  ?OK.

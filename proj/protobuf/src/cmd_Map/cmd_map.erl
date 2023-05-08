%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%      协议映射关系，要和前端协调一致，可以考虑由前端自动生成
%%%      c2s 客户端到服务端 s2c 服务端返回给客户端
%%% @end
%%% Created : 03. 1月 2023 15:44
%%%-------------------------------------------------------------------
-module(cmd_map).
-author("yinye").

-include("cmd_map.hrl").
%% API
-export([decode_c2s/2]).
-export([encode_s2c/1]).

%% {MsgHandlerMod,MsgHandlerMethod,C2SRD} = cmd_map:decode_c2s(C2SId, C2SBinData),
decode_c2s(C2SId, C2SBinData)->
  case priv_c2s(C2SId) of
    {MsgHandlerMod,MsgDecoderMod,MsgName} ->
      C2SRD = MsgDecoderMod:decode_msg(C2SBinData,MsgName),
      %% 默认处理函数 与 MsgName 保持一致，减少配置
      MsgHandlerMethod = MsgName,
      {MsgHandlerMod,MsgHandlerMethod,C2SRD};
    _Other ->
      {unknown_c2s_handler,C2SId,C2SBinData}
  end.

%% c2s(C2SId)->{MsgHandlerMod,MsgHandlerMethod,MsgDecoderMod,MsgName};
%%login.proto
priv_c2s(?CREATE_ROLE_C2S)->{gw_c2s_handler,login_pb,create_role_c2s};
priv_c2s(?ROLE_LOGIN_C2S)->{gw_c2s_handler,login_pb,role_login_c2s};
priv_c2s(?ROLE_RECONNECT_C2S)->{gw_c2s_handler,login_pb,role_reconnect_c2s};
priv_c2s(?RESET_GW_MID_C2S)->{gw_c2s_handler,login_pb,reset_gw_mid_c2s};
priv_c2s(?ROLE_LOGOUT_C2S)->{role_c2s_handler,login_pb,role_logout_c2s};

%%avatar.proto
priv_c2s(?AVATAR_HEART_BEAT_C2S)->{gw_c2s_handler,avatar_pb,avatar_heart_beat_c2s};
priv_c2s(?AVATAR_HEAD_CHANGE_C2S)->{avatar_c2s_handler,avatar_pb,avatar_head_change_c2s};
priv_c2s(?SVR_OPEN_TIME_C2S)->{avatar_c2s_handler,avatar_pb,svr_open_time_c2s};

%%friend.proto
priv_c2s(?FRIEND_APPLY_LIST_C2S)->{friend_c2s_handler,friend_pb,friend_apply_list_c2s};
priv_c2s(?FRIEND_NEW_APPLY_C2S)->{friend_c2s_handler,friend_pb,friend_new_apply_c2s};
priv_c2s(?FRIEND_HANDLE_APPLY_C2S)->{friend_c2s_handler,friend_pb,friend_handle_apply_c2s};
priv_c2s(?FRIEND_LIST_C2S)->{friend_c2s_handler,friend_pb,friend_list_c2s};

%%gm.proto
priv_c2s(?GM_CMD_C2S)->{gm_c2s_handler,gm_pb,gm_cmd_c2s};

%%mail.proto
priv_c2s(?MAIL_LIST_C2S)->{mail_c2s_handler,mail_pb,mail_list_c2s};
priv_c2s(?MAIL_OPEN_C2S)->{mail_c2s_handler,mail_pb,mail_open_c2s};

%%res.proto
priv_c2s(?RES_LIST_BAG_C2S)->{res_c2s_handler,res_pb,res_list_bag_c2s};
priv_c2s(?RES_LIST_WALLET_C2S)->{res_c2s_handler,res_pb,res_list_wallet_c2s};
priv_c2s(?RES_USE_BAG_ITEM_C2S)->{res_c2s_handler,res_pb,res_use_bag_item_c2s};
priv_c2s(?RES_USE_WALLET_ITEM_C2S)->{res_c2s_handler,res_pb,res_use_wallet_item_c2s};

%%prop.proto
priv_c2s(?ROLE_PROP_PLAYER_C2S)->{prop_c2s_handler,prop_pb,role_prop_player_c2s};


priv_c2s(_)->{unknown_c2s_handler}.

%% s2c(S2CMsgRecordName)->{S2CId,MsgEncoderMod,MsgEncoderMethod};
encode_s2c(RecordS2C) when is_tuple(RecordS2C)->
  {S2CId,EncodeMod}=priv_s2c(element(1,RecordS2C)),
  PBufBin = EncodeMod:encode_msg(RecordS2C),
  {S2CId, PBufBin}.

priv_s2c(connect_active_s2c)->{?CONNECT_ACTIVE_S2C,login_pb};

%%login.proto
priv_s2c(create_role_s2c)->{?CREATE_ROLE_S2C,login_pb};
priv_s2c(role_login_s2c)->{?ROLE_LOGIN_S2C,login_pb};
priv_s2c(role_reconnect_s2c)->{?ROLE_RECONNECT_S2C,login_pb};
priv_s2c(role_logout_s2c)->{?ROLE_LOGOUT_S2C,login_pb};
priv_s2c(role_info_s2c)->{?ROLE_INFO_S2C,login_pb};

%%avatar.proto
priv_s2c(avatar_head_change_s2c)->{?AVATAR_HEAD_CHANGE_S2C,avatar_pb};
priv_s2c(svr_open_time_s2c)->{?SVR_OPEN_TIME_S2C,avatar_pb};

%%friend.proto
priv_s2c(friend_apply_list_s2c)->{?FRIEND_APPLY_LIST_S2C,friend_pb};
priv_s2c(friend_new_apply_s2c)->{?FRIEND_NEW_APPLY_S2C,friend_pb};
priv_s2c(friend_handle_apply_s2c)->{?FRIEND_HANDLE_APPLY_S2C,friend_pb};
priv_s2c(friend_list_s2c)->{?FRIEND_LIST_S2C,friend_pb};

%%mail.proto
priv_s2c(mail_list_s2c)->{?MAIL_LIST_S2C,mail_pb};
priv_s2c(mail_open_s2c)->{?MAIL_OPEN_S2C,mail_pb};

%%res.proto
priv_s2c(res_list_bag_s2c)->{?RES_LIST_BAG_S2C,res_pb};
priv_s2c(res_list_wallet_s2c)->{?RES_LIST_WALLET_S2C,res_pb};
priv_s2c(res_use_bag_item_s2c)->{?RES_USE_BAG_ITEM_S2C,res_pb};
priv_s2c(res_use_wallet_item_s2c)->{?RES_USE_WALLET_ITEM_S2C,res_pb};
%%res.proto
priv_s2c(role_prop_player_s2c)->{?ROLE_PROP_PLAYER_S2C,prop_pb};
priv_s2c(role_prop_player_changed_s2c)->{?ROLE_PROP_PLAYER_CHANGED_S2C,prop_pb};

priv_s2c(UnknownRecord)->yyu_error:throw_error({unknown_s2c_record,UnknownRecord}).
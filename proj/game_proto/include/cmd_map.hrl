-ifndef(cmd_map).
-define(cmd_map, true).

%% ===========================  c2s 开始 ===========================================================
%%login.proto c2s
-define(CREATE_ROLE_C2S,101).
-define(ROLE_LOGIN_C2S,102).
-define(ROLE_RECONNECT_C2S,103).
-define(ROLE_LOGOUT_C2S,104).
-define(RESET_GW_MID_C2S,105).

%%avatar.proto
-define(AVATAR_HEART_BEAT_C2S,201).
-define(AVATAR_HEAD_CHANGE_C2S,202).
-define(SVR_OPEN_TIME_C2S,203).

%%friend.proto
-define(FRIEND_APPLY_LIST_C2S,301).
-define(FRIEND_NEW_APPLY_C2S,302).
-define(FRIEND_HANDLE_APPLY_C2S,303).
-define(FRIEND_LIST_C2S,304).

%%gm.proto
-define(GM_CMD_C2S,401).

%%mail.proto
-define(MAIL_LIST_C2S,501).
-define(MAIL_OPEN_C2S,502).

%%res.proto
-define(RES_LIST_BAG_C2S,601).
-define(RES_LIST_WALLET_C2S,602).
-define(RES_USE_BAG_ITEM_C2S,603).
-define(RES_USE_WALLET_ITEM_C2S,604).

%%prop.proto
-define(ROLE_PROP_PLAYER_C2S,701).



%% ===========================  c2s 结束 ===========================================================



%% ===========================  s2c 开始 ===========================================================
-define(CONNECT_ACTIVE_S2C,1).
%%login.proto
-define(CREATE_ROLE_S2C,101).
-define(ROLE_LOGIN_S2C,102).
-define(ROLE_RECONNECT_S2C,103).
-define(ROLE_LOGOUT_S2C,104).
-define(ROLE_INFO_S2C,105).

%%avatar.proto
-define(AVATAR_HEAD_CHANGE_S2C,202).
-define(SVR_OPEN_TIME_S2C,203).

%%friend.proto
-define(FRIEND_APPLY_LIST_S2C,301).
-define(FRIEND_NEW_APPLY_S2C,302).
-define(FRIEND_HANDLE_APPLY_S2C,303).
-define(FRIEND_LIST_S2C,304).


%%mail.proto
-define(MAIL_LIST_S2C,501).
-define(MAIL_OPEN_S2C,502).

%%res.proto
-define(RES_LIST_BAG_S2C,601).
-define(RES_LIST_WALLET_S2C,602).
-define(RES_USE_BAG_ITEM_S2C,603).
-define(RES_USE_WALLET_ITEM_S2C,604).

%%prop.proto
-define(ROLE_PROP_PLAYER_S2C,701).
-define(ROLE_PROP_PLAYER_CHANGED_S2C,702).

%% ===========================  s2c 结束 ===========================================================
-endif.

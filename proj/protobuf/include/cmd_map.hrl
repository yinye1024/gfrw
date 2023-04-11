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


%% ===========================  s2c 结束 ===========================================================
-endif.

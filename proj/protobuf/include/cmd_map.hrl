-ifndef(cmd_map).
-define(cmd_map, true).

%% c2s
-define(CREATE_ROLE_C2S,101).
-define(ROLE_LOGIN_C2S,102).
-define(ROLE_RECONNECT_C2S,103).
-define(ROLE_LOGOUT_C2S,104).
-define(RESET_GW_MID_C2S,105).


-define(AVATAR_HEART_BEAT_C2S,201).

%% s2c
-define(CONNECT_ACTIVE_S2C,1).
-define(CREATE_ROLE_S2C,101).
-define(ROLE_LOGIN_S2C,102).
-define(ROLE_RECONNECT_S2C,103).
-define(ROLE_LOGOUT_S2C,104).
-define(ROLE_INFO_S2C,105).

-endif.

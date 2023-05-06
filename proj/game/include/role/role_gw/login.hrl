-ifndef(login).
-define(login, true).


-define(Svr_Side_MID,0).  %% 服务端自己发起的msg，不是对前端请求的响应，例如 后端报错，提示，kick out 等。
-define(CType_Login,1).
-define(CType_ReConn,2).

-define(ActivePackByteLength,8).
-define(UserIdBitSize,32).
-define(TicketBitSize,32).

-define(HeadByteLength,4).

-define(Create_Role_Success,0).
-define(Create_Role_Fail,1).

-define(Logout_Normal,0). %% 正常登出

-define(Logout_Active_Auth_Fail,1). %% 激活包校验失败
-define(Logout_Mid_Error,2).      %% 包序列号异常
-define(Logout_C2S_No_Role_Gen,3).        %% c2s route 的时候找不到角色进程

-define(Logout_Login_Auth_Fail,4).     %% 登陆验证失败
-define(Logout_Login_Params_Illegal,4).     %% 登陆失败,非法参数

-define(Logout_Create_Role_Params_Illegal,5).   %% 创角失败,非法参数

-define(Logout_Reconnect_Params_Illegal,6).     %% 重连失败,非法参数
-define(Logout_Reconnect_No_Role_Gen,6).        %% 重连的时候找不到角色进程
-define(Logout_Reconnect_No_Role_Data,6).       %% 重连的时候找不到角色数据

-define(Logout_Heartbeat_Timeout_Reach_Max,7).        %% 心跳超时达到上限

-endif.

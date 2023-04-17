%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_gw_route).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/login_pb.hrl").
-include("login.hrl").


%% API functions defined for gw_agent
-export([route_c2s/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% 新建gw进程，此时clientmid 为 notset，不需要检查clientmid
route_c2s({gw_c2s_handler,role_reconnect_c2s,C2SRD},_MsgId,ContextItem)->
  ?LOG_INFO({"role_reconnect_c2s",C2SRD}),
  #role_reconnect_c2s{client_mid=ClientMid,svr_mid = SvrMid,svr_id = SvrId,uid = UserId} = C2SRD,
  ContextItem_1 =
  case priv_check_reconnect_params(C2SRD,ContextItem) of
    ?TRUE ->
      ?LOG_INFO("role_reconnect_c2s 1111"),
      case  priv_do_reconnect({UserId,SvrId,ClientMid,SvrMid}) of
        {?OK,RoleId} ->
          ?LOG_INFO("role_reconnect_c2s 1122"),
          ContextItemTmp = role_gw_context:on_reconnect({SvrId,RoleId},ContextItem),
          ContextItemTmp;
        {?ERROR,Reason}->
          ?LOG_INFO("role_reconnect_c2s 1123"),
          role_gw_helper:cast_stop(Reason),
          ContextItem
      end;
    ?FALSE ->
      role_gw_helper:cast_stop(?Logout_Reconnect_Params_Illegal),
      ContextItem
  end,
  ContextItem_1;
%% 新建gw进程，此时clientmid 为 notset，不需要检查clientmid
route_c2s({gw_c2s_handler,role_login_c2s,C2SRD},_MsgId,ContextItem)->
  ?LOG_INFO({role_login_c2s,{C2SRD}}),
  #role_login_c2s{uid = UserId,uname = UserName,svrId = SvrId,
    plat = Platform,game_id = _GameId,machine_info = MachineInfo} = C2SRD,
  ContextItem_1 =
    case priv_check_user_login_params(C2SRD,ContextItem) of
      ?TRUE ->
        case role_create_mgr:raw_get_by_user(UserId,SvrId) of
          ?NOT_SET ->
            %% 登陆 不存在角色  通知客户端无角色，需要创建
            role_gw_helper:send_login_success(?FALSE),
            ContextItemTmp = role_gw_context:on_login({Platform,MachineInfo,SvrId,UserId,UserName,?NOT_SET},ContextItem),
            ContextItemTmp;
          RolePojo -> %% 登陆 存在角色
            role_gw_helper:send_login_success(?TRUE),
            RoleId = role_pdb_pojo:get_id(RolePojo),
            do_role_enter(RoleId),
            ContextItemTmp = role_gw_context:on_login({Platform,MachineInfo,SvrId,UserId,UserName,RoleId},ContextItem),
            ContextItemTmp
        end;
      ?FALSE ->
        role_gw_helper:cast_stop(?Logout_Login_Params_Illegal),
        ContextItem
    end,
  ContextItem_1;
%% 此时clientmid依旧 为 notset，不需要检查clientmid
route_c2s({gw_c2s_handler,create_role_c2s,C2SRD},_MsgId,ContextItem)->
  ?LOG_INFO({create_role_c2s,{C2SRD}}),
%%  #create_role_c2s{name = _Name,gender = _Gender} = C2SRD,
  ContextItem_1 =
    case priv_check_create_role_params(ContextItem) of
      ?TRUE ->
        case priv_do_create_role(C2SRD,ContextItem) of
          {?OK,NewRoleId} -> %% 创角成功
            role_gw_helper:send_create_role_s2c(?Create_Role_Success),
            do_role_enter(NewRoleId),
            ContextItemTmp = role_gw_context:on_new_role({NewRoleId},ContextItem),
            ContextItemTmp;
          {?ERROR, Reason}->
            role_gw_helper:send_create_role_s2c(Reason),    %% 创角失败，返回错误码，客户端需要重新发起创角请求
            ContextItem
        end;
      ?FALSE ->
        role_gw_helper:send_create_role_s2c(?Create_Role_Fail),    %% 通知客户端创角失败，客户端需要重新发起创角请求
        ContextItem
    end,
  ContextItem_1;

%% 重连成功后，要重置clientmid，保持前后端一致，
%% 这个mid是后端发给前端的，后端收到的，最后一次有效的mid
route_c2s({gw_c2s_handler,reset_gw_mid_c2s,C2SRD},_MsgId,ContextItem)->
  %% 要用reset_gw_mid_c2s协议里的mid，才是正确的需要同步的 mid
  SynClientMsgId = C2SRD#reset_gw_mid_c2s.mid,
  ?LOG_INFO({"gw_c2s_handler,reset_gw_mid_c2s,MsgId:", SynClientMsgId}),
  role_gw_pc_mgr:set_client_mid(SynClientMsgId),
  ContextItem;
route_c2s({unknown_c2s_handler,C2SId,C2SBinData},_MsgId,ContextItem)->
  ?LOG_INFO({"unknown_c2s_handler,C2SId,C2SBinData:",C2SId,C2SBinData}),
  ContextItem;

%% 心跳包和业务包一样，加入clientmid 的计数，这样客户端就可以统一，发送给服务端的所有包都加clientmid
route_c2s({gw_c2s_handler,avatar_heart_beat_c2s,_C2SRD},ClientMid,ContextItem)->
%%  ?LOG_INFO({"gw_c2s_handler ,avatar_heart_beat_c2s:"}),
  case role_gw_pc_mgr:check_client_mid(ClientMid) of
    ?TRUE ->
      role_gw_pc_mgr:set_client_mid(ClientMid),
      role_gw_pc_mgr:on_receive_heartbeat(),
      ?OK;
    _->
      role_gw_helper:cast_stop(?Logout_Mid_Error),
      ?OK
  end,
  ContextItem;
%% 业务包，需要检查 clientmid
route_c2s({MsgHandlerMod,MsgHandlerMethod,C2SRD}, ClientMid,ContextItem)->
  case role_gw_pc_mgr:check_client_mid(ClientMid) of
    ?TRUE ->
      role_gw_pc_mgr:set_client_mid(ClientMid),
      case role_gw_pc_mgr:get_role_gen() of
        RolePid when is_pid(RolePid) ->
          gs_role_online_mgr:route_c2s(RolePid,{ClientMid,MsgHandlerMod,MsgHandlerMethod,C2SRD}),
          ?OK;
        _Other ->
          role_gw_helper:cast_stop(?Logout_C2S_No_Role_Gen),
          ?OK
      end,
      ?OK;
    _->
      role_gw_helper:cast_stop(?Logout_Mid_Error),
      ?OK
  end,
  ContextItem.

priv_check_reconnect_params(#role_reconnect_c2s{uid = UserId},ContextItem)->
  role_gw_context:get_userId(ContextItem) == UserId.
priv_do_reconnect({UserId,SvrId,ClientMid,SvrMid})->
  Result =
    case role_create_mgr:raw_get_by_user(UserId,SvrId) of
      ?NOT_SET ->
        {?ERROR,?Logout_Reconnect_No_Role_Data};
      RolePojo ->
        RoleId = role_pdb_pojo:get_id(RolePojo),
        RolePid = gs_role_online_mgr:get_role_pid(RoleId),
        case yyu_pid:is_local_alive(RolePid) of
          ?TRUE ->
            %% 被RolePId监控，RolePId挂了当前进程也要被销毁
            priv_set_self_monitor_by(RolePid),
            ?OK = gs_role_online_mgr:call_reconnect(RolePid,self(),ClientMid,SvrMid),
            {?OK,RoleId};
          ?FALSE ->
            {?ERROR,?Logout_Reconnect_No_Role_Gen}
        end
    end,
  Result.

%% =================== 玩家登陆 开始  ==================================================
priv_check_user_login_params(#role_login_c2s{uid=UserId},ContextItem)->
  role_gw_context:get_userId(ContextItem) == UserId.
%% =================== 玩家登陆 开始  ==================================================

%% =================== 创建角色 开始  ==================================================
priv_check_create_role_params(ContextItem)->
  role_gw_context:get_svrId(ContextItem) =/= ?NOT_SET
    andalso role_gw_context:get_roleId(ContextItem) == ?NOT_SET.
priv_do_create_role(#create_role_c2s{name = Name,gender = Gender},ContextItem)->
  UserId = role_gw_context:get_userId(ContextItem),
  CreateItem = role_create_item:new_pojo(UserId,{Name,Gender}),
  case role_create_mgr:raw_create(CreateItem) of
    {?OK,RolePojo}->
      NewRoleId = role_pdb_pojo:get_id(RolePojo),
      {?OK,NewRoleId};
    _Other->
      {?ERROR,?Create_Role_Fail}
  end.
%% =================== 创建角色 结束  ==================================================

%% =================== 角色进入 开始  ==================================================
do_role_enter(RoleId)->
  TcpGen = self(),
  RolePid = gs_role_online_mgr:get_role_pid(RoleId),
  case yyu_pid:is_local_alive(RolePid) of
    ?TRUE ->
      ?LOG_INFO({"do_role_enter 20"}),
      priv_set_self_monitor_by(RolePid),
      ?OK = gs_role_online_mgr:call_re_login(RolePid,TcpGen),
      ?OK;
    ?FALSE ->
      NewPid = gs_role_online_mgr:new_child({RoleId,TcpGen}),
      priv_set_self_monitor_by(NewPid),
      ?OK = gs_role_online_mgr:call_login(NewPid),
      ?OK
  end,
  ?OK.
%% =================== 角色进入 结束  ==================================================

priv_set_self_monitor_by(RolePid)->
  yyu_pid:set_self_monitor_by(RolePid),
  role_gw_pc_mgr:set_role_gen(RolePid),
  ?OK.
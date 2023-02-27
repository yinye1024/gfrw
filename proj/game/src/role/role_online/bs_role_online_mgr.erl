%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_role_online_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(ACTIVE_S2CID,1).

%% API functions defined
-export([init/1, loop_5_seconds/0, persistent/0,terminate/1]).
-export([reconnect/1, route_c2s/1,send_msg/1]).
-export([login/1,re_login/1]).


%% ===================================================================================
%% API functions implements
%% =============================================================:======================
init({RoleId,TcpGen} = _GenArgs)->
  role_adm_mgr:init({RoleId,TcpGen}),
  role_proc_db:init(),
  role_pack_mgr:init(),

  gs_role_gen_life_cycle_mgr:data_load(),
  gs_role_gen_life_cycle_mgr:after_data_load(),

  role_online_gen_mgr:reg(RoleId,self()),
  ?OK.

loop_5_seconds()->
  gs_role_gen_life_cycle_mgr:loop_5_seconds(),
  ?OK.

persistent()->
  role_proc_db:update_to_db(),
  ?OK.

terminate(RoleId)->
  role_online_gen_mgr:un_reg(RoleId),
  role_proc_db:update_to_db(),
  ?OK.

send_msg({MsgId,C2SId,BinData})->
  ?LOG_INFO({"role send msg:",{MsgId,C2SId,BinData}}),
  RoleGen = role_adm_mgr:get_tcp_gen(),
  yynw_tcp_gw_api:send(RoleGen,{MsgId,C2SId,BinData}),
  ?OK.

reconnect({TcpGen,ClientMid,SvrMid})->
  ?LOG_INFO({"received reconnect from client:",{TcpGen,ClientMid,SvrMid}}),
  %% 重连是保持 clientmid 但重新建立tcp链接，要做tcp的切换
  role_adm_mgr:switch_tcp_gen(TcpGen),
  RoleId = role_adm_mgr:get_roleId(),
  role_pack_mgr:reconnect(RoleId,ClientMid,SvrMid), %% 补包
  ?OK.

login({})->
  %%  首次拉起玩家进程
  ?LOG_INFO({"login from client:" }),
  priv_do_login(),
  ?OK.

re_login({TcpGen})->
  ?LOG_INFO({"reLogin from client:",{TcpGen}}),
  %% 重登是新建立tcp链接，要做tcp的切换
  role_pack_mgr:reset(),
  role_adm_mgr:switch_tcp_gen(TcpGen),
  priv_do_login(),
  ?OK.

priv_do_login()->
  gs_role_gen_life_cycle_mgr:on_login(),
  RolePdbPojo = role_mgr:get_data(),
  role_s2c_handler:send_role_info_s2c(RolePdbPojo),%% 返回登陆角色信息给客户端
  ?OK.


%% debug 业务的时候，不需要打印log的请求可以在这里过滤，方便调试。
-define(Receive_Filter_List,
  [
    avatar_heart_beat_s2c
  ]
).
route_c2s({MsgId,MsgHandlerMod,MsgHandlerMethod,C2SRD})->
  ?LOG_INFO({"received msg from client:",{MsgHandlerMod,MsgHandlerMethod,C2SRD}}),
  ?IF(lists:member(element(1,C2SRD),?Receive_Filter_List),?OK,?LOG_DEBUG({"rep [RoleId,Data]",role_adm_mgr:get_roleId(),C2SRD})),
  try
    role_pack_mgr:mark_recv_pack(MsgId),
    MsgHandlerMod:MsgHandlerMethod(C2SRD)
  catch
      throw:done:Stacktrace  ->
        %% 业务层的中断操作，不需要处理
        role_utils:handle_done(Stacktrace),
        ?OK;
      Err:Reason:Stacktrace  ->
        role_utils:handle_error(Err,Reason,Stacktrace),
        ?OK
  end,
  ?OK.

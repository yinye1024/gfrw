%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_gw).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include("role/role_gw/login.hrl").


%% API functions defined for gw_agent
-export([new_data/0,get_mod/0]).
-export([get_active_pack_size/1,handle_active_pack/2,get_head_byte_length/1]).
-export([get_body_byte_length/2,route_c2s/2]).
-export([pack_send_data/2]).
-export([on_terminate/1]).
-export([get_heartbeat_check_time_span/1,check_heartbeat/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->
  ?MODULE.

%% GwData
new_data()->
  #{}.

%%======================= 激活包 处理 开始 ===================================================
%% 激活包长度 单位byte
get_active_pack_size(_GwData)->
  ?ActivePackByteLength.

%% return {ok,NewContextItem}
handle_active_pack(_PackData = <<UserId:?UserIdBitSize,Ticket:?TicketBitSize>>,_GwData)->
  ?LOG_INFO({"recive packet head {userId,ticket}:",{UserId,Ticket}}),
  role_gw_pc_mgr:init(),
  ContextItem = role_gw_pc_mgr:get_context(),
  case priv_check_auth(UserId,Ticket) of
    ?TRUE ->
      ContextItem_1 = role_gw_context:on_active({UserId,Ticket},ContextItem),
      role_gw_pc_mgr:set_context(ContextItem_1),
      Success = 1,
      role_gw_helper:send_connect_active_s2c(Success),
      ?OK;
    ?FALSE ->
      Fail = 0,
      role_gw_helper:send_connect_active_s2c(Fail),
      role_gw_helper:cast_stop(?Logout_Active_Auth_Fail),
      ?OK
  end,
  {?OK, _GwData}.
priv_check_auth(_UserId,_Ticket)->
  ?TRUE.
%%======================= 激活包 处理 结束 ===================================================


%%======================= 数据包 处理 开始 ===================================================

%% 包头长度
get_head_byte_length(_GwData)->
  ?HeadByteLength.

%% 包体长度
get_body_byte_length(HeadPack,_GwData)->
  <<Length:32>> = HeadPack,
  Length.

%% 业务分发
route_c2s(BodyPack,_GwData)->
  <<MsgId:16,C2SId:16,C2SData/bits>> = BodyPack,
  {MsgHandlerMod,MsgHandlerMethod,C2SRD} = cmd_map:decode_c2s(C2SId,C2SData),
  ContextItem = role_gw_pc_mgr:get_context(),
  ContextItem_1 =  role_gw_route:route_c2s({MsgHandlerMod,MsgHandlerMethod,C2SRD},MsgId,ContextItem),
  role_gw_pc_mgr:set_context(ContextItem_1),
  {?OK, _GwData}.



%%======================= 数据包 处理 开始 ===================================================


%%======================= 心跳 相关 开始 ===================================================
get_heartbeat_check_time_span(_GwData) ->
  60*1000. %% 心跳检查间隔 60秒

check_heartbeat(_GwData)->
  case role_gw_pc_mgr:is_max_heartbeat_time_out() of
    ?TRUE ->
      role_gw_helper:cast_stop(?Logout_Heartbeat_Timeout_Reach_Max),
      ?OK;
    ?FALSE ->
      role_gw_pc_mgr:check_heartbeat(),
      ?OK
  end,
  {?OK, _GwData}.
%%======================= 心跳 相关 结束 ===================================================

on_terminate(_GwData)->
  {?OK, _GwData}.

pack_send_data(BsData,_GwData)->
  {Mid, S2CId,BinData} = BsData,
  Data_Byte_Size = byte_size(BinData),
  Data_Bit_Size = Data_Byte_Size * 8,
  Data_Length = Data_Byte_Size + 4,
  BinToSend = <<Data_Length:32,Mid:16, S2CId:16,BinData:Data_Bit_Size/bits>>,
  BinToSend.





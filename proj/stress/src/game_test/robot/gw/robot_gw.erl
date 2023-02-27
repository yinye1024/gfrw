%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_gw).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game/include/login.hrl").


%% API functions defined
-export([new_data/1,get_mod/0]).
-export([get_active_pack/1,get_head_byte_length/1,get_body_byte_length/2]).
-export([pack_send_data/2, route_s2c/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->
  ?MODULE.

new_data(UserId)->
  robot_gw_data:new(UserId).



%%======================= 激活包 处理 开始 ===================================================
%% return ok or fail
get_active_pack(GwData)->
  UserId = robot_gw_data:get_userId(GwData),
  Ticket = 24324324324,
  <<UserId:?UserIdBitSize,Ticket:?TicketBitSize>>.

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
route_s2c(BodyPack,GwData)->
  <<SvrMsgId:16, S2CId:16, S2CData/bits>> = BodyPack,
  UserId = robot_gw_data:get_userId(GwData),
  gs_robot_mgr:route_s2c(UserId,{SvrMsgId, S2CId,S2CData}),
  ?OK.
%%======================= 数据包 处理 开始 ===================================================

pack_send_data(BsData,_GwData)->
  {Mid,C2SId,BinData} = BsData,
  Data_Byte_Size = byte_size(BinData),
  Data_Bit_Size = Data_Byte_Size * 8,
  Data_Length = Data_Byte_Size + 4,
  BinToSend = <<Data_Length:32,Mid:16,C2SId:16,BinData:Data_Bit_Size/bits>>,
  BinToSend.






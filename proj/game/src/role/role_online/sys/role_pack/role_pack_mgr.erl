%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_pack_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/login_pb.hrl").

-define(Queue_Length,100).  %% 保留发送包的长度
-define(Max_Miss,20).     %% 超过 Max_Miss 则直接重登，不进行补包操作
%% 不需要补包的协议在这里添加过滤
-define(Filter_S2C,[
   role_reconnect_s2c
  ,role_logout_s2c
%%  ,avatar_heartbeat_s2c
  ,tips_s2c
]).
%% API functions defined
-export([init/0, reset/0]).
-export([reconnect/3,mark_recv_pack/1,mark_send_pack/3]).

-export([test/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  role_pack_pc_dao:init(),
  ?OK.
reset()->
  role_pack_pc_dao:init(),
  ?OK.

%% ======================================= 重连 开始 =========================================================
reconnect(RoleId,ClientMid,SvrMid)->
  RoleId = role_adm_mgr:get_roleId(),
  Data = priv_get_data(),
  LastClientMId = role_pack_pc_pojo:get_recv_pack_id(Data),
  {L1,L2} = role_pack_pc_pojo:get_pack_queue(Data),
  case LastClientMId < ClientMid andalso ClientMid < LastClientMId + ?Max_Miss of
    ?TRUE ->
      case priv_get_pack_queue(SvrMid,L1,L2) of
        SendList when is_list(SendList)->
          priv_send_role_reconnect_s2c(?FALSE,?TRUE, LastClientMId), %% 需要补包-通知客户端正在发送同步包
          priv_send_packList(SendList);
        _->
          priv_send_role_reconnect_s2c(?FALSE,?FALSE, LastClientMId), %% 不需要补包
          ?OK
      end;
    _->
      priv_send_role_reconnect_s2c(?TRUE,?FALSE,0), %% 补包失败，通知客户端重新登陆
      ?OK
  end.

priv_get_pack_queue(SvrMid,L1,L2)->
  case priv_do_get_pack_queue(SvrMid,L1) of
    {?OK,SendList}-> SendList;
    _->
      case priv_do_get_pack_queue(SvrMid,L2) of
        {?OK,SendList}-> SendList++lists:reverse(L1);
        _->
          ?NOT_SET
      end
  end.

%% 根据SvrId获得需要同步的包列表
%%  return {ok, SendList}|?NOT_SET
priv_do_get_pack_queue(_SvrMid,[])->?NOT_SET;
priv_do_get_pack_queue(SvrMid,[{EndId,_,_}|_]=L)->
 Len = length(L),
  StartId = (EndId - Len + 1),
  case SvrMid >= StartId andalso SvrMid < EndId of
    ?TRUE ->
      RL = lists:reverse(L),
      {?OK,lists:sublist(RL,SvrMid-StartId+1,EndId-SvrMid)};
    _->
      ?NOT_SET
  end.
%% ======================================= 重连  结束 =========================================================

%% ======================================= 收包相关  开始 =========================================================
mark_recv_pack(ClientMid) ->
  Data = priv_get_data(),
  NewData = role_pack_pc_pojo:set_recv_pack_id(ClientMid,Data),
  priv_update(NewData).
%% ======================================= 收包相关  结束 =========================================================

%% ======================================= 收包相关  开始 =========================================================
%% 标记发送包
%% 返回当前计数值，不参与计数返回0
mark_send_pack(S2CId,PbufData, S2CRecordData)->
  ?LOG_INFO({S2CId,PbufData, S2CRecordData}),
  case lists:member(element(1, S2CRecordData),?Filter_S2C) of
    ?TRUE -> 0; %% 不计数 返回0
    ?FALSE->
      Data = priv_get_data(),
      {L1,L2} = role_pack_pc_pojo:get_pack_queue(Data),
      ReturnMid = priv_get_increment_id(L1,L2),  %% 序列号递增
      NewData =
      case length(L1) >= ?Queue_Length of
        ?TRUE ->
          NewQueueTmp = {[{ReturnMid,S2CId,PbufData}],L1},
          role_pack_pc_pojo:set_pack_queue(NewQueueTmp,Data);
        ?FALSE ->
          NewQueueTmp = {[{ReturnMid,S2CId,PbufData}|L1],L2},
          role_pack_pc_pojo:set_pack_queue(NewQueueTmp,Data)
      end,
      priv_update(NewData),
      ReturnMid
  end.

priv_get_increment_id([],[])->1;
priv_get_increment_id([{Id,_,_}|_L1],_L2)->
  Max = ?Queue_Length *2,
  Id rem Max+1;
priv_get_increment_id(_L1,[{Id,_,_}|_L2])->
  Max = ?Queue_Length *2,
  Id rem Max+1.
%% ======================================= 收包相关  结束 =========================================================
priv_send_packList(PackList)->
  role_inner_misc:inner_mark_send_RecordData(PackList).
%%
priv_send_role_reconnect_s2c(IsNeedLogin, HasPack,LastClientMId)->
  role_s2c_handler:send_role_reconnect_s2c(IsNeedLogin,HasPack, LastClientMId),
  ?OK.


priv_get_data()->
  Data = role_pack_pc_dao:get_data(),
  Data.

priv_update(Data)->
  role_pack_pc_dao:put_data(Data),
  ?OK.

test()->
  Rdb = {role_info_s2c,{p_roleInfo,1,<<"name_1002">>,1,1,1,1}},
  Result = lists:member(element(1, Rdb),?Filter_S2C),
  Result.

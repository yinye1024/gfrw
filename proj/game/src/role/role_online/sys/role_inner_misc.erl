%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 11. 1月 2023 15:26
%%%-------------------------------------------------------------------
-module(role_inner_misc).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/misc_pb.hrl").

%% API
-export([proc_init/0]).

-export([inner_mark_send_RecordData/1, inner_mark_send_RecordList/1]).
-export([inner_direct_send_pack/1]).
-export([send_error_code/1,send_error_code/2,send_error_code/3]).

proc_init()->
 yyu_proc_cache_dao:init(?MODULE),
  ?OK.

%% 玩家进程调用，可以减少一次进程消息发送，需要 计数，补包
inner_mark_send_RecordData(S2CRecordData)->
 {SvrMid,S2CId,PBufBin} = priv_mark_and_pack_data(S2CRecordData),
 TcpGen = role_adm_mgr:get_tcp_gen(),
 is_pid(TcpGen) andalso yynw_tcp_gw_api:send(TcpGen,{SvrMid,S2CId,PBufBin}).
priv_mark_and_pack_data(S2CRecordData) when is_tuple(S2CRecordData)->
 {S2CId, PBufBin} = cmd_map:encode_s2c(S2CRecordData),
 SvrMid = role_pack_mgr:mark_send_pack(S2CId, PBufBin, S2CRecordData),
 {SvrMid,S2CId, PBufBin}.

%% 一次打包好record列表，批量发送到网关进程,需要 计数，补包
inner_mark_send_RecordList(S2CDataList) when is_list(S2CDataList)->
 PackDataList = priv_mark_and_pack_list(S2CDataList,[]),
 TcpGen = role_adm_mgr:get_tcp_gen(),
 is_pid(TcpGen) andalso yynw_tcp_gw_api:send(TcpGen,PackDataList).
priv_mark_and_pack_list([S2CData|Less],AccList)->
 PackData = priv_mark_and_pack_data(S2CData),
 NewAccList = [PackData|AccList],
 priv_mark_and_pack_list(Less,NewAccList);
priv_mark_and_pack_list([],AccList)->
 AccList.


-define(Err_Code_Type_Wind,1). % 飘字
-define(Err_Code_Type_Scroll,2). % 滚动
-define(Err_Code_Type_MsgBox,3). % 提示框 无输入
-define(Err_Code_Type_Input_Box,4). % 提示框 有输入
%% 往前端发送错误码，type 是上面的错误码类型，id是配置表的Id主键，param是字符串（自己订规则，可以是json串）
send_error_code(Id)->
 %% 默认飘字 不带参数
 send_error_code(?Err_Code_Type_Wind,Id,""),
 ?OK.
send_error_code(Id,Param)->
 %% 默认飘字
 send_error_code(?Err_Code_Type_Wind,Id,Param),
 ?OK.
send_error_code(Type,Id,Param)->
 inner_mark_send_RecordData(#tips_s2c{msg = #p_msg{type = Type, id=Id, param = Param}}),
 ?OK.






%% 直接发送到网关进程，不计数，不补包
%% 比方战斗相关的数据包
inner_direct_send_pack(PBufPackData)->
 TcpGen = role_adm_mgr:get_tcp_gen(),
 is_pid(TcpGen) andalso yynw_tcp_gw_api:send(TcpGen,PBufPackData).
%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_res_c2s_sender).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/res_pb.hrl").
-include_lib("protobuf/include/cmd_map.hrl").

%% API functions defined
-export([res_list_bag_c2s/0,res_use_bagItem_c2s/2]).
-export([res_list_wallet_c2s/0,res_use_walletItem_c2s/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================


res_list_bag_c2s() ->
  Record = #res_list_bag_c2s{},

  BinData = res_pb:encode_msg(Record),
  {C2SId,BinData} = {?RES_LIST_BAG_C2S,BinData},
  ?LOG_INFO({"send res_list_bag_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.

res_use_bagItem_c2s(CfgId,Count) ->
  Record = #res_use_bag_item_c2s{cfg_id = CfgId,count = Count},
  BinData = res_pb:encode_msg(Record),
  {C2SId,BinData} = {?RES_USE_BAG_ITEM_C2S,BinData},
  ?LOG_INFO({"send res_use_bagItem_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.

res_list_wallet_c2s() ->
  Record = #res_list_bag_c2s{},

  BinData = res_pb:encode_msg(Record),
  {C2SId,BinData} = {?RES_LIST_WALLET_C2S,BinData},
  ?LOG_INFO({"send res_list_wallet_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.

res_use_walletItem_c2s(CfgId,Count) ->
  Record = #res_use_wallet_item_c2s{cfg_id = CfgId,count = Count},
  BinData = res_pb:encode_msg(Record),
  {C2SId,BinData} = {?RES_USE_WALLET_ITEM_C2S,BinData},
  ?LOG_INFO({"send res_use_walletItem_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.


%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_res_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/res_pb.hrl").


%% API functions defined

-export([res_list_bag_s2c/1, res_use_bagItem_s2c/1,res_list_wallet_s2c/1,res_use_walletItem_s2c/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
res_list_bag_s2c(BinData)->
  #res_list_bag_s2c{
    bagItem_list = BagItemList
  } = res_pb:decode_msg(BinData,res_list_bag_s2c),
  BsData = robot_res_data_mgr:get_data(),
  BsData_1 = robot_res_data:set_bagItem_list(BagItemList,BsData),
  robot_res_data_mgr:put_data(BsData_1),
  ?LOG_INFO({"res_list_bag_s2c,{bagItem_list}",{BagItemList}}),
  ?OK.

res_list_wallet_s2c(BinData)->
  #res_list_wallet_s2c{
    walletItem_list = WalletItemList
  } = res_pb:decode_msg(BinData,res_list_wallet_s2c),
  BsData = robot_res_data_mgr:get_data(),
  BsData_1 = robot_res_data:set_walletItem_list(WalletItemList,BsData),
  robot_res_data_mgr:put_data(BsData_1),
  ?LOG_INFO({"res_list_wallet_s2c,{walletItem_list}",{WalletItemList}}),
  ?OK.

res_use_bagItem_s2c(BinData)->
  #res_use_bagItem_s2c{
    success = IsSuccess
  } = res_pb:decode_msg(BinData,res_use_bagItem_s2c),

  ?LOG_INFO({"res_use_bagItem_s2c,{IsSuccess}",{IsSuccess}}),
  ?OK.

res_use_walletItem_s2c(BinData)->
  #res_use_walletItem_s2c{
    success = IsSuccess
  } = res_pb:decode_msg(BinData,res_use_walletItem_s2c),

  ?LOG_INFO({"res_use_walletItem_s2c,{IsSuccess}",{IsSuccess}}),
  ?OK.

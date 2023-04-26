%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(res_c2s_handler).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/res_pb.hrl").

%% API
-export([res_list_bag_c2s/1, res_list_wallet_c2s/1, res_use_bagItem_c2s/1,res_use_walletItem_c2s/1]).

res_list_bag_c2s(C2SRD = #res_list_bag_c2s{})->
  ?LOG_INFO({"res_list_bag_c2s,",C2SRD}),

  BagItemList = role_res_mgr:get_bag_itemList(),
  PBagItemList = res_pbuf_helper:to_p_bagItem_list(BagItemList),
  res_s2c_handler:res_list_bag_s2c(PBagItemList),
  ?OK.
res_list_wallet_c2s(C2SRD = #res_list_wallet_c2s{})->
  ?LOG_INFO({"res_list_wallet_c2s,",C2SRD}),

  WalletItemList = role_res_mgr:get_wallet_itemList(),
  PWalletItemList = res_pbuf_helper:to_p_walletItem_list(WalletItemList),
  res_s2c_handler:res_list_wallet_s2c(PWalletItemList),
  ?OK.

res_use_bagItem_c2s(C2SRD = #res_use_bagItem_c2s{cfg_id = CfgId,count = Count})->
  ?LOG_INFO({"res_use_bagItem_c2s,",C2SRD}),
  IsSuccess= role_res_mgr:use_bagItem(CfgId,Count),
  res_s2c_handler:res_use_bagItem_s2c(IsSuccess),
  ?OK.
res_use_walletItem_c2s(C2SRD = #res_use_walletItem_c2s{cfg_id = CfgId,count = Count})->
  ?LOG_INFO({"res_use_walletItem_c2s,",C2SRD}),

  IsSuccess = role_res_mgr:use_walletItem(CfgId,Count),
  res_s2c_handler:res_use_bagItem_s2c(IsSuccess),
  ?OK.


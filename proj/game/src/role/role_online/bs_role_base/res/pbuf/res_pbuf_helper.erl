%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(res_pbuf_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/res_pb.hrl").
%% API
-export([to_p_bagItem_list/1,to_p_walletItem_list/1]).

%% ApplyItem lc_res_apply_item
to_p_bagItem_list(BagItemList)->
  PResInfoList = yyu_list:map(fun(BagItem) -> priv_to_p_bagItem(BagItem) end, BagItemList),
  PResInfoList.

priv_to_p_bagItem(BagItem)->
  {RecordName, MapData, PBufPbMod} = {p_bag_item, BagItem,res_pb},
  RcData = map2record:to_record(RecordName, MapData, PBufPbMod),
  RcData.
to_p_walletItem_list(WalletItemList)->
  PResInfoList = yyu_list:map(fun(WalletItem) -> priv_to_p_walletItem(WalletItem) end, WalletItemList),
  PResInfoList.

priv_to_p_walletItem(WalletItem)->
  {RecordName, MapData, PBufPbMod} = {p_wallet_item, WalletItem,res_pb},
  RcData = map2record:to_record(RecordName, MapData, PBufPbMod),
  RcData.








%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(res_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/res_pb.hrl").
%% API
-export([res_list_bag_s2c/1,res_list_wallet_s2c/1, res_use_bag_item_s2c/1]).

res_list_bag_s2c(PBagItemList)->
  ?LOG_ERROR({"res_list_s2c ================ ", PBagItemList}),
  RCS2C = #res_list_bag_s2c{
    bagItem_list = PBagItemList
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).
res_list_wallet_s2c(PWalletItemList)->
  ?LOG_ERROR({"res_list_wallet_s2c ================ ", PWalletItemList}),
  RCS2C = #res_list_wallet_s2c{
    walletItem_list = PWalletItemList
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).

res_use_bag_item_s2c(IsSuccess)->
  RCS2C = #res_use_bag_item_s2c{
    success = IsSuccess
  },
  role_inner_misc:inner_mark_send_RecordData(RCS2C).

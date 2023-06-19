%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 23. 2月 2023 15:40
%%%-------------------------------------------------------------------
-module(ts_test_res).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/res_pb.hrl").

%% API
-export([do_test/0]).
%% ts_test_res:do_test().
do_test()->
  UserId = 1023,
  _RobotGenA = ts_helper:new_robot(UserId),
  yyu_time:sleep(1000),

%%  priv_test_bagItem(UserId),
  priv_test_walletItem(UserId),
  ?OK.

priv_test_bagItem(UserId)->
  {CfgId,Count} = {101,10},
  priv_gm_add_res(UserId,CfgId,Count),

  BagItemList = priv_get_bagItemList(UserId),
  BagItem = yyu_list:filter_one(fun(PBagItem) -> PBagItem#p_bag_item.cfgId == CfgId end, BagItemList),
  yyu_error:assert_true(BagItem =/= ?NOT_SET,"the BagItem not found"),

  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_res_mgr:res_use_bagItem_c2s/2, [CfgId,BagItem#p_bag_item.count-1]}),
  yyu_time:sleep(1000),

  BagItemList_1 = priv_get_bagItemList(UserId),
  BagItem_1 = yyu_list:filter_one(fun(PBagItem) -> PBagItem#p_bag_item.cfgId == CfgId end, BagItemList_1),

  CheckCount = BagItem_1#p_bag_item.count,
  yyu_error:assert_true(CheckCount == 1,{"the count is not right",CheckCount}),
  ?OK.
priv_gm_add_res(UserId,CfgId,Count)->
  StrCmd = "add_bag_item,"++yyu_misc:to_list(CfgId)++","++yyu_misc:to_list(Count)++"",
  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_gm_mgr:gm_cmd_c2s/1, [StrCmd]}),
  yyu_time:sleep(1000),
  ?OK.
priv_get_bagItemList(UserId)->
  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_res_mgr:res_list_bag_c2s/0, []}),
  yyu_time:sleep(1000),
  ResData = s2s_robot_mgr:call_do_fun(UserId, {fun robot_res_mgr:get_data/0, []}),
  BagItemList = robot_res_data:get_bagItem_list(ResData),
  BagItemList.



priv_test_walletItem(UserId)->
  {CfgId,Count} = {1,1000},
  priv_get_walletItemList(UserId),
  priv_gm_add_wallet(UserId,CfgId,Count),

  WalletItemList = priv_get_walletItemList(UserId),
  WalletItem = yyu_list:filter_one(fun(PWalletItem) -> PWalletItem#p_wallet_item.id == CfgId end, WalletItemList),
  yyu_error:assert_true(WalletItem =/= ?NOT_SET,"the WalletItem not found"),

  Total_1 = WalletItem#p_wallet_item.unbind_count+ WalletItem#p_wallet_item.bind_count,
  Cost = 19,

  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_res_mgr:res_use_walletItem_c2s/2, [CfgId,Cost]}),
  yyu_time:sleep(1000),

  WalletItemList_1 = priv_get_walletItemList(UserId),
  WalletItem_1 = yyu_list:filter_one(fun(PWalletItem) -> PWalletItem#p_wallet_item.id == CfgId end, WalletItemList_1),

  Total_2 = WalletItem_1#p_wallet_item.unbind_count+ WalletItem_1#p_wallet_item.bind_count,
  yyu_error:assert_true(Total_2 == (Total_1-Cost),{"the count is not right", {Total_1,Total_2,Cost}}),
  ?OK.
priv_gm_add_wallet(UserId,CfgId,Count)->
  StrCmd = "add_wallet_item,"++yyu_misc:to_list(CfgId)++","++yyu_misc:to_list(Count)++",false",
  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_gm_mgr:gm_cmd_c2s/1, [StrCmd]}),
  yyu_time:sleep(1000),
  ?OK.
priv_get_walletItemList(UserId)->
  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_res_mgr:res_list_wallet_c2s/0, []}),
  yyu_time:sleep(1000),
  ResData = s2s_robot_mgr:call_do_fun(UserId, {fun robot_res_mgr:get_data/0, []}),
  WalletItemList = robot_res_data:get_walletItem_list(ResData),
  WalletItemList.


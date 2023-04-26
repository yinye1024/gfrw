%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_res_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([res_list_bag_c2s/0, res_list_bag_s2c/1]).
-export([res_use_bagItem_c2s/2,res_use_bagItem_s2c/1]).
-export([res_list_wallet_c2s/0,res_list_wallet_s2c/1]).
-export([res_use_walletItem_c2s/2,res_use_walletItem_s2c/1]).
-export([get_data/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
res_list_bag_c2s() ->
  robot_res_c2s_sender:res_list_bag_c2s(),
  ?OK.
res_list_bag_s2c(BinData)->
  robot_res_s2c_handler:res_list_bag_s2c(BinData),
  ?OK.

res_use_bagItem_c2s(CfgId,Count)  ->
  robot_res_c2s_sender:res_use_bagItem_c2s(CfgId,Count),
  ?OK.
res_use_bagItem_s2c(BinData)  ->
  robot_res_s2c_handler:res_use_bagItem_s2c(BinData),
  ?OK.


res_list_wallet_c2s() ->
  robot_res_c2s_sender:res_list_wallet_c2s(),
  ?OK.
res_list_wallet_s2c(BinData)->
  robot_res_s2c_handler:res_list_wallet_s2c(BinData),
  ?OK.


res_use_walletItem_c2s(CfgId,Count)  ->
  robot_res_c2s_sender:res_use_walletItem_c2s(CfgId,Count),
  ?OK.
res_use_walletItem_s2c(BinData)  ->
  robot_res_s2c_handler:res_use_walletItem_s2c(BinData),
  ?OK.


get_data()->
  robot_res_data_mgr:get_data().

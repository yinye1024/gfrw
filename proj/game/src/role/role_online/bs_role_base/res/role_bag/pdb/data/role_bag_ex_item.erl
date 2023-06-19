%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_bag_ex_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/login_pb.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_add_item/2,new_cost_item/2]).
-export([get_cost_kv_list/1, get_add_kv_list/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_add_item(CfgId,Count)->
  NoExpired = -1,
  {MaxCount,IsBind,IsCanAcc,ExpiredTime} = {99,?FALSE,?TRUE,NoExpired},
  priv_new_item([],[{CfgId,Count,{MaxCount,IsBind,IsCanAcc,ExpiredTime} }]).

new_cost_item(CfgId,Count)->
  priv_new_item([{CfgId,Count}],[]).

priv_new_item(CostKvList,AddKvList)->
  #{
    cost_kv_list => CostKvList,   %% 消耗物品列表 [{CfgId,Count}...]
    add_kv_list => AddKvList      %% 添加物品列表 [{CfgId,Count，{MaxCount,IsBind,IsCanAcc,ExpiredTime}}...]
  }.

get_cost_kv_list(SelfMap) ->
  yyu_map:get_value(cost_kv_list, SelfMap).

get_add_kv_list(SelfMap) ->
  yyu_map:get_value(add_kv_list, SelfMap).


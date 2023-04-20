%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_tmp_bag_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_item/3]).
-export([get_id/1, get_on_fail_return/1, get_on_success_return/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_item(AutoId,OnFailReturn = {_BagExItemList,_WalletExItemList},OnSuccessReturn = {_BagExItemList_1,_WalletExItemList_1})->
  #{
    id => AutoId,
    on_fail_return => OnFailReturn,          %% 失败的时候执行，返回物品
    on_success_return => OnSuccessReturn     %% 成功的时候执行，返回物品
  }.



get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_on_fail_return(SelfMap) ->
  yyu_map:get_value(on_fail_return, SelfMap).

get_on_success_return(SelfMap) ->
  yyu_map:get_value(on_success_return, SelfMap).


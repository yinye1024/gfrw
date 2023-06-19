%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_res_data).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/0]).
-export([get_walletItem_list/1, set_walletItem_list/2]).
-export([get_bagItem_list/1, set_bagItem_list/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo()->
  #{
    walletItem_list => [],
    bagItem_list => []
  }.


get_walletItem_list(SelfMap) ->
  yyu_map:get_value(walletItem_list, SelfMap).

set_walletItem_list(Value, SelfMap) ->
  yyu_map:put_value(walletItem_list, Value, SelfMap).



get_bagItem_list(SelfMap) ->
  yyu_map:get_value(bagItem_list, SelfMap).

set_bagItem_list(Value, SelfMap) ->
  yyu_map:put_value(bagItem_list, Value, SelfMap).


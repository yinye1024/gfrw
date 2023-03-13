%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_lattice_rand_ext).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_item/2]).
-export([is_refresh_time/2,is_can_refresh/1,on_refresh/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_item(MaxRefreshCount,RefreshTimeSpan)->
  #{
    refresh_count => 0,
    max_refresh_count => MaxRefreshCount,
    refresh_time_span => RefreshTimeSpan,
    next_refresh_time => yyu_time:now_seconds()+ RefreshTimeSpan
  }.


%% ============================= 刷新相关 开始 ========================================================================
is_refresh_time(NowSec,ItemMap)->
  priv_get_next_refresh_time(ItemMap) < NowSec.

is_can_refresh(ItemMap)->
  get_refresh_count(ItemMap) < priv_get_max_refresh_count(ItemMap).

on_refresh(NowSec,ItemMap)->
  RefreshCount = get_refresh_count(ItemMap)+1,
  ItemMap_1 = priv_set_refresh_count(RefreshCount, ItemMap),
  NextRefreshTime = NowSec + priv_get_refresh_time_span(ItemMap),
  ItemMap_2 = priv_set_next_refresh_time(NextRefreshTime,ItemMap_1),
  ItemMap_2.

get_refresh_count(ItemMap) ->
  yyu_map:get_value(refresh_count, ItemMap).

priv_set_refresh_count(Value, ItemMap) ->
  yyu_map:put_value(refresh_count, Value, ItemMap).

priv_get_max_refresh_count(ItemMap) ->
  yyu_map:get_value(max_refresh_count, ItemMap).

priv_get_next_refresh_time(ItemMap) ->
  yyu_map:get_value(next_refresh_time, ItemMap).

priv_set_next_refresh_time(Value, ItemMap) ->
  yyu_map:put_value(next_refresh_time, Value, ItemMap).

priv_get_refresh_time_span(ItemMap) ->
  yyu_map:get_value(refresh_time_span, ItemMap).
%% ============================= 刷新相关 结束 ========================================================================
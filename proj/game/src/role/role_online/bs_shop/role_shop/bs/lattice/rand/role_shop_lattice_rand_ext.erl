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
is_refresh_time(NowSec,SelfMap)->
  priv_get_next_refresh_time(SelfMap) < NowSec.

is_can_refresh(SelfMap)->
  get_refresh_count(SelfMap) < priv_get_max_refresh_count(SelfMap).

on_refresh(NowSec,SelfMap)->
  RefreshCount = get_refresh_count(SelfMap)+1,
  SelfMap_1 = priv_set_refresh_count(RefreshCount, SelfMap),
  NextRefreshTime = NowSec + priv_get_refresh_time_span(SelfMap),
  SelfMap_2 = priv_set_next_refresh_time(NextRefreshTime,SelfMap_1),
  SelfMap_2.

get_refresh_count(SelfMap) ->
  yyu_map:get_value(refresh_count, SelfMap).

priv_set_refresh_count(Value, SelfMap) ->
  yyu_map:put_value(refresh_count, Value, SelfMap).

priv_get_max_refresh_count(SelfMap) ->
  yyu_map:get_value(max_refresh_count, SelfMap).

priv_get_next_refresh_time(SelfMap) ->
  yyu_map:get_value(next_refresh_time, SelfMap).

priv_set_next_refresh_time(Value, SelfMap) ->
  yyu_map:put_value(next_refresh_time, Value, SelfMap).

priv_get_refresh_time_span(SelfMap) ->
  yyu_map:get_value(refresh_time_span, SelfMap).
%% ============================= 刷新相关 结束 ========================================================================
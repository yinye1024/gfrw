%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_gw_pc_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/1]).
-export([get_id/1, get_client_mid/1, set_client_mid/2, get_role_gen/1,set_role_gen/2]).
-export([is_max_heartbeat_time_out/1,on_heartbeat/2,check_heartbeat/2]).
-export([get_context/1,set_context/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(DataId)->
  #{
    id => DataId,
    client_mid => ?NOT_SET,      %% 客户端mid，用来校验
    role_gen => ?NOT_SET,
    context =>role_gw_context:new(),

    time_out_count => 0,
    last_heartbeat => yyu_time:now_seconds()
  }.


get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_client_mid(ItemMap) ->
  yyu_map:get_value(client_mid, ItemMap).

set_client_mid(Value, ItemMap) ->
  yyu_map:put_value(client_mid, Value, ItemMap).

get_role_gen(ItemMap) ->
  yyu_map:get_value(role_gen, ItemMap).

set_role_gen(Value, ItemMap) ->
  yyu_map:put_value(role_gen, Value, ItemMap).


is_max_heartbeat_time_out(ItemMap)->
  MaxCount = 5,
  priv_get_time_out_count(ItemMap) > MaxCount.

on_heartbeat(NowTimeSecond,ItemMap)->
  ItemMap_1 = ItemMap#{
    time_out_count=>0,
    last_heartbeat=>NowTimeSecond
  },
  ItemMap_1.

check_heartbeat(NowTimeSecond,ItemMap)->
  LastHeartbeat = priv_get_last_heartbeat(ItemMap),
  TimeOutSecond = 60,
  ItemMap_1 =
  case NowTimeSecond - LastHeartbeat > TimeOutSecond of
    ?TRUE ->
      priv_incr_time_out_count(ItemMap);
    ?FALSE ->
      ItemMap
  end,
  ItemMap_1.

priv_incr_time_out_count(ItemMap) ->
  Cur = priv_get_time_out_count(ItemMap),
  priv_set_time_out_count(Cur+1, ItemMap).
priv_get_time_out_count(ItemMap) ->
  yyu_map:get_value(time_out_count, ItemMap).
priv_set_time_out_count(Value, ItemMap) ->
  yyu_map:put_value(time_out_count, Value, ItemMap).
priv_get_last_heartbeat(ItemMap) ->
  yyu_map:get_value(last_heartbeat, ItemMap).

get_context(ItemMap) ->
  yyu_map:get_value(context, ItemMap).

set_context(Value, ItemMap) ->
  yyu_map:put_value(context, Value, ItemMap).






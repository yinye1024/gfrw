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


get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_client_mid(SelfMap) ->
  yyu_map:get_value(client_mid, SelfMap).

set_client_mid(Value, SelfMap) ->
  yyu_map:put_value(client_mid, Value, SelfMap).

get_role_gen(SelfMap) ->
  yyu_map:get_value(role_gen, SelfMap).

set_role_gen(Value, SelfMap) ->
  yyu_map:put_value(role_gen, Value, SelfMap).


is_max_heartbeat_time_out(SelfMap)->
  MaxCount = 5,
  priv_get_time_out_count(SelfMap) > MaxCount.

on_heartbeat(NowTimeSecond,SelfMap)->
  SelfMap_1 = SelfMap#{
    time_out_count=>0,
    last_heartbeat=>NowTimeSecond
  },
  SelfMap_1.

check_heartbeat(NowTimeSecond,SelfMap)->
  LastHeartbeat = priv_get_last_heartbeat(SelfMap),
  TimeOutSecond = 60,
  SelfMap_1 =
  case NowTimeSecond - LastHeartbeat > TimeOutSecond of
    ?TRUE ->
      priv_incr_time_out_count(SelfMap);
    ?FALSE ->
      SelfMap
  end,
  SelfMap_1.

priv_incr_time_out_count(SelfMap) ->
  Cur = priv_get_time_out_count(SelfMap),
  priv_set_time_out_count(Cur+1, SelfMap).
priv_get_time_out_count(SelfMap) ->
  yyu_map:get_value(time_out_count, SelfMap).
priv_set_time_out_count(Value, SelfMap) ->
  yyu_map:put_value(time_out_count, Value, SelfMap).
priv_get_last_heartbeat(SelfMap) ->
  yyu_map:get_value(last_heartbeat, SelfMap).

get_context(SelfMap) ->
  yyu_map:get_value(context, SelfMap).

set_context(Value, SelfMap) ->
  yyu_map:put_value(context, Value, SelfMap).






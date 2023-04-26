%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_wallet_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/login_pb.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_item/1]).
-export([get_id/1,get_bind_count/1, get_unbind_count/1]).
-export([get_total_count/1,decr_count/2,add_bind_count/2,add_unbind_count/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_item(CfgId)->
  #{
    id => CfgId,
    bind_count => 0,
    unbind_count => 0
  }.

get_total_count(SelfMap) ->
  get_bind_count(SelfMap) + get_unbind_count(SelfMap).

%% 货币默认是先扣除绑定，再扣除非绑
decr_count(Delta,SelfMap)->
  {LeftCount,SelfMap_1} = priv_decr_bind_count(Delta,SelfMap),
  {LeftCount_1,SelfMap_2} =
  case LeftCount > 0 of
    ?TRUE -> priv_decr_unbind_count(LeftCount,SelfMap_1);
    ?FALSE ->
      {LeftCount,SelfMap_1}
  end,
  {LeftCount_1,SelfMap_2}.

get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_bind_count(SelfMap) ->
  yyu_map:get_value(bind_count, SelfMap).

add_bind_count(Delta,SelfMap)->
  Count_1 = get_bind_count(SelfMap)+Delta,
  Count_2 = ?IF(Count_1>?MAX_INT_64,?MAX_INT_64,Count_1),
  priv_set_bind_count(Count_2, SelfMap).

priv_decr_bind_count(Delta,SelfMap)->
  Count = get_bind_count(SelfMap),
  {LeftCount,SelfMap_1}=
  case Count >= Delta of
    ?TRUE ->
      {0,priv_set_bind_count(Count-Delta, SelfMap)};
    ?FALSE ->
      {Delta - Count,priv_set_bind_count(0, SelfMap)}
  end,
  {LeftCount,SelfMap_1}.


priv_set_bind_count(Value, SelfMap) ->
  yyu_map:put_value(bind_count, Value, SelfMap).

get_unbind_count(SelfMap) ->
  yyu_map:get_value(unbind_count, SelfMap).

add_unbind_count(Delta,SelfMap)->
  Count_1 = get_unbind_count(SelfMap)+Delta,
  Count_2 = ?IF(Count_1>?MAX_INT_64,?MAX_INT_64,Count_1),
  priv_set_unbind_count(Count_2, SelfMap).

priv_decr_unbind_count(Delta,SelfMap)->
  Count = get_unbind_count(SelfMap),
  {LeftCount,SelfMap_1}=
    case Count >= Delta of
      ?TRUE ->
        {0,priv_set_unbind_count(Count-Delta, SelfMap)};
      ?FALSE ->
        {Delta - Count,priv_set_unbind_count(0, SelfMap)}
    end,
  {LeftCount,SelfMap_1}.

priv_set_unbind_count(Value, SelfMap) ->
  yyu_map:put_value(unbind_count, Value, SelfMap).



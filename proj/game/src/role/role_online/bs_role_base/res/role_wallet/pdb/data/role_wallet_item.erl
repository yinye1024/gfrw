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

get_total_count(ItemMap) ->
  get_bind_count(ItemMap) + get_unbind_count(ItemMap).

decr_count(Delta,ItemMap)->
  {LeftCount,ItemMap_1} = priv_decr_bind_count(Delta,ItemMap),
  {LeftCount_1,ItemMap_2} =
  case LeftCount > 0 of
    ?TRUE -> priv_decr_unbind_count(LeftCount,ItemMap_1);
    ?FALSE ->
      {LeftCount,ItemMap_1}
  end,
  {LeftCount_1,ItemMap_2}.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_bind_count(ItemMap) ->
  yyu_map:get_value(bind_count, ItemMap).

add_bind_count(Delta,ItemMap)->
  Count_1 = get_bind_count(ItemMap)+Delta,
  Count_2 = ?IF(Count_1>?MAX_INT_64,?MAX_INT_64,Count_1),
  priv_set_bind_count(Count_2, ItemMap).

priv_decr_bind_count(Delta,ItemMap)->
  Count = get_bind_count(ItemMap),
  {LeftCount,ItemMap_1}=
  case Count >= Delta of
    ?TRUE ->
      {0,priv_set_bind_count(Count-Delta, ItemMap)};
    ?FALSE ->
      {Delta - Count,priv_set_bind_count(0, ItemMap)}
  end,
  {LeftCount,ItemMap_1}.


priv_set_bind_count(Value, ItemMap) ->
  yyu_map:put_value(bind_count, Value, ItemMap).

get_unbind_count(ItemMap) ->
  yyu_map:get_value(unbind_count, ItemMap).

add_unbind_count(Delta,ItemMap)->
  Count_1 = get_unbind_count(ItemMap)+Delta,
  Count_2 = ?IF(Count_1>?MAX_INT_64,?MAX_INT_64,Count_1),
  priv_set_unbind_count(Count_2, ItemMap).

priv_decr_unbind_count(Delta,ItemMap)->
  Count = get_unbind_count(ItemMap),
  {LeftCount,ItemMap_1}=
    case Count >= Delta of
      ?TRUE ->
        {0,priv_set_unbind_count(Count-Delta, ItemMap)};
      ?FALSE ->
        {Delta - Count,priv_set_unbind_count(0, ItemMap)}
    end,
  {LeftCount,ItemMap_1}.

priv_set_unbind_count(Value, ItemMap) ->
  yyu_map:put_value(unbind_count, Value, ItemMap).



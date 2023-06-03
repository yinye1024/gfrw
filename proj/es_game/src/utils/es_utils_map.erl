%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 25. 5月 2023 15:41
%%%-------------------------------------------------------------------
-module(es_utils_map).
-author("yinye").
-include("es_comm.hrl").

%% API
-export([new_map/0,put_value/3,get_value/2,get_value/3,get_value_list/2,remove/2,remove_all/2]).
-export([is_empty/1,has_key/2,size_of/1,all_values/1,all_keys/1,to_kv_list/1,from_kv_list/1,for_each/2,for_each/3]).

%% 连接到服务器，这个命令向stdout输出指令，然后在当前shell执行指令，
%% 要保持当前shell交互的时候用这个方法
new_map() ->
  maps:new().

put_value(Key,Value,Map)->
  maps:put(Key,Value,Map).

get_value(Key,Map)->
  case maps:find(Key,Map) of
    error ->
      ?NOT_SET;
    {?OK,Value}->
      Value
  end.
get_value(Key,DefaultValue,Map)->
  case maps:find(Key,Map) of
    error ->
      DefaultValue;
    {?OK,Value}->
      Value
  end.
get_value_list(KeyList,Map)->
  priv_get_value_list(KeyList,Map,[]).
priv_get_value_list([Key|Less],Map,AccList)->
  AccList_1 =
    case yyu_map:get_value(Key,Map) of
      ?NOT_SET -> AccList;
      Value ->
        [Value|AccList]
    end,
  priv_get_value_list(Less,Map,AccList_1);
priv_get_value_list([],_Map,AccList)->
  AccList.


remove(Key,Map)->
  NewMap = maps:remove(Key,Map),
  NewMap.
remove_all([Key|Less],Map)->
  NewMap = maps:remove(Key,Map),
  remove_all(Less,NewMap);
remove_all([],Map)->
  Map.

is_empty(Map)->
  Map == #{}.

has_key(Key,Map)->
  maps:is_key(Key,Map).

size_of(Map)->
  maps:size(Map).

all_keys(Map)->
  maps:keys(Map).
all_values(Map)->
  maps:values(Map).

to_kv_list(Map)->
  maps:to_list(Map).
from_kv_list(KvList)->
  maps:from_list(KvList).

for_each(Fun,Map)->
  for_each(Fun,?NOT_SET,Map).

for_each(Fun,Acc,Map)->
  maps:fold(Fun,Acc,Map).

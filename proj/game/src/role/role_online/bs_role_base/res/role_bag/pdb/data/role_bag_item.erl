%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_bag_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/login_pb.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_item/4]).
-export([get_id/1,get_cfgId/1,
  is_expired/2,get_expired_time/1,set_expired_time/2, is_bind/1,get_ext_info/1,set_ext_info/2]).
-export([priv_is_can_acc/1,is_can_add/1]).
-export([get_count/1,add_count/3,decr_count/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_item(ItemId,CfgId,{Count,MaxCount},{IsBind, IsCanAcc,ExpiredTime})->
  #{
    id => ItemId,
    cfgId => CfgId,
    count => Count,
    max_count => MaxCount,
    can_acc => IsCanAcc,           %% 是否可叠加
    expired_time => ExpiredTime,   %% ExpiredTime < 0 说明不会过期
    is_bind => IsBind,             %% 是否绑定
    ext_info => ?NOT_SET           %% 扩展信息，由每个业务层自己添加
  }.

get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_cfgId(SelfMap) ->
  yyu_map:get_value(cfgId, SelfMap).

is_can_add(SelfMap) ->
  priv_is_can_acc(SelfMap) andalso
  priv_get_max_count(SelfMap) > get_count(SelfMap).
priv_get_max_count(SelfMap) ->
  yyu_map:get_value(max_count, SelfMap).


add_count(Count,MaxCount,SelfMap)->
  CurCount = get_count(SelfMap),
  {LeftCount,SelfMap_1} =
  case CurCount + Count > MaxCount of
    ?TRUE ->
      {CurCount+Count-MaxCount, role_bag_item:priv_set_count(MaxCount, SelfMap)};
    ?FALSE ->
      {CurCount+Count-MaxCount, role_bag_item:priv_set_count(CurCount + Count, SelfMap)}
  end,
  {LeftCount,SelfMap_1}.

decr_count(DecrCount,SelfMap)->
  CurCount = get_count(SelfMap),
  {LeftDecrCount,SelfMap_1} =
  case CurCount > DecrCount of
    ?TRUE ->
      {0,priv_set_count(CurCount - DecrCount, SelfMap)};
    ?FALSE ->
      {DecrCount - CurCount,priv_set_count(0, SelfMap)}
  end,
  {LeftDecrCount,SelfMap_1}.

get_count(SelfMap) ->
  yyu_map:get_value(count, SelfMap).

priv_set_count(Value, SelfMap) ->
  yyu_map:put_value(count, Value, SelfMap).

is_expired(Now,SelfMap)->
  Now > get_expired_time(SelfMap).

get_expired_time(SelfMap) ->
  yyu_map:get_value(expired_time, SelfMap).

set_expired_time(Value, SelfMap) ->
  yyu_map:put_value(expired_time, Value, SelfMap).

is_bind(SelfMap) ->
  yyu_map:get_value(is_bind, SelfMap).

priv_is_can_acc(SelfMap) ->
  yyu_map:get_value(can_acc, SelfMap).

get_ext_info(SelfMap) ->
  yyu_map:get_value(ext_info, SelfMap).

set_ext_info(Value, SelfMap) ->
  yyu_map:put_value(ext_info, Value, SelfMap).


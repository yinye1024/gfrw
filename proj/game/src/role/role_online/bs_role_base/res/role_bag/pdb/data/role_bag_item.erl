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

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_cfgId(ItemMap) ->
  yyu_map:get_value(cfgId, ItemMap).

is_can_add(ItemMap) ->
  priv_is_can_acc(ItemMap) andalso
  priv_get_max_count(ItemMap) > get_count(ItemMap).
priv_get_max_count(ItemMap) ->
  yyu_map:get_value(max_count, ItemMap).


add_count(Count,MaxCount,ItemMap)->
  CurCount = get_count(ItemMap),
  {LeftCount,ItemMap_1} =
  case CurCount + Count > MaxCount of
    ?TRUE ->
      {CurCount+Count-MaxCount, role_bag_item:priv_set_count(MaxCount, ItemMap)};
    ?FALSE ->
      {CurCount+Count-MaxCount, role_bag_item:priv_set_count(CurCount + Count, ItemMap)}
  end,
  {LeftCount,ItemMap_1}.

decr_count(DecrCount,ItemMap)->
  CurCount = get_count(ItemMap),
  {LeftDecrCount,ItemMap_1} =
  case CurCount > DecrCount of
    ?TRUE ->
      {0,priv_set_count(CurCount - DecrCount, ItemMap)};
    ?FALSE ->
      {DecrCount - CurCount,priv_set_count(0, ItemMap)}
  end,
  {LeftDecrCount,ItemMap_1}.

get_count(ItemMap) ->
  yyu_map:get_value(count, ItemMap).

priv_set_count(Value, ItemMap) ->
  yyu_map:put_value(count, Value, ItemMap).

is_expired(Now,ItemMap)->
  Now > get_expired_time(ItemMap).

get_expired_time(ItemMap) ->
  yyu_map:get_value(expired_time, ItemMap).

set_expired_time(Value, ItemMap) ->
  yyu_map:put_value(expired_time, Value, ItemMap).

is_bind(ItemMap) ->
  yyu_map:get_value(is_bind, ItemMap).

priv_is_can_acc(ItemMap) ->
  yyu_map:get_value(can_acc, ItemMap).

get_ext_info(ItemMap) ->
  yyu_map:get_value(ext_info, ItemMap).

set_ext_info(Value, ItemMap) ->
  yyu_map:put_value(ext_info, Value, ItemMap).


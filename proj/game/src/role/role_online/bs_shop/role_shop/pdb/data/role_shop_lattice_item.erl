%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_lattice_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_item/3]).
-export([get_id/1, get_type/1,get_goodId/1]).
-export([get_ext_data/1,set_ext_data/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_item(ItemId,Type,{_MaxRefreshCount,_RefreshTimeSpan})->
  #{
    id => ItemId,
    type => Type,
    goodId => ?NOT_SET,

    ext_data =>?NOT_SET   %% 各种类型格子自己的扩展字段
  }.

get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).
get_type(SelfMap) ->
  yyu_map:get_value(type, SelfMap).
get_goodId(SelfMap) ->
  yyu_map:get_value(goodId, SelfMap).

get_ext_data(SelfMap) ->
  yyu_map:get_value(ext_data, SelfMap).

set_ext_data(Value, SelfMap) ->
  yyu_map:put_value(ext_data, Value, SelfMap).


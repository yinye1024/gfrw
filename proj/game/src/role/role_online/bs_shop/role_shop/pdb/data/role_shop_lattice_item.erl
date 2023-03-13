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
new_item(ItemId,Type,{MaxRefreshCount,RefreshTimeSpan})->
  #{
    id => ItemId,
    type => Type,
    goodId => ?NOT_SET,

    ext_data =>?NOT_SET   %% 各种类型格子自己的扩展字段
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).
get_type(ItemMap) ->
  yyu_map:get_value(type, ItemMap).
get_goodId(ItemMap) ->
  yyu_map:get_value(goodId, ItemMap).

get_ext_data(ItemMap) ->
  yyu_map:get_value(ext_data, ItemMap).

set_ext_data(Value, ItemMap) ->
  yyu_map:put_value(ext_data, Value, ItemMap).


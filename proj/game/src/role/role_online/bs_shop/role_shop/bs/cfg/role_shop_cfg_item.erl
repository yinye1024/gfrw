%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_cfg_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_from_cfg/1]).
-export([get_id/1,get_cfgId/1,get_type/1]).
-export([get_data/1,set_data/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_from_cfg(CfgId)->
  ShopType = ?NOT_SET,
  ShopId = ?NOT_SET,
  priv_new(ShopId,CfgId,ShopType).

priv_new(ShopId,CfgId,ShopType)->
  #{
    id => ShopId,
    cfgId => CfgId,
    type => ShopType,
    goodMap => yyu_map:new_map()
  }.

get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_cfgId(SelfMap) ->
  yyu_map:get_value(cfgId, SelfMap).

get_type(SelfMap) ->
  yyu_map:get_value(type, SelfMap).

get_data(SelfMap) ->
  yyu_map:get_value(data, SelfMap).

set_data(Value, SelfMap) ->
  yyu_map:put_value(data, Value, SelfMap).


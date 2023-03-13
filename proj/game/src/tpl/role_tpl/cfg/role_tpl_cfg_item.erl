%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_tpl_cfg_item).
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
  TplType = ?NOT_SET,
  TplId = ?NOT_SET,
  priv_new(TplId,CfgId,TplType).

priv_new(TplId,CfgId,TplType)->
  #{
    id => TplId,
    cfgId => CfgId,
    type => TplType,
    goodMap => yyu_map:new_map()
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_cfgId(ItemMap) ->
  yyu_map:get_value(cfgId, ItemMap).

get_type(ItemMap) ->
  yyu_map:get_value(type, ItemMap).

get_data(ItemMap) ->
  yyu_map:get_value(data, ItemMap).

set_data(Value, ItemMap) ->
  yyu_map:put_value(data, Value, ItemMap).


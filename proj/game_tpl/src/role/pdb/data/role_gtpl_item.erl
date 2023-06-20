%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_gtpl_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_item/2]).
-export([get_id/1,get_cfgId/1,get_type/1]).
-export([get_context/1, set_context/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_item(TplId,{TplType,CfgId})->
  #{
    id => TplId,
    cfgId => CfgId,
    type => TplType
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_cfgId(ItemMap) ->
  yyu_map:get_value(cfgId, ItemMap).

get_type(ItemMap) ->
  yyu_map:get_value(type, ItemMap).

get_context(ItemMap) ->
  yyu_map:get_value(context, ItemMap).

set_context(Value, ItemMap) ->
  yyu_map:put_value(context, Value, ItemMap).


%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(game_mongo_pc_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined

-export([new_pojo/2,get_id/1]).
-export([get_poolPid/1,set_poolPid/2]).
-export([get_mc_cfg/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(DataId,McCfg)->
  #{
    id => DataId,
    poolPid => ?NOT_SET,
    mc_cfg=>McCfg
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_poolPid(ItemMap) ->
  yyu_map:get_value(poolPid, ItemMap).

set_poolPid(Value, ItemMap) ->
  yyu_map:put_value(poolPid, Value, ItemMap).

get_mc_cfg(ItemMap) ->
  yyu_map:get_value(mc_cfg, ItemMap).
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

get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_poolPid(SelfMap) ->
  yyu_map:get_value(poolPid, SelfMap).

set_poolPid(Value, SelfMap) ->
  yyu_map:put_value(poolPid, Value, SelfMap).

get_mc_cfg(SelfMap) ->
  yyu_map:get_value(mc_cfg, SelfMap).
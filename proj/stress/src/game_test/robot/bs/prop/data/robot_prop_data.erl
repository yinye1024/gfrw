%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_prop_data).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/0]).
-export([get_prop_map/1, set_prop_map/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo()->
  #{
    prop_map=> yyu_map:new_map()
  }.


get_prop_map(ItemMap) ->
  yyu_map:get_value(prop_map, ItemMap).

set_prop_map(Value, ItemMap) ->
  yyu_map:put_value(prop_map, Value, ItemMap).


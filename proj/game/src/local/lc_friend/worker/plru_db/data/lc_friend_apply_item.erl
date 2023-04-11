%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_friend_apply_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/1]).
-export([get_index/1,set_index/2]).
-export([get_roleId/1, get_time/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    index=>?NOT_SET,
    roleId => RoleId,
    time => yyu_time:now_milliseconds()
  }.

get_index(ItemMap) ->
  yyu_map:get_value(index, ItemMap).

set_index(Value, ItemMap) ->
  yyu_map:put_value(index, Value, ItemMap).


get_roleId(ItemMap) ->
  yyu_map:get_value(roleId, ItemMap).

get_time(ItemMap) ->
  yyu_map:get_value(time, ItemMap).


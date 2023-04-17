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
-export([get_roleId/1, get_roleName/1,get_gender/1,get_time/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo({RoleId,Name,Gender})->
  #{
    index=>?NOT_SET,
    roleId => RoleId,
    roleName => Name,
    gender =>  Gender,
    time => yyu_time:now_milliseconds()
  }.

get_index(ItemMap) ->
  yyu_map:get_value(index, ItemMap).

set_index(Value, ItemMap) ->
  yyu_map:put_value(index, Value, ItemMap).


get_roleId(ItemMap) ->
  yyu_map:get_value(roleId, ItemMap).

get_roleName(ItemMap) ->
  yyu_map:get_value(roleName, ItemMap).
get_gender(ItemMap) ->
  yyu_map:get_value(gender, ItemMap).



get_time(ItemMap) ->
  yyu_map:get_value(time, ItemMap).


%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(glb_role_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_from_role/1,get_id/1,get_ver/1,incr_ver/1]).
-export([is_online/1,set_is_online/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_from_role(RolePdbPojo)->
  #{
    '_id' => role_pdb_pojo:get_id(RolePdbPojo),
    ver=>0,
    name => role_pdb_pojo:get_name(RolePdbPojo),
    gender =>role_pdb_pojo:get_gender(RolePdbPojo),
    is_online =>?FALSE
  }.

get_id(ItemMap) ->
  yyu_map:get_value('_id', ItemMap).

get_ver(ItemMap) ->
  yyu_map:get_value(ver, ItemMap).
incr_ver(ItemMap) ->
  CurVer = get_ver(ItemMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, ItemMap).

is_online(ItemMap) ->
  yyu_map:get_value(is_online, ItemMap).

set_is_online(Value, ItemMap) ->
  yyu_map:put_value(is_online, Value, ItemMap).


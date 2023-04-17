%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_role_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/1,update_from_role/3,get_id/1,get_ver/1,incr_ver/1]).
-export([is_online/1,set_is_online/2]).
-export([get_name/1, get_gender/1, get_head_id/1, get_head_border/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,
    ver=>0,
    name => ?NOT_SET,
    gender => ?NOT_SET,
    is_online =>?FALSE
  }.

update_from_role(RolePdbPojo, RoleAvatarPdbPojo,OldPojo)->
  OldPojo#{
    name => role_pdb_pojo:get_name(RolePdbPojo),
    gender =>role_pdb_pojo:get_gender(RolePdbPojo),
    head_id => role_avatar_pdb_pojo:get_headId(RoleAvatarPdbPojo),
    head_border => role_avatar_pdb_pojo:get_head_border(RoleAvatarPdbPojo)
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

get_name(ItemMap) ->
  yyu_map:get_value(name, ItemMap).

get_gender(ItemMap) ->
  yyu_map:get_value(gender, ItemMap).

get_head_id(ItemMap) ->
  yyu_map:get_value(head_id, ItemMap).

get_head_border(ItemMap) ->
  yyu_map:get_value(head_border, ItemMap).


%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_avatar_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/1,is_class/1,has_id/1,get_id/1,get_ver/1,incr_ver/1]).

-export([get_headId/1,set_headId/2, get_head_border/1,set_head_border/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,
    headId=>?NOT_SET,
    head_border => ?NOT_SET
  }.

is_class(ItemMap)->
  yyu_map:get_value(class,ItemMap) == ?Class.

has_id(ItemMap)->
  get_id(ItemMap) =/= ?NOT_SET.

get_id(ItemMap) ->
  yyu_map:get_value('_id', ItemMap).

get_ver(ItemMap) ->
  yyu_map:get_value(ver, ItemMap).
incr_ver(ItemMap) ->
  NewVer = get_ver(ItemMap)+1,
  yyu_map:put_value(ver, NewVer, ItemMap).


get_headId(ItemMap) ->
  yyu_map:get_value(headId, ItemMap).

set_headId(Value, ItemMap) ->
  yyu_map:put_value(headId, Value, ItemMap).

get_head_border(ItemMap) ->
  yyu_map:get_value(head_border, ItemMap).

set_head_border(Value, ItemMap) ->
  yyu_map:put_value(head_border, Value, ItemMap).


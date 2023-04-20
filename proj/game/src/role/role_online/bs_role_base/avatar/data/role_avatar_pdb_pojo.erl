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
    headId=>?NOT_SET,   %% 头像
    head_border => ?NOT_SET  %% 边框
  }.

is_class(SelfMap)->
  yyu_map:get_value(class,SelfMap) == ?Class.

has_id(SelfMap)->
  get_id(SelfMap) =/= ?NOT_SET.

get_id(SelfMap) ->
  yyu_map:get_value('_id', SelfMap).

get_ver(SelfMap) ->
  yyu_map:get_value(ver, SelfMap).
incr_ver(SelfMap) ->
  NewVer = get_ver(SelfMap)+1,
  yyu_map:put_value(ver, NewVer, SelfMap).


get_headId(SelfMap) ->
  yyu_map:get_value(headId, SelfMap).

set_headId(Value, SelfMap) ->
  yyu_map:put_value(headId, Value, SelfMap).

get_head_border(SelfMap) ->
  yyu_map:get_value(head_border, SelfMap).

set_head_border(Value, SelfMap) ->
  yyu_map:put_value(head_border, Value, SelfMap).


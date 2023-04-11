%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_tpl_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/1,get_id/1,get_ver/1,incr_ver/1]).
-export([is_online/1,set_is_online/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(Id)->
  #{
    '_id' => Id,ver=>0,class=>?MODULE,
    name => ?NOT_SET,
    gender =>?NOT_SET,
    is_online =>?FALSE
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
  CurVer = get_ver(ItemMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, ItemMap).

is_online(ItemMap) ->
  yyu_map:get_value(is_online, ItemMap).

set_is_online(Value, ItemMap) ->
  yyu_map:put_value(is_online, Value, ItemMap).


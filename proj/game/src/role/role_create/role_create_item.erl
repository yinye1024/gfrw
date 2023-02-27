%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_create_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/2,is_class/1]).
-export([get_userId/1, get_name/1, get_gender/1,get_create_info/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(UserId,{Name,Gender})->
  #{
    userId => UserId,
    name => Name,
    gender => Gender
  }.

is_class(ItemMap)->
  yyu_map:get_value(class,ItemMap) == ?Class.

get_userId(ItemMap) ->
  yyu_map:get_value(userId, ItemMap).

get_name(ItemMap) ->
  yyu_map:get_value(name, ItemMap).

get_gender(ItemMap) ->
  yyu_map:get_value(gender, ItemMap).

get_create_info(ItemMap) ->
  {get_name(ItemMap),get_gender(ItemMap)}.
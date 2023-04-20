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

is_class(SelfMap)->
  yyu_map:get_value(class,SelfMap) == ?Class.

get_userId(SelfMap) ->
  yyu_map:get_value(userId, SelfMap).

get_name(SelfMap) ->
  yyu_map:get_value(name, SelfMap).

get_gender(SelfMap) ->
  yyu_map:get_value(gender, SelfMap).

get_create_info(SelfMap) ->
  {get_name(SelfMap),get_gender(SelfMap)}.
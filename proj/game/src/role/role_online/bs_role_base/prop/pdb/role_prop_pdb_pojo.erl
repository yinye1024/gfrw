%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/1,is_class/1,has_id/1,get_id/1,get_ver/1,incr_ver/1]).
-export([get_active_heroIdList/1,set_active_heroIdList/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId)->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,
    active_heroIdList => []   %% 活跃英雄，登陆会做属性初始化
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

get_active_heroIdList(SelfMap) ->
  yyu_map:get_value(active_heroIdList, SelfMap).

set_active_heroIdList(Value, SelfMap) ->
  yyu_map:put_value(active_heroIdList, Value, SelfMap).





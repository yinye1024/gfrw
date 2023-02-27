%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(stress_adm_pc_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined

-export([new_pojo/1,get_id/1]).
-export([get_max_count/1,set_max_count/2, get_tps/1, set_tps/2, get_cur_count/1,set_cur_count/2]).
-export([incr_and_get_auto_user_id/1, set_auto_user_id/2]).
-export([get_robot_map/1,add_robot/3,remove_robot/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(DataId)->
  #{
    id => DataId,
    max_count => 0,       %% 总共创建多少用户
    tps => 0,             %% 每秒创建多少用户
    cur_count => 0,        %% 当前创建了多少用户
    auto_user_id => 0,     %% UserId

    robot_map=>yyu_map:new_map() %% <UserId,RobotGen>

  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_max_count(ItemMap) ->
  yyu_map:get_value(max_count, ItemMap).

set_max_count(Value, ItemMap) ->
  yyu_map:put_value(max_count, Value, ItemMap).

get_tps(ItemMap) ->
  yyu_map:get_value(tps, ItemMap).

set_tps(Value, ItemMap) ->
  yyu_map:put_value(tps, Value, ItemMap).

get_cur_count(ItemMap) ->
  yyu_map:get_value(cur_count, ItemMap).

set_cur_count(Value, ItemMap) ->
  yyu_map:put_value(cur_count, Value, ItemMap).

get_auto_user_id(ItemMap) ->
  yyu_map:get_value(auto_user_id, ItemMap).

incr_and_get_auto_user_id(ItemMap)->
  NewId = get_auto_user_id(ItemMap)+1,
  NewItemMap = set_auto_user_id(NewId, ItemMap),
  {NewId,NewItemMap}.

set_auto_user_id(Value, ItemMap) ->
  yyu_map:put_value(auto_user_id, Value, ItemMap).


add_robot(UserId,RobotGen,ItemMap)->
  Map = get_robot_map(ItemMap),
  NewMap = yyu_map:put_value(UserId,RobotGen,Map),
  NewItemMap = priv_set_robot_map(NewMap,ItemMap),
  NewItemMap.
remove_robot(UserId,ItemMap)->
  Map = get_robot_map(ItemMap),
  NewMap = yyu_map:remove(UserId,Map),
  NewItemMap = priv_set_robot_map(NewMap,ItemMap),
  NewItemMap.

get_robot_map(ItemMap) ->
  yyu_map:get_value(robot_map, ItemMap).

priv_set_robot_map(Value, ItemMap) ->
  yyu_map:put_value(robot_map, Value, ItemMap).


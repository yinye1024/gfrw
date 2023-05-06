%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_pc_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/2,get_id/1]).
-export([get_roleId/1]).
-export([get_hero_tree/2,put_hero_tree/2,rm_hero_tree/2,get_heroId_list/1]).
-export([get_player_tree/1,set_player_tree/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(DataId, RoleId)->
  #{
    id => DataId,
    roleId => RoleId,
    hero_tree_map => yyu_map:new_map(), %% 英雄属性 <HeroId,role_prop_tree_item>
    player_tree => ?NOT_SET             %% 玩家属性 role_prop_tree_item
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_roleId(ItemMap) ->
  yyu_map:get_value(roleId, ItemMap).

get_hero_tree(HeroId,SelfMap)->
  TreeMap = priv_get_hero_tree_map(SelfMap),
  yyu_map:get_value(HeroId,TreeMap).

put_hero_tree(HeroTree,SelfMap)->
  HeroId = role_prop_attr_item:get_id(HeroTree),
  TreeMap = priv_get_hero_tree_map(SelfMap),
  TreeMap_1 = yyu_map:put_value(HeroId,HeroTree,TreeMap),
  priv_set_hero_tree_map(TreeMap_1,SelfMap).

rm_hero_tree(HeroId,SelfMap)->
  TreeMap = priv_get_hero_tree_map(SelfMap),
  TreeMap_1 = yyu_map:remove(HeroId,TreeMap),
  priv_set_hero_tree_map(TreeMap_1,SelfMap).

get_heroId_list(SelfMap)->
  TreeMap = priv_get_hero_tree_map(SelfMap),
  yyu_map:all_keys(TreeMap).

priv_get_hero_tree_map(SelfMap) ->
  yyu_map:get_value(hero_tree_map, SelfMap).

priv_set_hero_tree_map(Value, SelfMap) ->
  yyu_map:put_value(hero_tree_map, Value, SelfMap).

get_player_tree(SelfMap) ->
  yyu_map:get_value(player_tree, SelfMap).

set_player_tree(Value, SelfMap) ->
  yyu_map:put_value(player_tree, Value, SelfMap).





%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([data_load/1,after_data_load/0,loop_5_seconds/0,save_active_heroIdList/0]).
-export([new_hero/1,
  check_and_update_all_hero/0,
  check_and_update_hero/1,
  get_hero_propMap/1,
  get_hero_propValue/2]).
-export([check_and_update_player/0,
  get_player_propValue/1,
  get_plyaer_propMap/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
data_load(RoleId)->
  role_prop_pdb_mgr:proc_init(RoleId),
  role_prop_pc_mgr:proc_init(RoleId),
  ?OK.
after_data_load()->
  %% 玩家属性树初始化
  role_prop_player_mgr:init_tree(),
  check_and_update_player(),
  %% 玩家英雄树初始化
  HeroIdList = role_prop_pdb_mgr:get_active_heroIdList(),
  role_prop_hero_mgr:new_treeList(HeroIdList),
  check_and_update_all_hero(),
  ?OK.

loop_5_seconds()->
  role_prop_hero_mgr:lru_lean(),
  ?OK.

save_active_heroIdList()->
  HeroIdList = role_prop_pc_mgr:get_heroId_list(),
  role_prop_pdb_mgr:save_active_heroIdList(HeroIdList),
  ?OK.

check_and_update_player()->
  role_prop_player_mgr:check_and_update_tree(),
  ?OK.
get_player_propValue(PropKey)->
  PropValue  = role_prop_player_mgr:get_effect_propValue(PropKey),
  PropValue.
get_plyaer_propMap()->
  PropMap = role_prop_player_mgr:get_effect_propMap(),
  PropMap.

new_hero(HeroId)->
  role_prop_hero_mgr:new_tree(HeroId),
  role_prop_hero_mgr:check_and_update_tree(HeroId),
  ?OK.
check_and_update_hero(HeroId)->
  role_prop_hero_mgr:check_and_update_tree(HeroId),
  ?OK.
check_and_update_all_hero()->
  role_prop_hero_mgr:check_and_update_all(),
  ?OK.
get_hero_propValue(PropKey,HeroId)->
  PropValue  = role_prop_hero_mgr:get_effect_propValue(PropKey,HeroId),
  PropValue.

get_hero_propMap(HeroId)->
  PropMap = role_prop_hero_mgr:get_effect_propMap(HeroId),
  PropMap.
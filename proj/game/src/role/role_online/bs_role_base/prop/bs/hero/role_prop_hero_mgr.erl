%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_hero_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_treeList/1,new_tree/1,check_and_update_all/0,check_and_update_tree/1]).
-export([get_effect_propMap/1, get_effect_propValue/2]).
-export([lru_lean/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_treeList(HeroIdList)->
  Fun = fun(HeroId) -> new_tree(HeroId),?OK end,
  yyu_list:foreach(Fun,HeroIdList),
  ?OK.

new_tree(HeroId)->
  HeroTree = role_prop_hero_tree_builder:new_tree(HeroId),
  role_prop_pc_mgr:put_hero_tree(HeroTree),
  ?OK.

check_and_update_all()->
  HeroIdList = role_prop_pc_mgr:get_heroId_list(),
  Fun = fun(HeroIdTmp) ->check_and_update_tree(HeroIdTmp),?OK end,
  yyu_list:foreach(Fun,HeroIdList),
  ?OK.

check_and_update_tree(HeroId)->
  Tree = role_prop_pc_mgr:get_hero_tree(HeroId),
  {IsUpdated,_UpdatedKeyList,Tree_1} = role_prop_tree_item:check_and_do_update(Tree),
  case IsUpdated of
    ?TRUE ->
      role_prop_pc_mgr:put_hero_tree(Tree_1),
      ?OK;
    ?FALSE ->
      ?OK
  end,
  ?OK.

get_effect_propValue(PropKey,HeroId)->
  Tree = role_prop_pc_mgr:get_hero_tree(HeroId),
  PropMap = get_effect_propMap(HeroId),
  PropValue = yyu_map:get_value(PropKey,PropMap),
  PropValue.

get_effect_propMap(HeroId)->
  Tree = role_prop_pc_mgr:get_hero_tree(HeroId),
  {_IsNeedUpdated,EffectPropMap,Tree_1} = role_prop_tree_item:get_effect_propMap(Tree),
  priv_update_touch_time(Tree_1),
  EffectPropMap.

lru_lean()->
  HeroIdList = role_prop_pc_mgr:get_heroId_list(),
  NowSec = yyu_time:now_seconds(),
  Fun = fun(HeroIdTmp) ->priv_lru_clean(NowSec,HeroIdTmp),?OK end,
  yyu_list:foreach(Fun,HeroIdList),
  ?OK.
priv_lru_clean(NowSec,HeroId)->
  Tree = role_prop_pc_mgr:get_hero_tree(HeroId),
  case role_prop_tree_item:is_expired(NowSec,Tree) of
    ?TRUE -> role_prop_pc_mgr:rm_hero_tree(HeroId);
    ?FALSE ->?OK
  end,
  ?OK.
priv_update_touch_time(HeroTree)->
  HeroTree_1 = role_prop_tree_item:set_last_touch_time(yyu_time:now_seconds(),HeroTree),
  role_prop_pc_mgr:put_hero_tree(HeroTree_1),
  ?OK.

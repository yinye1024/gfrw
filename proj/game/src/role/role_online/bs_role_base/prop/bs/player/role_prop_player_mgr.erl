%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_player_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init_tree/0]).
-export([get_effect_propValue/1, get_effect_propMap/1, get_effect_propMap/0]).
-export([check_and_update_tree/0]).
-export([set_gm_attr/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
init_tree()->
  PlayerTree = role_prop_player_tree_builder:new_tree(),
  role_prop_pc_mgr:put_player_tree(PlayerTree),
  ?OK.

get_effect_propValue(PropKey)->
  EffectPropMap = get_effect_propMap(),
  PropValue = yyu_map:get_value(PropKey, EffectPropMap),
  PropValue.

get_effect_propMap(PropKeyList)->
  EffectPropMap = get_effect_propMap(),
  Fun = fun(PropKey,AccPropMap) ->
          Value = yyu_map:get_value(PropKey,EffectPropMap),
          AccPropMap_1 = yyu_map:put_value(PropKey,Value,AccPropMap),
          AccPropMap_1
        end,
  EffectPropMap_1 = yyu_list:foreach(Fun, yyu_map:new_map(),PropKeyList),
  EffectPropMap_1.

get_effect_propMap()->
  Tree = role_prop_pc_mgr:get_player_tree(),
  {IsNeedUpdated,EffectPropMap,Tree_1} = role_prop_tree_item:get_effect_propMap(Tree),
  case IsNeedUpdated of
    ?TRUE -> role_prop_pc_mgr:put_player_tree(Tree_1),
      ?OK;
    ?FALSE ->?OK
  end,
  EffectPropMap.

check_and_update_tree()->
  Tree = role_prop_pc_mgr:get_player_tree(),
  {IsUpdated,UpdatedKeyList,Tree_1} = role_prop_tree_item:check_and_do_update(Tree),
  case IsUpdated of
    ?TRUE ->
      UpdatedValueKeyList = role_prop_attr_helper:to_value_keyList(UpdatedKeyList),
      role_prop_pc_mgr:put_player_tree(Tree_1),
      priv_notify_prop_changes(UpdatedValueKeyList),
      ?OK;
    ?FALSE ->
      ?OK
  end,
  ?OK.

set_gm_attr(PropMap)->
  role_prop_leaf_agent_PB_Gm:set_gm_attr(PropMap),
  ?OK.

priv_notify_prop_changes(PropKeyList) ->
  %% 通知相关业务，有属性值变化
  PropMap = get_effect_propMap(PropKeyList),
  PKVList = prop_pbuf_helper:to_p_prop_kv_list(yyu_map:to_kv_list(PropMap)),
  prop_s2c_handler:role_prop_player_changed_s2c(PKVList),
  ?OK.
%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_tree_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include("role/role_online/bs_role_base/prop/role_prop.hrl").

%% API functions defined
-export([new_pojo/2,new_pojo/3]).
-export([get_id/1, get_tree_type/1]).
-export([get_effect_value/2,get_effect_propMap/1,check_and_do_update/1]).
-export([add_node/2,get_node_attr/2]).
-export([set_last_touch_time/2,is_expired/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(TreeType,TreeId)->
  PropKeyList = ?NOT_SET,
  new_pojo(TreeType,TreeId,PropKeyList).
new_pojo(TreeType,TreeId,PropKeyList)->
  Context = role_prop_tree_context:new_pojo(TreeType, TreeId, PropKeyList),
  RootNode = role_prop_tree_node:new_node(?RPNodeId_Root),
  Context_1 = role_prop_tree_context:put_node(RootNode,Context),
  SelfMap = #{
    id=>TreeId,
    tree_type => TreeType,
    context => Context_1,
    effect_prop_item => ?NOT_SET,
    last_touch_time => yyu_time:now_seconds()
  },
  SelfMap.

get_effect_value(PropKey,SelfMap)->
  EffectPropMap = get_effect_propMap(SelfMap),
  yyu_map:get_value(PropKey,EffectPropMap).

get_effect_propMap(SelfMap)->
  RootNode = priv_get_root_node(SelfMap),
  RootAttrItem = role_prop_tree_node:get_attr(RootNode),
  EffectPropItem = priv_get_effect_prop_item(SelfMap),
  {EffectPropMap,SelfMap_1} =
  case priv_is_need_reCal(RootAttrItem,EffectPropItem)  of
    ?TRUE ->
      EffectPropItemTmp = role_prop_attr_effect_prop_item:new_pojo(RootAttrItem),
      SelfMapTmp = priv_set_effect_prop_item(EffectPropItemTmp, SelfMap),
      EffectPropMapTmp = role_prop_attr_effect_prop_item:get_effect_prop_map(EffectPropItemTmp),
      {EffectPropMapTmp,SelfMapTmp};
    ?FALSE ->
      EffectPropMapTmp = role_prop_attr_effect_prop_item:get_effect_prop_map(EffectPropItem),
      {EffectPropMapTmp,?NOT_SET}
  end,
  IsNeedUpdated = (SelfMap_1==?NOT_SET),
  {IsNeedUpdated,EffectPropMap,SelfMap_1}.

priv_is_need_reCal(RootAttrItem,EffectPropItem)->
  EffectPropItem == ?NOT_SET orelse
  role_prop_attr_effect_prop_item:get_attr_item_ver(EffectPropItem) =/= role_prop_attr_item:get_ver(RootAttrItem).

priv_get_effect_prop_item(SelfMap) ->
  yyu_map:get_value(effect_prop_item, SelfMap).

priv_set_effect_prop_item(Value, SelfMap) ->
  yyu_map:put_value(effect_prop_item, Value, SelfMap).




check_and_do_update(SelfMap)->
  RootNode = priv_get_root_node(SelfMap),
  Context = priv_get_context(SelfMap),
  {IsUpdated,UpdatedKeyList,Context_1} = role_prop_tree_node:check_and_do_update(Context,RootNode),
  SelfMap_1 = ?IF(IsUpdated,priv_set_context(Context_1,SelfMap),SelfMap),
  {IsUpdated,UpdatedKeyList,SelfMap_1}.

get_node_attr(NodeId,SelfMap)->
  Context = priv_get_context(SelfMap),
  TreeNode = role_prop_tree_context:get_node(NodeId,Context),
  role_prop_tree_node:get_attr(TreeNode).

add_node({TreeNode, ParentNodeId},SelfMap)->
  Context = priv_get_context(SelfMap),
  Context_1 =
  case role_prop_tree_context:get_node(ParentNodeId,Context) of
    ?NOT_SET ->
      yyu_error:throw_error({"parent node not found",TreeNode,ParentNodeId,Context}),
      Context;
    PNode ->
      PNode_1 = role_prop_tree_node:put_childNode(TreeNode,PNode),
      ContextTmp_1 = role_prop_tree_context:put_node(PNode_1,Context),
      ContextTmp_2 = role_prop_tree_context:put_node(TreeNode,ContextTmp_1),
      ContextTmp_2
  end,
  priv_set_context(Context_1,SelfMap).


get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_tree_type(SelfMap) ->
  yyu_map:get_value(tree_type, SelfMap).

priv_get_root_node(SelfMap)->
  Context = priv_get_context(SelfMap),
  role_prop_tree_context:get_node(?RPNodeId_Root,Context).

priv_get_context(SelfMap) ->
  yyu_map:get_value(context, SelfMap).

priv_set_context(Value, SelfMap) ->
  yyu_map:put_value(context, Value, SelfMap).

is_expired(NowSec,SelfMap)->
  LastTouchTime = priv_get_last_touch_time(SelfMap),
  ExpiredTime = 3600,
  NowSec > LastTouchTime+ ExpiredTime.

priv_get_last_touch_time(SelfMap) ->
  yyu_map:get_value(last_touch_time, SelfMap).

set_last_touch_time(Value, SelfMap) ->
  yyu_map:put_value(last_touch_time, Value, SelfMap).


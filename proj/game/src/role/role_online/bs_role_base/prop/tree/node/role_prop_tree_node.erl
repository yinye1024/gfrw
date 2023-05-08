%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_tree_node).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_leaf/1,new_node/1]).
-export([get_id/1,is_leaf/1]).
-export([get_attr/1,get_attr_ver/1]).
-export([check_and_do_update/2,put_childNode/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_leaf(LeafAgent)->
  NodeId = role_prop_tree_leaf_agent:get_id(LeafAgent),
  #{
    id=>NodeId,
    is_leaf => ?TRUE,
    leaf_agent => LeafAgent,
    last_attr => role_prop_attr_item:new_pojo(NodeId)   %% 叶节点才有 这个属性
  }.
new_node(NodeId)->
  #{
    id=>NodeId,
    is_leaf => ?FALSE,
    cur_attr => role_prop_attr_item:new_pojo(NodeId),   %% 父节点才有这个属性
    childNodeIdMap=> yyu_map:new_map()   %%<NodeId,1>
  }.

check_and_do_update(TreeContext,SelfMap)->
  {IsUpdated, UpdatedKeyList,TreeContext_1} =
  case is_leaf(SelfMap) of
    ?TRUE -> priv_check_and_do_update_leaf(TreeContext,SelfMap);
    ?FALSE -> priv_check_and_do_update_node(TreeContext,SelfMap)
  end,
  {IsUpdated, UpdatedKeyList,TreeContext_1}.

priv_check_and_do_update_leaf(TreeContext,SelfMap)->
  LeafAgent = priv_get_leaf_agent(SelfMap),
  LastAttrItem = priv_get_last_attr(SelfMap),
  LastVer = role_prop_attr_item:get_ver(LastAttrItem),

  {IsUpdated,UpdatedKeyList_1,TreeContext_1} =
    case role_prop_tree_leaf_agent:get_attr(LastVer,TreeContext,LeafAgent) of
      ?NO_CHANGE -> {?FALSE,[],TreeContext};
      ?NOT_SET -> {?FALSE,[],TreeContext};
      NewAttrItem->
        UpdatedPropMapTmp = role_prop_attr_item:get_updated_propMap(LastAttrItem,NewAttrItem),
        SelfMap_1 = priv_set_last_attr(NewAttrItem,SelfMap),
        TreeContextTmp = role_prop_tree_context:put_node(SelfMap_1,TreeContext),
        {?TRUE,yyu_map:all_keys(UpdatedPropMapTmp),TreeContextTmp}
    end,
  {IsUpdated,UpdatedKeyList_1,TreeContext_1}.
priv_get_leaf_agent(SelfMap) ->
  yyu_map:get_value(leaf_agent, SelfMap).


priv_check_and_do_update_node(TreeContext,SelfMap)->
  ChildNodeIdMap = priv_get_childNodeIdMap(SelfMap),
  ChildNodeIdList = yyu_map:all_keys(ChildNodeIdMap),

  {IsUpdated,UpdatedKeyList_1,TreeContext_1} =
  case priv_check_and_update_childList(ChildNodeIdList,{?FALSE,[],TreeContext}) of
    {?TRUE,UpdatedKeyList,TreeContextTmp}->
      UpdatedPropMap = priv_sum_propMap(ChildNodeIdList,{UpdatedKeyList,TreeContextTmp},yyu_map:new_map()),
      RmPropKeyList = priv_filter_rmKeys(UpdatedKeyList,UpdatedPropMap),

      CurAttrItem = priv_get_cur_attr(SelfMap),
      CurAttrItem_1 = role_prop_attr_item:put_propMap(UpdatedPropMap,CurAttrItem),
      CurAttrItem_2 = role_prop_attr_item:rm_by_keys(RmPropKeyList,CurAttrItem_1),
      CurAttrItem_3 = role_prop_attr_item:incr_ver(CurAttrItem_2),

      SelfMap_1 = priv_set_cur_attr(CurAttrItem_3,SelfMap),
      TreeContextTmp_1 = role_prop_tree_context:put_node(SelfMap_1,TreeContextTmp),
      {?TRUE,UpdatedKeyList,TreeContextTmp_1};
    {?FALSE,_,_}->
      {?TRUE,[],TreeContext}
  end,
  {IsUpdated,UpdatedKeyList_1,TreeContext_1}.


priv_check_and_update_childList([ChildNodeId|Less],{AccIsUpdated,AccUpdatedKeyList,AccTreeContext})->
  ChildNode = role_prop_tree_context:get_node(ChildNodeId,AccTreeContext),
  {IsUpdated,UpdatedKeyList,AccTreeContext_1} = check_and_do_update(AccTreeContext,ChildNode),

  %% 有一个child更新就认为是有更新
  AccIsUpdated_1 = AccIsUpdated orelse IsUpdated,
  AccUpdatedKeyList_1 = yyu_list:union_add_all(UpdatedKeyList,AccUpdatedKeyList),
  priv_check_and_update_childList(Less,{AccIsUpdated_1,AccUpdatedKeyList_1,AccTreeContext_1});
priv_check_and_update_childList([],{AccIsUpdated,AccUpdatedKeyList,AccTreeContext})->
  {AccIsUpdated,AccUpdatedKeyList,AccTreeContext}.


%% 根据变化的key列表，把所有的子节点加一次
priv_sum_propMap([ChildNodeId|Less],{UpdatedKeyList,TreeContext},AccPropMap)->
  ChildNode = role_prop_tree_context:get_node(ChildNodeId,TreeContext),
  AttrItem = role_prop_tree_node:get_attr(ChildNode),
  ItemPropMap = role_prop_attr_item:get_prop_map(AttrItem),
  AccPropMap_1 = priv_sum_propMap_by_keyList(UpdatedKeyList,ItemPropMap,AccPropMap),
  priv_sum_propMap(Less,{UpdatedKeyList,TreeContext},AccPropMap_1);
priv_sum_propMap([],{_UpdatedKeyList,_TreeContext},AccPropMap)->
  AccPropMap.

priv_sum_propMap_by_keyList([UpdatedKey|Less],ItemPropMap,AccPropMap)->
  AccPropMap_1 =
  case {yyu_map:get_value(UpdatedKey,ItemPropMap),yyu_map:get_value(UpdatedKey,AccPropMap)} of
    {?NOT_SET,?NOT_SET}->AccPropMap;
    {?NOT_SET,_AccValueTmp}->AccPropMap;
    {ItemValueTmp,?NOT_SET}->
      yyu_map:put_value(UpdatedKey,ItemValueTmp,AccPropMap);
    {ItemValueTmp,AccValueTmp}->
      NewValue = ItemValueTmp + AccValueTmp,
      yyu_map:put_value(UpdatedKey,NewValue,AccPropMap)
  end,
  priv_sum_propMap_by_keyList(Less,ItemPropMap,AccPropMap_1);
priv_sum_propMap_by_keyList([],_ItemPropMap,AccPropMap)->
  AccPropMap.

priv_filter_rmKeys(PropKeyList,PropMap)->
  FilterFun = fun(PropKey) -> not yyu_map:has_key(PropKey,PropMap)  end,
  RmKeyList = yyu_list:filter(FilterFun,PropKeyList),
  RmKeyList.


get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

is_leaf(SelfMap) ->
  yyu_map:get_value(is_leaf, SelfMap).

get_attr(SelfMap)->
  AttrItem  =
  case is_leaf(SelfMap) of
    ?TRUE ->
      priv_get_last_attr(SelfMap);
    ?FALSE ->
      priv_get_cur_attr(SelfMap)
  end,
  AttrItem.
get_attr_ver(SelfMap)->
  AttrItem = get_attr(SelfMap),
  role_prop_attr_item:get_ver(AttrItem).

priv_get_last_attr(SelfMap) ->
  yyu_map:get_value(last_attr, SelfMap).

priv_set_last_attr(Value, SelfMap) ->
  yyu_map:put_value(last_attr, Value, SelfMap).

priv_get_cur_attr(SelfMap) ->
  yyu_map:get_value(cur_attr, SelfMap).

priv_set_cur_attr(Value, SelfMap) ->
  yyu_map:put_value(cur_attr, Value, SelfMap).

put_childNode(ChildNode,SelfMap)->
  NodeId = role_prop_tree_node:get_id(ChildNode),
  NodeIdMap = priv_get_childNodeIdMap(SelfMap),
  NodeIdMap_1 = yyu_map:put_value(NodeId,1,NodeIdMap),
  priv_set_childNodeIdMap(NodeIdMap_1,SelfMap).

priv_get_childNodeIdMap(SelfMap) ->
  yyu_map:get_value(childNodeIdMap, SelfMap).

priv_set_childNodeIdMap(Value, SelfMap) ->
  yyu_map:put_value(childNodeIdMap, Value, SelfMap).


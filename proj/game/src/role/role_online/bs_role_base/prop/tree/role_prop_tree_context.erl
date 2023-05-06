%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_tree_context).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_pojo/3]).
-export([get_id/1, get_tree_type/1,get_include_key_list/1]).
-export([get_node/2,put_node/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(TreeType,TreeId,PropKeyList)->
  #{
    id=>TreeId,
    tree_type => TreeType,
    node_map => yyu_map:new_map(), %% <NodeId,role_prop_tree_node>
    include_key_list => PropKeyList  %% 这棵树包含了哪些属性值，?NOT_SET 包含全部
  }.

get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_tree_type(SelfMap) ->
  yyu_map:get_value(tree_type, SelfMap).

get_include_key_list(SelfMap) ->
  yyu_map:get_value(include_key_list, SelfMap).

put_node(TreeNode,SelfMap)->
  NodeMap = priv_get_node_map(SelfMap),
  NodeId = role_prop_tree_node:get_id(TreeNode),
  NodeMap_1 = yyu_map:put_value(NodeId,TreeNode,NodeMap),
  priv_set_node_map(NodeMap_1,SelfMap).

get_node(NodeId,SelfMap)->
  NodeMap = priv_get_node_map(SelfMap),
  yyu_map:get_value(NodeId,NodeMap).

priv_get_node_map(SelfMap) ->
  yyu_map:get_value(node_map, SelfMap).

priv_set_node_map(Value, SelfMap) ->
  yyu_map:put_value(node_map, Value, SelfMap).


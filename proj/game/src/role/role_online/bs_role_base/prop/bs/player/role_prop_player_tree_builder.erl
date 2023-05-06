%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_player_tree_builder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include("role/role_online/bs_role_base/prop/role_prop.hrl").

%% API functions defined
-export([new_tree/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_tree()->
  {TreeType,TreeId} = {?RP_TreeType_Player,1},
  Tree = role_prop_tree_item:new_pojo(TreeType,TreeId),
  Tree_1 = priv_add_fb_node(Tree),
  Tree_2 = priv_add_pb_node(Tree_1),
  Tree_2.

priv_add_fb_node(Tree) ->
  Tree_1 = role_prop_tree_item:add_node({role_prop_tree_node:new_node(?RPNodeId_PNode_FB),?RPNodeId_Root},Tree),
  Tree_2 = role_prop_tree_item:add_node({role_prop_leaf_agent_FB_City:new_leaf(),?RPNodeId_PNode_FB},Tree_1),
  Tree_3 = role_prop_tree_item:add_node({role_prop_leaf_agent_FB_Tech:new_leaf(),?RPNodeId_PNode_FB},Tree_2),
  Tree_3.

priv_add_pb_node(Tree) ->
  Tree_1 = role_prop_tree_item:add_node({role_prop_tree_node:new_node(?RPNodeId_PNode_PB),?RPNodeId_Root},Tree),

  LeafList = [
      role_prop_leaf_agent_PB_Gm:new_leaf(),
      role_prop_leaf_agent_PB_Base:new_leaf(),
      role_prop_leaf_agent_PB_Home:new_leaf(),
      role_prop_leaf_agent_PB_Master:new_leaf()
  ],

  Fun = fun(LeafTmp,AccTree) ->
          AccTree_1 = role_prop_tree_item:add_node({LeafTmp,?RPNodeId_PNode_PB},AccTree),
          AccTree_1
        end,
  Tree_2 = yyu_list:foreach(Fun, Tree_1,LeafList),
  Tree_2.

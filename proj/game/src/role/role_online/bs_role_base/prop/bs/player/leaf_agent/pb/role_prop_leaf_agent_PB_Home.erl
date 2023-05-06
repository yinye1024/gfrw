%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_leaf_agent_PB_Home).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include("role/role_online/bs_role_base/prop/role_prop.hrl").

%% API functions defined
-export([new_leaf/0,get_attr/3]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_leaf()->
  {NodeId,AgentMod} = {?RPNodeId_Leaf_PB_Home,?MODULE},
  LeafAgent = role_prop_tree_leaf_agent:new_pojo(NodeId,AgentMod),
  role_prop_tree_node:new_leaf(LeafAgent).

get_attr(_LastVer,_TreeContext,_NodeId)->
  ?NOT_SET.





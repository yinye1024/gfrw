%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_leaf_agent_PB_Gm).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include("role/role_online/bs_role_base/prop/role_prop.hrl").

-define(ProcId,?MODULE).
-define(DataId,1).

%% API functions defined
-export([new_leaf/0,get_attr/3,set_gm_attr/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_leaf()->
  {NodeId,AgentMod} = {?RPNodeId_Leaf_PB_Gm,?MODULE},
  LeafAgent = role_prop_tree_leaf_agent:new_pojo(NodeId,AgentMod),
  role_prop_tree_node:new_leaf(LeafAgent).

get_attr(_LastVer,_TreeContext,_NodeId)->
  priv_get_gm_attr().

priv_get_gm_attr()->
  case yyu_proc_cache_dao:is_inited(?MODULE) of
    ?FALSE ->
      yyu_proc_cache_dao:init(?MODULE);
    ?TRUE->?OK
  end,
  AttrItem = yyu_proc_cache_dao:get_data(?DataId,?MODULE),
  AttrItem.

set_gm_attr(PropMap)->
  AttrItem = priv_get_gm_attr(),
  AttrItem_1 = ?IF(AttrItem==?NOT_SET,role_prop_attr_item:new_pojo(?RPNodeId_Leaf_PB_Gm)),
  AttrItem_2 = role_prop_attr_item:put_propMap(PropMap,AttrItem_1),
  yyu_proc_cache_dao:put_data(?MODULE,?DataId,AttrItem_2),
  ?OK.






%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_tree_leaf_agent).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_pojo/2]).
-export([get_id/1,get_attr/3]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(NodeId,AgentMod)->
  #{
    id=>NodeId,
    agent_mod => AgentMod
  }.

get_attr(LastVer,TreeContext,SelfMap)->
  NodeId = get_id(SelfMap),
  Mod = priv_get_agent_mod(SelfMap),
  case Mod:get_attr(LastVer,TreeContext,NodeId) of
    ?NO_CHANGE ->?NO_CHANGE;
    ?NOT_SET ->?NOT_SET;
    AttrItem ->
      IncludeList = role_prop_tree_context:get_include_key_list(TreeContext),
      AttrItem_1 = role_prop_attr_item:filter_propMap(IncludeList,AttrItem),
      AttrItem_1
  end.


get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

priv_get_agent_mod(SelfMap) ->
  yyu_map:get_value(agent_mod, SelfMap).



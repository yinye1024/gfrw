%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_hero_tree_builder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include("role/role_online/bs_role_base/prop/role_prop.hrl").

%% API functions defined
-export([new_tree/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_tree(HeroId)->
  {TreeType,TreeId} = {?RP_TreeType_Hero,HeroId},
  HeroPropKeyList = priv_get_hero_prop_key_list(),
  Tree = role_prop_tree_item:new_pojo(TreeType,TreeId,HeroPropKeyList),

  LeafList = [
    role_prop_leaf_agent_Hero_Base:new_leaf(),
    role_prop_leaf_agent_Hero_DanYao:new_leaf(),
    role_prop_leaf_agent_Hero_Equip:new_leaf(),
    role_prop_leaf_agent_Hero_FuWen:new_leaf(),
    role_prop_leaf_agent_Hero_Realm:new_leaf(),
    role_prop_leaf_agent_Hero_ShenGe:new_leaf()
  ],

  Fun = fun(LeafTmp,AccTree) ->
    AccTree_1 = role_prop_tree_item:add_node({LeafTmp,?RPNodeId_Root},AccTree),
    AccTree_1
  end,
  Tree_1 = yyu_list:foreach(Fun, Tree,LeafList),
  Tree_1.

%% 英雄的属性key列表,1到200的都是英雄属性
priv_get_hero_prop_key_list()->
  lists:seq(1,200).
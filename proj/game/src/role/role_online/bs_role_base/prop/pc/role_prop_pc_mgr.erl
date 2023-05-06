%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_pc_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/1]).
-export([get_heroId_list/0]).
-export([get_hero_tree/1,put_hero_tree/1,rm_hero_tree/1]).
-export([get_player_tree/0,put_player_tree/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(RoleId)->
  role_prop_pc_dao:init(RoleId),
  ?OK.

get_heroId_list()->
  Data = priv_get_data(),
  HeroIdList = role_prop_pc_pojo:get_heroId_list(Data),
  HeroIdList.

get_hero_tree(HeroId)->
  Data = priv_get_data(),
  role_prop_pc_pojo:get_hero_tree(HeroId,Data).

put_hero_tree(HeroTree)->
  Data = priv_get_data(),
  Data_1 = role_prop_pc_pojo:put_hero_tree(HeroTree,Data),
  priv_update(Data_1).

rm_hero_tree(HeroId)->
  Data = priv_get_data(),
  Data_1 = role_prop_pc_pojo:rm_hero_tree(HeroId,Data),
  priv_update(Data_1).

get_player_tree()->
  Data = priv_get_data(),
  role_prop_pc_pojo:get_player_tree(Data).
put_player_tree(PlayerTree)->
  Data = priv_get_data(),
  Data_1 = role_prop_pc_pojo:set_player_tree(PlayerTree,Data),
  priv_update(Data_1).

priv_get_data()->
  Data = role_prop_pc_dao:get_data(),
  Data.

priv_update(Data)->
  role_prop_pc_dao:put_data(Data),
  ?OK.




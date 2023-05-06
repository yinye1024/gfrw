%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_attr_effect_prop_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include("role/role_online/bs_role_base/prop/role_prop.hrl").

%% API functions defined
-export([new_pojo/1]).
-export([get_effect_prop_map/1, get_attr_item_ver/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(AttrItem)->
  PropMap = role_prop_attr_item:get_prop_map(AttrItem),
  Ver = role_prop_attr_item:get_ver(AttrItem),
  EffectPropMap = role_prop_attr_helper:to_effect_value_map(PropMap),
  #{
    effect_prop_map => EffectPropMap,        %% 总属性
    attr_item_ver => Ver                     %% 纪录属性对应AttrItem的版本号
  }.

get_effect_prop_map(SelfMap) ->
  yyu_map:get_value(effect_prop_map, SelfMap).

get_attr_item_ver(SelfMap) ->
  yyu_map:get_value(attr_item_ver, SelfMap).


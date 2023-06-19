%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_tpl_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/login_pb.hrl").


-define(Class, ?MODULE).
%% API functions defined
-export([new_pojo/1, is_class/1, has_id/1, get_id/1, get_ver/1, incr_ver/1]).
-export([get_item/2,put_item/2,rm_item/2]).
-export([get_item_map/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId) ->
  #{
    '_id' => RoleId, ver => 0, class => ?MODULE,
    auto_itemId => 0,  %% item 自增id
    item_map => yyu_map:new_map()        %% <ItemId,role_tpl_item>
  }.

is_class(SelfMap) ->
  yyu_map:get_value(class, SelfMap) == ?Class.

has_id(SelfMap) ->
  get_id(SelfMap) =/= ?NOT_SET.

get_id(SelfMap) ->
  yyu_map:get_value('_id', SelfMap).

get_ver(SelfMap) ->
  yyu_map:get_value(ver, SelfMap).
incr_ver(SelfMap) ->
  CurVer = get_ver(SelfMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, SelfMap).


put_item(TplItem, SelfMap) ->
  TplId = role_tpl_item:get_id(TplItem),
  Map = get_item_map(SelfMap),
  Map_1 = yyu_map:put_value(TplId, TplItem, Map),
  priv_set_item_map(Map_1, SelfMap).

rm_item(TplId, SelfMap) ->
  Map = get_item_map(SelfMap),
  Map_1 = yyu_map:remove(TplId, Map),
  priv_set_item_map(Map_1, SelfMap).

get_item(TplId, SelfMap) ->
  Map = get_item_map(SelfMap),
  yyu_map:get_value(TplId,Map).

get_item_map(SelfMap) ->
  yyu_map:get_value(item_map, SelfMap).

priv_set_item_map(Value, SelfMap) ->
  yyu_map:put_value(item_map, Value, SelfMap).

%% return {NextId,NewSelfMap}
incr_and_get_itemId(SelfMap) ->
  NextId = priv_get_auto_itemId(SelfMap) + 1,
  {NextId, priv_set_auto_itemId(NextId, SelfMap)}.

priv_get_auto_itemId(SelfMap) ->
  yyu_map:get_value(auto_itemId, SelfMap).

priv_set_auto_itemId(Value, SelfMap) ->
  yyu_map:put_value(auto_itemId, Value, SelfMap).


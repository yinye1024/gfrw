%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_wallet_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/login_pb.hrl").


-define(Class, ?MODULE).
%% API functions defined
-export([new_pojo/1, is_class/1, has_id/1, get_id/1, get_ver/1, incr_ver/1]).
-export([add_goods/4]).
-export([is_goods_enough/3,rm_goods/3]).
-export([get_item_map/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId) ->
  NewPojo = #{
    '_id' => RoleId, ver => 0, class => ?MODULE,
    item_map => yyu_map:new_map()       %% <CfgId,role_wallet_item>
  },
  NewPojo_1 = add_goods(role_wallet_cfg_helper:get_gold_cfgId(),10000,?TRUE,NewPojo),
  NewPojo_2 = add_goods(role_wallet_cfg_helper:get_diamond_cfgId(),1000,?TRUE,NewPojo_1),
  NewPojo_2.

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

is_goods_enough(CfgId,Count,SelfMap)->
  WalletItem = priv_get_item(CfgId,SelfMap),
  role_wallet_item:get_total_count(WalletItem) > Count.

rm_goods(CfgId,Count,SelfMap) ->
  WalletItem_1 =
    case priv_get_item(CfgId,SelfMap) of
      ?NOT_SET -> role_wallet_item:new_item(CfgId);
      ItemTmp ->
        ItemTmp
    end,
  {LeftCount,WalletItem_2} = role_wallet_item:decr_count(Count,WalletItem_1),
  %% 跑到这里不应该出现不够扣的情况，非0 直接抛错
  yyu_error:assert_true(LeftCount ==0,"left count should be 0 but not."),
  SelfMap_1 = priv_update_item(WalletItem_2, SelfMap),
  SelfMap_1.


add_goods(CfgId,Count,IsBind,SelfMap) ->
  WalletItem_1 =
    case priv_get_item(CfgId,SelfMap) of
      ?NOT_SET -> role_wallet_item:new_item(CfgId);
      ItemTmp ->
        ItemTmp
    end,
  WalletItem_2 =
  case IsBind of
    ?TRUE ->  role_wallet_item:add_bind_count(Count,WalletItem_1);
    ?FALSE -> role_wallet_item:add_unbind_count(Count,WalletItem_1)
  end,
  SelfMap_1 = priv_update_item(WalletItem_2, SelfMap),
  SelfMap_1.


%% 放入 新的 WalletItem
%% 1 count 是 0 的BatItem 会被移除
%% 2 对应cfgId的WalletItem 列表为空的sum会被移除
priv_update_item(WalletItem, AccSelfMap) ->
  AccSelfMap_1 =
    case role_wallet_item:get_total_count(WalletItem) > 0 of
      ?TRUE -> priv_put_item(WalletItem, AccSelfMap);
      ?FALSE ->
        CfgId = role_wallet_item:get_id(WalletItem),
        priv_rm_item(CfgId, AccSelfMap)
    end,
  AccSelfMap_1.

priv_put_item(WalletItem, SelfMap) ->
  CfgId = role_wallet_item:get_id(WalletItem),
  Map = get_item_map(SelfMap),
  Map_1 = yyu_map:put_value(CfgId, WalletItem, Map),
  priv_set_item_map(Map_1, SelfMap).

priv_rm_item(CfgId, SelfMap) ->
  Map = get_item_map(SelfMap),
  Map_1 = yyu_map:remove(CfgId, Map),
  priv_set_item_map(Map_1, SelfMap).

priv_get_item(CfgId,SelfMap)->
  Map = get_item_map(SelfMap),
  yyu_map:get_value(CfgId,Map).

get_item_map(SelfMap) ->
  yyu_map:get_value(item_map, SelfMap).

priv_set_item_map(Value, SelfMap) ->
  yyu_map:put_value(item_map, Value, SelfMap).



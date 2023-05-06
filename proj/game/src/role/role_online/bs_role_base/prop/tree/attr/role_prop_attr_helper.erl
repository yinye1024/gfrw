%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_prop_attr_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include("role/role_online/bs_role_base/prop/role_prop.hrl").


%% API functions defined
-export([add_to_prop_map/2]).
-export([to_value_keyList/1,to_value_key/1,is_value_key/1,to_percent_key/1]).
-export([to_effect_value_map/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
add_to_prop_map(PropKVList,PropMap)->
  Fun = fun({Key,Value},AccPropMap) ->
          OldValue = yyu_map:get_value(Key,0,AccPropMap),
          NewValue = OldValue+Value,
          AccPropMap_1 = yyu_map:put_value(Key,NewValue,AccPropMap),
          AccPropMap_1
        end,
  PropMap_1 = yyu_list:foreach(Fun, PropMap,PropKVList),
  PropMap_1.

to_value_keyList(PropKeyList)->
  ValueKeyMap = priv_to_value_keyList(PropKeyList,yyu_map:new_map()),
  yyu_map:all_keys(ValueKeyMap).

priv_to_value_keyList([PropKey|Less],AccValueKeyMap)->
  AccValueKeyMap_1 = yyu_map:put_value(to_value_key(PropKey),1,AccValueKeyMap),
  priv_to_value_keyList(Less,AccValueKeyMap_1);
priv_to_value_keyList([],AccValueKeyMap)->
  AccValueKeyMap.

to_value_key(PropKey) when is_integer(PropKey)->
  case is_value_key(PropKey) of
    ?TRUE ->
      PropKey;
    ?FALSE ->
      ValueKey = PropKey - ?RP_PercentIdMark,
      ValueKey
  end.

is_value_key(PropKey) when is_integer(PropKey) ->
  PropKey < ?RP_PercentIdMark.

to_percent_key(PropKey) ->
  PropKey + ?RP_PercentIdMark.

%% 最后生效的属性值
to_effect_value_map(PropMap)->
  PropMap_1 = priv_to_effect_value_map(yyu_map:to_kv_list(PropMap),PropMap,yyu_map:new_map()),
  PropMap_1.
priv_to_effect_value_map([{PropKey,PropValue}|Less],PropMap,AccPropMap)->
  AccPropMap_1 =
    case is_value_key(PropKey) of
      ?TRUE ->
        PcentKey = to_percent_key(PropKey),
        AccPropMapTmp_1 =
          case yyu_map:get_value(PcentKey,PropMap) of
            ?NOT_SET ->
              AccPropMapTmp = yyu_map:put_value(PropKey,PropValue,AccPropMap),
              AccPropMapTmp;
            PcentValue ->
              TotalValue = priv_cal_effect_value(PropValue,PcentValue),
              AccPropMapTmp = yyu_map:put_value(PropKey,TotalValue,AccPropMap),
              AccPropMapTmp
          end,
        AccPropMapTmp_1;
      ?FALSE ->
        AccPropMap
    end,
  priv_to_effect_value_map(Less,PropMap,AccPropMap_1);
priv_to_effect_value_map([],_PropMap,AccPropMap)->
  AccPropMap.

%% 计算生效的属性值
priv_cal_effect_value(PropValue,PcentValue)->
  PropValue*(1+PcentValue/?RP_PercentBase).

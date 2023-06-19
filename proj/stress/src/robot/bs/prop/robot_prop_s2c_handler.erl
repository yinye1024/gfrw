%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_prop_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/prop_pb.hrl").


%% API functions defined

-export([role_prop_player_s2c/1,role_prop_player_changed_s2c/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
role_prop_player_s2c(BinData)->
  #role_prop_player_s2c{
    kv_list = KvItemList
  } = prop_pb:decode_msg(BinData,role_prop_player_s2c),
  PropMap = priv_to_map(KvItemList,yyu_map:new_map()),

  BsData = robot_prop_data_mgr:get_data(),
  BsData_1 = robot_prop_data:set_prop_map(PropMap,BsData),
  robot_prop_data_mgr:put_data(BsData_1),
  ?LOG_INFO({"role_prop_player_s2c,{PropMap}",{PropMap}}),
  ?OK.

role_prop_player_changed_s2c(BinData)->
  #role_prop_player_changed_s2c{
    kv_list = KvItemList
  } = prop_pb:decode_msg(BinData,role_prop_player_changed_s2c),
  PropMap = priv_to_map(KvItemList,yyu_map:new_map()),

  BsData = robot_prop_data_mgr:get_data(),
  BsData_1 = robot_prop_data:set_prop_map(PropMap,BsData),
  robot_prop_data_mgr:put_data(BsData_1),
  ?LOG_INFO({"role_prop_player_changed_s2c,{PropMap}",{PropMap}}),
  ?OK.

priv_to_map([PkvItem |Less],AccPropMap)->
  AccPropMap_1 = yyu_map:put_value(PkvItem#p_kv_int.key, PkvItem#p_kv_int.value,AccPropMap),
  priv_to_map(Less,AccPropMap_1);
priv_to_map([],AccPropMap)->
  AccPropMap.


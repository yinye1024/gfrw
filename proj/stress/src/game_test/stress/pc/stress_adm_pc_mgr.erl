%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(stress_adm_pc_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/0,set_stress_cfg/1]).
-export([get_max_count/0]).
-export([get_tps/0]).
-export([get_cur_count/0,add_cur_count/1]).
-export([incr_and_get_auto_user_id/0, set_user_start_id/1]).
-export([get_robot_gen_list/0,add_robot/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  stress_adm_pc_dao:init(),
  ?OK.

get_max_count()->
  Data = priv_get_data(),
  MaxCount = stress_adm_pc_pojo:get_max_count(Data),
  MaxCount.

set_stress_cfg({MaxCount,Tps,StartUserId})->
  Data = priv_get_data(),
  Data_1 = stress_adm_pc_pojo:set_max_count(MaxCount,Data),
  Data_2 = stress_adm_pc_pojo:set_tps(Tps,Data_1),
  Data_3 = stress_adm_pc_pojo:set_auto_user_id(StartUserId,Data_2),
  priv_update_data(Data_3),
  ?OK.

get_tps()->
  Data = priv_get_data(),
  Tps = stress_adm_pc_pojo:get_tps(Data),
  Tps.

get_cur_count()->
  Data = priv_get_data(),
  CurCount = stress_adm_pc_pojo:get_cur_count(Data),
  CurCount.
add_cur_count(AddCount) when is_integer(AddCount)->
  Data = priv_get_data(),
  CurCount = stress_adm_pc_pojo:get_cur_count(Data),
  NewData = stress_adm_pc_pojo:set_cur_count(CurCount+AddCount,Data),
  priv_update_data(NewData),
  ?OK.

incr_and_get_auto_user_id()->
  Data = priv_get_data(),
  {AutoUserId,NewData} = stress_adm_pc_pojo:incr_and_get_auto_user_id(Data),
  priv_update_data(NewData),
  AutoUserId.
set_user_start_id(StartId) when is_integer(StartId)->
  Data = priv_get_data(),
  NewData = stress_adm_pc_pojo:set_auto_user_id(StartId,Data),
  priv_update_data(NewData),
  ?OK.


add_robot(UserId,RobotGen)->
  Data = priv_get_data(),
  NewData = stress_adm_pc_pojo:add_robot(UserId,RobotGen,Data),
  priv_update_data(NewData),
  ?OK.
get_robot_gen_list()->
  Data = priv_get_data(),
  RobotMap = stress_adm_pc_pojo:get_robot_map(Data),
  yyu_map:all_values(RobotMap).


priv_get_data()->
  Data = stress_adm_pc_dao:get_data(),
  Data.

priv_update_data(NewData)->
  stress_adm_pc_dao:put_data(NewData),
  ?OK.




%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_stress_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/0, loop_tick/0,persistent/0,terminate/0]).
-export([set_stress_cfg/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  stress_adm_pc_mgr:init(),
  ?OK.

persistent()->
  ?OK.

terminate()->
  priv_stop_robots(),
  ?OK.

loop_tick()->
  priv_new_robots(),
  ?OK.


priv_stop_robots()->
  RobotGenList = stress_adm_pc_mgr:get_robot_gen_list(),
  priv_stop_robot(RobotGenList),
  ?OK.
priv_stop_robot([])->
  ?OK;
priv_stop_robot([RobotGen|Less]) ->
  gs_robot_mgr:close(RobotGen),
  priv_stop_robot(Less).

priv_new_robots()->
  MaxCount = stress_adm_pc_mgr:get_max_count(),
  CurCount = stress_adm_pc_mgr:get_cur_count(),
  case CurCount < MaxCount of
    ?TRUE ->
      Tps = stress_adm_pc_mgr:get_tps(),
      NewAddCount = ?IF(MaxCount-CurCount > Tps, Tps,MaxCount-CurCount),
      priv_new_robot(NewAddCount),
      stress_adm_pc_mgr:add_cur_count(NewAddCount),
      ?OK;
    ?FALSE ->
      ?OK
  end,
  ?OK.
priv_new_robot(NewAddCount) when NewAddCount =< 0->
  ?OK;
priv_new_robot(NewAddCount) ->
  NewUserId = stress_adm_pc_mgr:incr_and_get_auto_user_id(),
  RobotGen = gs_robot_mgr:new_child(NewUserId),
  stress_adm_pc_mgr:add_robot(NewUserId,RobotGen),
  stress_robot_decorator:decorate_robot(RobotGen),
  priv_new_robot(NewAddCount -1).

set_stress_cfg({MaxCount,Tps,StartUserId})->
  stress_adm_pc_mgr:set_stress_cfg({MaxCount,Tps,StartUserId}),
  ?LOG_INFO({"set_stress_cfg done! {MaxCount,Tps,StartUserId} = ",{MaxCount,Tps,StartUserId}}),
  ?OK.



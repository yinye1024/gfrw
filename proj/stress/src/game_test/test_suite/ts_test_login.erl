%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 23. 2月 2023 15:40
%%%-------------------------------------------------------------------
-module(ts_test_login).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
%% API
-export([do_test/0]).


%% ts_test_login:do_test().
do_test()->
  RobotGen = ts_helper:new_robot(1001),
%%  priv_test_reLogin(RobotGen),
  priv_test_reconnect(RobotGen),
  ?OK.

priv_test_reLogin(RobotGen)->
  s2s_robot_mgr:add_loop_fun(RobotGen,{1,5,fun robot_avatar_mgr:send_heart_beat/0}),
  s2s_robot_mgr:add_loop_fun(RobotGen,{2,10,fun robot_login_mgr:login_or_create/0}),
  s2s_robot_mgr:add_loop_fun(RobotGen,{3,15,fun robot_login_mgr:role_logout_c2s/0}),
  ?OK.

priv_test_reconnect(RobotGen)->
  s2s_robot_mgr:add_loop_fun(RobotGen,{1,2,fun robot_avatar_mgr:send_heart_beat/0}),
  s2s_robot_mgr:add_once(RobotGen,{2,4,fun robot_login_mgr:login_or_create/0}),
  s2s_robot_mgr:add_once(RobotGen,{3,6,fun robot_login_mgr:start_miss_client_pack/0}),
  s2s_robot_mgr:add_once(RobotGen,{4,10,fun robot_login_mgr:role_reconnect_c2s/0}),
  ?OK.


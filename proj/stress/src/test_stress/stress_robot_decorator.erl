%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(stress_robot_decorator).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([decorate_robot/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================


decorate_robot(RobotGen)->

  %% 重复 登陆或创建，然后登出
  s2s_robot_mgr:add_loop_fun(RobotGen,{1,5,fun robot_avatar_mgr:send_heart_beat/0}),
  s2s_robot_mgr:add_loop_fun(RobotGen,{2,10,fun robot_login_mgr:login_or_create/0}),
  s2s_robot_mgr:add_loop_fun(RobotGen,{3,15,fun robot_login_mgr:role_logout_c2s/0}),

  ?OK.






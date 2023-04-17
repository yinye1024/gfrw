%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 23. 2月 2023 15:40
%%%-------------------------------------------------------------------
-module(ts_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
%% API
-export([new_robot/1]).

new_robot(UserId) ->
  RobotGen =
  case gs_robot_mgr:has_child(UserId) of
    {?FALSE} ->
      RobotGenTmp = gs_robot_mgr:new_child(UserId),
      s2s_robot_mgr:add_loop_fun(RobotGenTmp,{1,5,fun robot_avatar_mgr:send_heart_beat/0}),
      s2s_robot_mgr:cast_do_fun(RobotGenTmp,{fun robot_login_mgr:login_or_create/0, []}),
      yyu_time:sleep(1000),
      RobotGenTmp;
    {?TRUE, RobotGenTmp}->RobotGenTmp
  end,

  RobotGen.


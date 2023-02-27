%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gs_robot_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/0,new_child/1,close/1]).
-export([route_s2c/2]).

-define(MAX_IDLE_TIME, 30).   %% 最大闲置时间30秒，超过就退出进程，回收cursor。

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  robot_sup:start_link(),
  robot_gen_mgr:init(),
  ?OK.

%% gs_robot_mgr:new_child(1003).
new_child(UserId)->
  RobotPid =
  case robot_gen_mgr:get_pid(UserId) of
    ?NOT_SET ->
      {?OK,Pid} = robot_sup:new_child({UserId}),
      Pid;
    PidTmp ->
      PidTmp
  end,
  RobotPid.

close(RobotGen) when is_pid(RobotGen)->
  robot_gen:do_stop(RobotGen),
  ?OK;
close(UserId)->
  case robot_gen_mgr:get_pid(UserId) of
    ?NOT_SET ->
      ?LOG_INFO({"role client gen not found, id:",UserId}),
      ?OK;
    RobotPid ->
      robot_gen:do_stop(RobotPid),
      ?OK
  end,
  ?OK.

route_s2c(UserId,{SvrMsgId, S2CId,BinData})->
  priv_cast_fun(UserId,{fun robot_route_s2c:route_s2c/1,[{SvrMsgId, S2CId,BinData}]}),
  ?OK.

priv_cast_fun(UserId,{CastFun,Param})->
  case robot_gen_mgr:get_pid(UserId) of
    ?NOT_SET ->
      ?LOG_INFO({"robot gen not found, id:",UserId}),
      ?FAIL;
    RobotPid ->
      robot_gen:cast_fun(RobotPid,{CastFun,Param}),
      ?OK
  end.


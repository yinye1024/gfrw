%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_robot_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([start_link/0,new_child/1,stop/1]).
-export([add_loop_fun/2,add_once/2]).
-export([get_roleId/1]).
-export([cast_do_fun/2,call_do_fun/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%%
start_link()->
  gs_robot_mgr:start_link(),
  ?OK.

%% gs_robot_mgr:new_child(1003).
new_child(UserId)->
  RobotPid = gs_robot_mgr:new_child(UserId),
  RobotPid.

stop(UserIdOrPid)->
  gs_robot_mgr:close(UserIdOrPid),
  ?OK.

add_once(UserIdOrPid,{TickId,DelayInSec,TickFun}) when is_function(TickFun,0)->
  cast_do_fun(UserIdOrPid,{fun bs_robot_mgr:add_once/1,[{TickId,DelayInSec,TickFun}]}),
  ?OK.

add_loop_fun(UserIdOrPid,{TickId,TickCdInSec,TickFun}) when is_function(TickFun,0)->
  cast_do_fun(UserIdOrPid,{fun bs_robot_mgr:add_loop/1,[{TickId,TickCdInSec,TickFun}]}),
  ?OK.

get_roleId(UserIdOrPid)->
  RoleId = s2s_robot_mgr:call_do_fun(UserIdOrPid, {fun robot_pc_mgr:get_roleId/0, []}),
  RoleId.

call_do_fun(UserIdOrPid,{WorkFun, ParamList})->
  Result = gs_robot_mgr:call_fun(UserIdOrPid,{WorkFun, ParamList}),
  Result.
cast_do_fun(UserIdOrPid,{WorkFun, ParamList})->
  gs_robot_mgr:cast_fun(UserIdOrPid,{WorkFun, ParamList}),
  ?OK.

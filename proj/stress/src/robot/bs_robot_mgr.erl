%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_robot_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/1, loop_1_sec/0,terminate/1,persistent/0]).
-export([add_once/1,add_loop/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
init({UserId} = _GenArgs)->
  robot_pc_mgr:init(UserId),
  robot_gen_mgr:reg(UserId,self()),
  robot_ticker_mgr:init(),
  ?LOG_INFO({"new robot gen init,UserId = ",UserId}),

  ?OK.

loop_1_sec()->
  robot_ticker_mgr:tick(),
  ?OK.

persistent()->
  ?OK.

terminate(UserId)->
  robot_gen_mgr:un_reg(UserId),
  ?OK.

add_once({TickId,DelayInSec,TickFun}) when is_function(TickFun,0)->
  robot_ticker_mgr:add_once(TickId,DelayInSec,TickFun),
  ?OK.

add_loop({TickId,TickCdInSec,TickFun}) when is_function(TickFun,0)->
  robot_ticker_mgr:add_loop(TickId,{TickCdInSec,TickFun}),
  ?OK.

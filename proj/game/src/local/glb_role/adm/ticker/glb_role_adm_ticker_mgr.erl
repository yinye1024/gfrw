%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 七月 2021 16:24
%%%-------------------------------------------------------------------
-module(glb_role_adm_ticker_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/0,add_loop/2,add_once/3,tick/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init() ->
  yyu_ticker_mgr:init(?MODULE),
  ?OK.

add_loop(Id,{CdInSec,CdFun})->
  NowTime = yyu_time:now_seconds(),
  yyu_ticker_mgr:add_loop(?MODULE,Id,NowTime,CdInSec,CdFun),
  ?OK.

add_once(Id,DelayInSec,DelayFun)->
  NowTime = yyu_time:now_seconds(),
  yyu_ticker_mgr:add_once(?MODULE,Id,{NowTime,DelayInSec,DelayFun}),
  ?OK.

tick()->
  NowTime = yyu_time:now_seconds(),
  yyu_ticker_mgr:tick(?MODULE,NowTime),
  ?OK.


%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gs_game_mongo_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/0,stop/0,print_mccfg/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  game_mongo_sup:start_link(),
  ?OK.

print_mccfg()->
  priv_cast_fun({fun bs_game_mongo_mgr:print_mccfg/0,[]}),
  ?OK.


stop()->
  game_mongo_gen:do_stop(),
  ?OK.

%%priv_call_fun({WorkFun,Param})->
%%  Result = game_mongo_gen:call_fun({WorkFun,Param}),
%%  Result.
priv_cast_fun({WorkFun,Param})->
  game_mongo_gen:cast_fun({WorkFun,Param}),
  ?OK.

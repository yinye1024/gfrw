%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_game_mongo_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/0, loop_tick/0,persistent/0,terminate/0]).
-export([print_mccfg/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
%%  McCfg = yymg_mongo_client_cfg:new_auth_cfg("192.168.43.29", 27017,<<"test_db">>,30000,{"mongo-admin", "mgadmin@123456"}),
  McCfg = game_cfg:game_mongo_cfg(),
  PoolSize = 16,
  game_mongo_pc_mgr:init(McCfg),
  PoolPid = game_mongo_dao:init(PoolSize,McCfg),
  game_mongo_pc_mgr:save_poolPid(PoolPid),
  ?OK.

loop_tick()->
  ?OK.

persistent()->
  ?OK.

terminate()->
  PoolPid = game_mongo_pc_mgr:get_poolPid(),
  game_mongo_dao:stop(PoolPid),
  ?OK.

print_mccfg()->
  McCfg = game_mongo_pc_mgr:get_mc_cfg(),
  ?LOG_INFO({mc_cfg,McCfg}),
  ?OK.
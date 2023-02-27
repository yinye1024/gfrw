%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(game_mongo_pc_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/1]).
-export([get_poolPid/0,save_poolPid/1]).
-export([get_mc_cfg/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(McCfg)->
  game_mongo_pc_dao:init(McCfg),
  ?OK.



get_mc_cfg()->
  Data = priv_get_data(),
  PoolPid = game_mongo_pc_pojo:get_mc_cfg(Data),
  PoolPid.

get_poolPid()->
  Data = priv_get_data(),
  PoolPid = game_mongo_pc_pojo:get_poolPid(Data),
  PoolPid.

save_poolPid(PoolPid)->
  Data = priv_get_data(),
  NewData = game_mongo_pc_pojo:set_poolPid(PoolPid,Data),
  priv_update_data(NewData),
  ?OK.

priv_get_data()->
  Data = game_mongo_pc_dao:get_data(),
  Data.

priv_update_data(NewData)->
  game_mongo_pc_dao:put_data(NewData),
  ?OK.




%%%-------
%%%
%%% ------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 13. 1月 2023 14:46
%%%-------------------------------------------------------------------
-module(game_cfg).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-define(DYN_GAME_CFG,dyn_game_cfg).

%% API
-export([init/0]).
-export([svr_no/0,game_host/0,game_port/0,adm_port/0,node_type/0,game_mongo_cfg/0,log_level/0]).
-export([login_address/0,login_check_auth/0]).

-export([max_conn/0, svr_OpenSeconds/0]).
-export([is_debug_open/0,is_dev_mode/0]).

init()->
  {?OK,Path} = file:get_cwd(),
  CfgFilePath = Path++"/config_deploy/server.config",
  io:format("~n cfgpath:~p~n",[CfgFilePath]),
  {?OK,CfgKvList} =  file:consult(CfgFilePath),
  dynamic_cfg_builder:build(?DYN_GAME_CFG,CfgKvList),
  ?OK.


svr_no()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,svr_no).
game_host()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,game_host).
game_port()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,game_port).
adm_port()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,adm_port).
node_type()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,node_type).
game_mongo_cfg()->
%%  {"127.0.0.1",27017,"game_db","mongo-admin","mgadmin@123456"}
  {Host,Port,DbName,Account,Password} = dynamic_cfg_builder:get_value(?DYN_GAME_CFG,game_mongo_cfg),
  TimeOut = 30000,
%%  McCfg = yymg_mongo_client_cfg:new_auth_cfg("192.168.43.29", 27017,<<"test_db">>,30000,{"mongo-admin", "mgadmin@123456"}),
  McCfg = yymg_mongo_client_cfg:new_auth_cfg(Host, Port,yyu_misc:to_binary(DbName),TimeOut,{Account, Password}),
  McCfg.

log_level()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,log_level).
login_address()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,login_address).
login_check_auth()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,login_check_auth).

svr_OpenSeconds()->
  {Date, Time} = dynamic_cfg_builder:get_value(?DYN_GAME_CFG,svr_open_date),
  OpenSeconds = yyu_calendar:datetime_to_gregorian_seconds({Date, Time}),
  OpenSeconds.

max_conn()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,max_conn).
is_debug_open()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,is_debug_open).
is_dev_mode()->
  dynamic_cfg_builder:get_value(?DYN_GAME_CFG,is_dev_mode).




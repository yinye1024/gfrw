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
-module(test_cfg).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-define(DYN_TEST_CFG,dyn_test_cfg).

%% API
-export([init/0]).
-export([game_host/0,game_port/0]).
-export([stress_cfg/0]).

init()->
  {?OK,Path} = file:get_cwd(),
  CfgFilePath = Path++"/config_deploy/test.config",
  io:format("~n cfgpath:~p~n",[CfgFilePath]),
  {?OK,CfgKvList} =  file:consult(CfgFilePath),
  dynamic_cfg_builder:build(?DYN_TEST_CFG,CfgKvList),
  ?OK.


game_host()->
  dynamic_cfg_builder:get_value(?DYN_TEST_CFG,game_host).
game_port()->
  dynamic_cfg_builder:get_value(?DYN_TEST_CFG,game_port).
stress_cfg()->
  dynamic_cfg_builder:get_value(?DYN_TEST_CFG,stress_cfg).



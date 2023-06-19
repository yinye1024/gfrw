%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 23. 2月 2023 19:19
%%%-------------------------------------------------------------------
-module(robot_role_client).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API
-export([new_role_client/1]).

new_role_client(UserId)->
  ClientAgent = yynw_tcp_client_agent:new(robot_gw:get_mod(), robot_gw:new_data(UserId)),
  {Addr,Port} = {"127.0.0.1",10090},
  ClientGen = yynw_tcp_client_api:new_client({Addr,Port,ClientAgent}),
  robot_pc_mgr:set_tcp_client_gen(ClientGen),
  ?OK.

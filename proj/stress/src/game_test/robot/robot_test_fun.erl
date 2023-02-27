%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 23. 2月 2023 15:40
%%%-------------------------------------------------------------------
-module(robot_test_fun).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
%% API
-export([test_reLogin/0,test_reconnect/0]).

test_reLogin()->
  robot_ticker_mgr:add_loop(1,{5,fun robot_avatar_mgr:send_heart_beat/0}),
  robot_ticker_mgr:add_loop(2,{10,fun robot_login_mgr:login_or_create/0}),
  robot_ticker_mgr:add_loop(3,{15,fun robot_login_mgr:role_logout_c2s/0}),
  ?OK.

test_reconnect()->
  robot_ticker_mgr:add_loop(1,{2,fun robot_avatar_mgr:send_heart_beat/0}),
  robot_ticker_mgr:add_once(2,4,fun robot_login_mgr:login_or_create/0),
  robot_ticker_mgr:add_once(3,6,fun robot_login_mgr:start_miss_client_pack/0),
  robot_ticker_mgr:add_once(4,10,fun robot_login_mgr:role_reconnect_c2s/0),
  ?OK.
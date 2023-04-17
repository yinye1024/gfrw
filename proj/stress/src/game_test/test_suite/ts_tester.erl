%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 13. 4月 2023 9:15
%%%-------------------------------------------------------------------
-module(ts_tester).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
%% API
-export([]).
do_test()->
  ts_test_login:do_test(),
%%  ts_test_friend:do_test(),
  ?OK.
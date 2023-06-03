%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%     shell 脚本交互方法的定义，方便在shell里面和服务进行交互
%%%     比方可以获取服务器的一些类似版本的信息
%%% @end
%%% Created : 30. 5月 2023 11:05
%%%-------------------------------------------------------------------
-module(user_default).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API
-export([q/0]).
q()->
  case game_cfg:is_dev_mode() of
    ?TRUE -> game_app:stop();
    ?FALSE -> io:format("exit - use ctrl+g -> q to stop current node ~n")
  end,
  ?OK.

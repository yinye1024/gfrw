%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     网关进程，每个用户一个
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(game_mongo_sup).
-author("yinye").

-behavior(supervisor).
-include_lib("yyutils/include/yyu_comm.hrl").

-define(SERVER,?MODULE).


%% API functions defined
-export([start_link/0,init/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
start_link()->
  SupInitArgs = [],
  supervisor:start_link({local,?SERVER},?MODULE,SupInitArgs).

init(_SupInitArgs) ->
  GenMod = game_mongo_gen:get_mod(),
  ChileSpec = #{
    id=> GenMod,
    start => {GenMod,start_link,[]},
    restart => permanent,  %% 挂了就重启
    shutdown => 20000,
    type => worker,
    modules => [GenMod]
  },
  {?OK,{ {one_for_one,10,10},[ChileSpec]} }.


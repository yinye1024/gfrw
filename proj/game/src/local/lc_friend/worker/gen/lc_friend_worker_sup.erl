%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     网关进程，每个用户一个
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_friend_worker_sup).
-author("yinye").

-behavior(supervisor).
-include_lib("yyutils/include/yyu_comm.hrl").

-define(SERVER,?MODULE).


%% API functions defined
-export([start_link/0,new_child/1,init/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
start_link()->
  SupInitArgs = [],
  supervisor:start_link({local,?SERVER},?MODULE,SupInitArgs).

new_child({GenId})->
  supervisor:start_child(?MODULE,[{GenId}]).


init(_SupInitArgs) ->
  GenMod = lc_friend_worker_gen:get_mod(),
  ChileSpec = #{
    id=> GenMod,
    start => {GenMod,start_link,[]},
    restart => temporary,  %% 挂了就挂了，不处理
    shutdown => 20000,
    type => worker,
    modules => [GenMod]
  },
  {?OK,{ {simple_one_for_one,10,10},[ChileSpec]} }.




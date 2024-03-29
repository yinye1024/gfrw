%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     网关进程，每个用户一个
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_online_sup).
-author("yinye").

-behavior(supervisor).
-include_lib("yyutils/include/yyu_comm.hrl").
-define(SERVER,?MODULE).


%% API functions defined
-export([get_mod/0,start_link/0,new_child/1,init/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->?MODULE.

start_link()->
  supervisor:start_link({local,?SERVER},?MODULE,{}).

new_child({RoleId,TcpGen})->
  supervisor:start_child(?MODULE,[{RoleId,TcpGen}]).

init({}) ->
  Mod = role_online_gen:get_mod(),
  ChileSpec = #{
    id=> Mod,
    start => {Mod,start_link,[]},
    restart => temporary,  %% 挂了就挂了，不处理
    shutdown => 20000,
    type => worker,
    modules => [Mod]
  },
  {?OK,{ {simple_one_for_one,10,10},[ChileSpec]} }.




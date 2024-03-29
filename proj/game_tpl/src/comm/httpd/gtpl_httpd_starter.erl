%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_httpd_starter).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-export([start/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% yyu_gtpl_httpd_tester:test().
start(Port,PoolSize)->
  RouteAgent = yynw_httpd_route_agent:new(gtpl_httpd_router:get_mod()),
  yynw_httpd_sup:start_link({Port,RouteAgent,PoolSize}),
  ?OK.


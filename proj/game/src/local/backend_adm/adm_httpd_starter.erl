%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(adm_httpd_starter).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-export([start_svr/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
start_svr(Port)->
  RouteAgent = yynw_httpd_route_agent:new(adm_httpd_router:get_mod()),
  PoolSize = 10,
  yynw_httpd_sup:start_link({Port,RouteAgent,PoolSize}),
  ?OK.


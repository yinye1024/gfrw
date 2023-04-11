%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     处理具体业务
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(adm_httpd_auth_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(COOKIE_USER_ID,"userId").
-define(COOKIE_TOKEN,"token").
-define(COOKIE_CLIENT_TYPE,"client_type").

-export([check_auth/1, set_auth_fail/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================

check_auth(_Req)->
  ?TRUE.

set_auth_fail(Resp) when is_map(Resp)->
  yyu_map:put_value(auth_pass,?FALSE,Resp).


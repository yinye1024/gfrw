%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     返回restful 结果
%%% @end
%%% Created : 20. 十月 2021 14:47
%%%-------------------------------------------------------------------
-module(adm_httpd_resp_restful).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_success/0,new_success_tjson/1,new_success_tListJson/1,new_fail/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_success() ->
  #{
    success=> ?TRUE
  }.
new_success_tjson(TJson) ->
  #{
    success=> ?TRUE,
    tJson => TJson
  }.
new_success_tListJson(TListJson) ->
  #{
    success=> ?TRUE,
    tListJson => TListJson
  }.

new_fail(Tips) ->
  #{
    tips => Tips,
    success=> ?FALSE
  }.



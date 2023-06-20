%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十月 2021 14:47
%%%-------------------------------------------------------------------
-module(gtpl_ticket).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new/2]).
-export([get_userId/1, get_token/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new(UserId,Token) ->
  #{
    userId=> UserId,
    token => Token
  }.

get_userId(ItemMap) ->
  yyu_map:get_value(userId, ItemMap).

get_token(ItemMap) ->
  yyu_map:get_value(token, ItemMap).


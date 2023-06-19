%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_gw_data).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new/1]).
-export([get_userId/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new(UserId)->
  #{
    userId=> UserId
  }.

get_userId(ItemMap) ->
  yyu_map:get_value(userId, ItemMap).







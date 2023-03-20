%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_mail_attach_data).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_item/2]).
-export([get_type/1, get_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_item(Type,Data)->
  #{
    type => Type,
    data =>Data
  }.


get_type(ItemMap) ->
  yyu_map:get_value(type, ItemMap).

get_data(ItemMap) ->
  yyu_map:get_value(data, ItemMap).


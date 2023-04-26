%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_bag_item_effect_agent).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([do_item_effect/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
do_item_effect(ExItem)->
  ?LOG_INFO({"do_item_effect", ExItem}),
  ?OK.

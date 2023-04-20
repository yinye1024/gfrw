%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_offmsg_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/2]).
-export([get_index/1,get_msg/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(Index,Msg)->
  BinMsg = yyu_misc:term_to_bin(Msg),
  #{
    index => Index,
    msg => BinMsg
  }.

get_index(SelfMap) ->
  yyu_map:get_value(index, SelfMap).

get_msg(SelfMap) ->
  BinMsg = yyu_map:get_value(msg, SelfMap),
  yyu_misc:bin_to_term(BinMsg).



%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 13. 4月 2023 9:15
%%%-------------------------------------------------------------------
-module(ts_tester).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
%% API
-export([do/0]).
%% ts_tester:do().
do()->
  get_head(reductions).

priv_insert([{Key,Value}|Less],Gb)->
  Gb_1 = gb_trees:insert(Key,Value,Gb),
  priv_insert(Less,Gb_1);
priv_insert([],Gb)->
  Gb.

get_head(AttrName)->
  Head = io_lib:format(
    "~n========================================~p=========================================================~n"
    "~n=========================================~p==============================================~n~20s ~45s ~24s ~36s ~12s ~14s ~10s~n",
    [AttrName,yyu_calendar:local_time(),"Pid","current_function","registered_name","initial_call","memory","reductions","msg_len"]),
  Head.
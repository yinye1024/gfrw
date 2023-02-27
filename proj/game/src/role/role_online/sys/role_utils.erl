%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 17. 1月 2023 14:28
%%%-------------------------------------------------------------------
-module(role_utils).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
%% API
-export([throw_done/0,handle_done/1]).
-export([handle_error/3]).

throw_done()->
  throw(done).
handle_done(_Stk)->
  ?OK.

handle_error(Error,Reason,Stk)->
  ?LOG_ERROR({"error castched {Error,Reason,Stk}",{Error,Reason,Stk}}),
  ?OK.




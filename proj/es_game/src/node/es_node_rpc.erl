%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%     rpc 接口 查看 game_rpc
%%% @end
%%% Created : 25. 5月 2023 15:41
%%%-------------------------------------------------------------------
-module(es_node_rpc).
-author("yinye").

-include_lib("es_comm.hrl").
%% 确保宏定义 和 game_rpc 保持一致
-define(StatusFail,0).
-define(StatusSuccess,1).
-define(StatusFail_NoApp,2).
-define(StatusFail_NoApi,3).

%% API
-export([get_rpc_start_fun/0,is_success/1]).
get_rpc_start_fun()->{atom_to_list(game_rpc),"call_rpc"}.

is_success(?StatusSuccess)->
  ?TRUE;
is_success(_Status)->
  ?FALSE.



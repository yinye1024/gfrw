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

-include("es_comm.hrl").
%% 确保宏定义 和 game_rpc 保持一致
-define(StatusFail,0).
-define(StatusSuccess,1).
-define(StatusFail_NoApp,2).
-define(StatusFail_NoApi,3).

%% API
-export([get_rpc_start_fun/0,is_success/1,do_call/0]).
get_rpc_start_fun()->{?MODULE,do_call}.

is_success(?StatusSuccess)->
  ?TRUE;
is_success(_Status)->
  ?FALSE.

do_call()->
    case init:get_plain_arguments() of
      [TargetNodeName| Args]->
        io:format("plain arguments is :~n~p",[{TargetNodeName, Args}]),
        Node = list_to_atom(TargetNodeName),
        {TargetMod,TargetMethod} = {game_rpc,do_rpc},
        Status =
          case rpc:call(Node,TargetMod,TargetMethod,[Args]) of
            {badrpc,Reason}->
              io:format("Rpc failed on the node ~w: ~w~n",[Node,Reason]),
              ?StatusFail;
            StatusTmp ->
              StatusTmp
          end,
        halt(Status);
      _->
        io:format("Rpc failed, no args"),
        halt(?StatusFail)
    end,
    ?OK.


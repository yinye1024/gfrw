%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 25. 5月 2023 15:41
%%%-------------------------------------------------------------------
-module(es_utils_exec).
-author("yinye").

%% API
-export([format_exec/1,port_exec/1]).

%% 连接到服务器，这个命令向stdout输出指令，然后在当前shell执行指令，
%% 要保持当前shell交互的时候用这个方法
format_exec(Cmd) when is_list(Cmd)->
  io:format("~ts~n~n~n",[Cmd]),
  ok.

port_exec(Command) ->
  Port = open_port({spawn, Command}, [stream, in, eof, hide, exit_status]),
  Result = priv_wait_get_data(Port, []),
  Result.
priv_wait_get_data(Port, Sofar) ->
  receive
    {Port, {data, Bytes}} ->
      priv_wait_get_data(Port, [Sofar|Bytes]);
    {Port, eof} ->
      Port ! {self(), close},
      receive
        {Port, closed} ->
          true
      end,
      receive
        {'EXIT',  Port,  _} ->
          ok
      after 1 ->              % force context switch
        ok
      end,
      ExitCode =
        receive
          {Port, {exit_status, Code}} ->
            Code
        end,
      {ExitCode, lists:flatten(Sofar)}
  end.
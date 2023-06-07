%%%-------
%%%
%%% ------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%     提供节点的rpc调用接口，方便脚本控制服务。 调用端查看 es_node_rpc
%%% @end
%%% Created : 13. 1月 2023 14:46
%%%-------------------------------------------------------------------
-module(game_rpc).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(StatusFail,0).
-define(StatusSuccess,1).
-define(StatusFail_NoApp,2).
-define(StatusFail_NoApi,3).

%% API
-export([do_rpc/1]).
-export([call_rpc/0]).

%% 由连入脚本启动
call_rpc()->
  try
    priv_call_rpc()
  catch
    Error:Reason:STK  ->
      io:format("error do rpc call: ~n~p ~n~p ~n~p",[Error,Reason,STK]),
      ?OK
  end,
  ?OK.
priv_call_rpc()->
  case init:get_plain_arguments() of
    [TargetNodeName| Args]->
      io:format("plain arguments is :~n~p",[{TargetNodeName, Args}]),
      TargetNode = list_to_atom(TargetNodeName),
      {TargetMod,TargetMethod} = {?MODULE,do_rpc},
      Status =
        case rpc:call(TargetNode,TargetMod,TargetMethod,[Args]) of
          {badrpc,Reason}->
            io:format("Rpc failed on the node ~w: ~w~n",[TargetNode,Reason]),
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



do_rpc(["status",AppName])->
  Resp =
  case lists:keysearch(yyu_misc:list_to_atom(AppName),1,application:which_applications()) of
    {value,_Version}->?StatusSuccess;
    _Other->?StatusFail_NoApp
  end,
  Resp;
do_rpc(["stop"])->
  game_app:stop(),
  ?StatusSuccess;
do_rpc(["reload"|Less])->
  case Less of
    [ModsStr|_]->
      TokenList = string:tokens(ModsStr,"-"),
      ModList =   [yyu_misc:list_to_atom(Token) || Token <- TokenList],
      yyu_reload:reload_mods(ModList),
      ?OK;
    _->
      yyu_reload:reload_all(),
      ?OK
  end,
  ?StatusSuccess;
do_rpc(_)->
  ?StatusFail_NoApi.

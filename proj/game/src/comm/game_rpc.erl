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
      ?StatusSuccess;
    _->
      yyu_reload:reload_all(),
      ?StatusSuccess
  end,
  ?StatusSuccess;
do_rpc(_)->
  ?StatusFail_NoApi.

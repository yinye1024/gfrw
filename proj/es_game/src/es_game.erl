-module(es_game).

%% API exports
-export([main/1]).
-include("es_comm.hrl").

%%====================================================================
%% API functions
%%====================================================================

%% escript Entry point
main([GameRoot,Action|Args]) ->
    io:format("GameRoot:~p,Action:~p,Args:~p~n", [GameRoot,Action,Args]),
    file:set_cwd(GameRoot),
    priv_do_action(Action,Args),
    erlang:halt(0).

priv_do_action("start",_Args)->
    es_node_tool:start_cur_node_daemon(),
    ?OK;
priv_do_action("stop",_Args)->
    es_node_tool:stop_cur_node(),
    ?OK;
priv_do_action("attach",Args)->
    _Mark = case Args of
               [] -> "1";
               [Suffix] -> Suffix
           end,
    es_node_tool:attach_cur_node(),
    ?OK;
priv_do_action("live",_Args)->
    es_node_tool:start_cur_node_with_shell(),
    ?OK;
priv_do_action("reload",Args)->
    es_node_tool:cur_node_do_reload(Args),
    ?OK;
priv_do_action(Action,Args)->
    io:format("Action not found. Action:~p,Args:~p~n", [Action,Args]),
    ?OK.

%%====================================================================
%% Internal functions
%%====================================================================

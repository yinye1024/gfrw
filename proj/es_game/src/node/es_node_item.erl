%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 25. 5月 2023 15:41
%%%-------------------------------------------------------------------
-module(es_node_item).
-author("yinye").

-include("es_comm.hrl").

%% API
-export([new_svr_node/0, new_attach_node/0,new_rpc_node/0]).
-export([get_node_name/1,get_start_cmd_info/1]).

new_svr_node()->
  SvrItem = priv_new_comm_node(),
  SvrItem#{
    node_type => es_node_cfg:get_node_type(),
    start_fun => es_node_cfg:get_svr_start_fun()
  }.
new_attach_node()->
  AttachItem = priv_new_comm_node(),
  AttachItem#{
    node_type => attach_ag
  }.
new_rpc_node()->
  AttachItem = priv_new_comm_node(),
  AttachItem#{
    node_type => rpc_ag,
    start_fun => es_node_rpc:get_rpc_start_fun()
  }.
priv_new_comm_node()->
  #{
    svr_root_name => es_node_cfg:get_game_root_name(),
    svr_host => es_node_cfg:get_svr_host(),
    svr_port => es_node_cfg:get_svr_port(),
    svr_no => es_node_cfg:get_svr_no(),

    cookie => es_node_cfg:get_erl_cookie(),
    paList => es_node_cfg:get_erl_ebin_path()
  }.

get_start_cmd_info(SelfMap)->
  {NodeName,Cookie,PaList,StartFun} = {get_node_name(SelfMap),
    priv_get_cookie(SelfMap),
    priv_get_paList(SelfMap),
    priv_get_start_fun(SelfMap)},
  {NodeName,Cookie,PaList,StartFun}.

get_node_name(SelfMap)->
  Format = "~s_~s_~w_~w@~s",
  NodeName = io_lib:format(Format,[
    priv_get_svr_root_name(SelfMap),
    priv_get_node_type(SelfMap),
    priv_get_svr_no(SelfMap),
    priv_get_svr_port(SelfMap),
    priv_get_svr_host(SelfMap)
  ]),
  lists:flatten(NodeName).

priv_get_cookie(SelfMap) ->
  es_utils_map:get_value(cookie, SelfMap).

priv_get_paList(SelfMap) ->
  es_utils_map:get_value(paList, SelfMap).

priv_get_start_fun(SelfMap) ->
  es_utils_map:get_value(start_fun, SelfMap).



priv_get_svr_root_name(SelfMap) ->
  es_utils_map:get_value(svr_root_name, SelfMap).

priv_get_svr_host(SelfMap) ->
  es_utils_map:get_value(svr_host, SelfMap).

priv_get_svr_port(SelfMap) ->
  es_utils_map:get_value(svr_port, SelfMap).

priv_get_node_type(SelfMap) ->
  NodeTypeAtom = es_utils_map:get_value(node_type, SelfMap),
  atom_to_list(NodeTypeAtom).

priv_get_svr_no(SelfMap) ->
  es_utils_map:get_value(svr_no, SelfMap).




%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 25. 5月 2023 15:41
%%%-------------------------------------------------------------------
-module(es_node_cfg).
-author("yinye").

-include("es_comm.hrl").

%% API
-export([get_svr_host/0,get_svr_port/0,get_node_type/0,get_svr_no/0,get_svr_root_name/0,get_svr_start_fun/0]).
-export([get_erl_ebin_path/0,get_erl_cookie/0,get_erl_start_direct/0]).


get_svr_host()->
  Value = priv_get_cfg(game_host),
  Value.
get_svr_port()->
  Value = priv_get_cfg(game_port),
  Value.
get_node_type()->
  Value = priv_get_cfg(node_type),
  Value.
get_svr_no()->
  Value = priv_get_cfg(svr_no),
  Value.
get_svr_start_fun()->
  {Mod,Fun} = priv_get_cfg(start_fun),
  {Mod,Fun} .

priv_get_cfg(Key)->
  Value = priv_get_value_from_cfg_file(Key,"server.config"),
  Value.


get_erl_ebin_path()->
  PathList = get_cfg_param(erl_ebin_path),
  PathList.

get_erl_cookie()->
  get_cfg_param(erl_cookie).

get_erl_start_direct()->
  get_cfg_param(erl_start_direct).


get_cfg_param(Key)->
  Value = priv_get_value_from_cfg_file(Key,"server_param.config"),
  Value.

priv_get_value_from_cfg_file(Key,FileName) when is_list(FileName)->
  CfgFilePath = priv_get_svr_root_path() ++ "/config_deploy/"++FileName,
  case file:consult(CfgFilePath) of
    {?OK,CfgData}->
      case lists:keyfind(Key,1,CfgData) of
        ?FALSE ->
          io:format("[get_cfg] config key not found, Key=~p~n,  FilePath = ~p",[Key, CfgFilePath]),
          throw(-1);
        {Key,Data}->Data
      end,
      CfgData;
    {?ERROR,Reason} ->
      io:format("[get_cfg][Reason=~p; FilePath = ~p] Fail to open config file",[Reason, CfgFilePath]),
      throw(-1)
  end.

priv_get_svr_root_path()->
  {?OK,Path} = file:get_cwd(),
  Path.

get_svr_root_name()->
  AbsPath = priv_get_svr_root_path(),
  RootName = filename:basename(AbsPath),
  RootName.


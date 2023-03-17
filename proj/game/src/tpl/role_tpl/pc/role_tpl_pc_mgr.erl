%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_tpl_pc_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/0]).
-export([get_roleId/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  RoleId = role_adm_mgr:get_roleId(),
  role_tpl_pc_dao:init(RoleId),
  ?OK.

get_roleId()->
  Data = priv_get_data(),
  RoleId = role_tpl_pc_pojo:get_roleId(Data),
  RoleId.

priv_get_data()->
  Data = role_tpl_pc_dao:get_data(),
  Data.
%%priv_update(Data)->
%%  role_tpl_pc_dao:put_data(Data),
%%  ?OK.




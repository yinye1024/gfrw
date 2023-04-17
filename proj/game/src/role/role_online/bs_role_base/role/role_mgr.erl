%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined

-export([proc_init/1,get_data/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(RoleId)->
  role_pdb_holder:init(RoleId),
  ?OK.


get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_pdb_holder:get_data(RoleId),
  Data.

%%priv_update_data(MultiData)->
%%  NewMultiData = role_pdb_pojo:incr_ver(MultiData),
%%  role_pdb_holder:put_data(NewMultiData),
%%  ?OK.

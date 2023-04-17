%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_role_pdb_holder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).

%% API functions defined
-export([proc_init/0,get_data/1,create/1, update/1,priv_put_to_pc/1]).
-export([is_data_dirty/1,remove_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  ?OK.

get_data(RoleId)->
  Data =
  case lc_role_proc_db:get_data(RoleId) of
    ?NOT_SET ->
      case lc_role_pdb_dao:get_data(RoleId) of
        ?NOT_SET ->?NOT_SET;
        DataTmp ->
          priv_put_to_pc(DataTmp),
          DataTmp
      end;
    DataTmp->DataTmp
  end,
  Data.

create(Data)->
  lc_role_pdb_dao:create(Data),
  ?OK.

update(Data)->
  priv_put_to_pc(Data),
  ?OK.

priv_put_to_pc(Data)->
  DataId = lc_role_pdb_pojo:get_id(Data),
  UpdateFun = fun lc_role_pdb_dao:update/1,
  Ver = lc_role_pdb_pojo:get_ver(Data),
  lc_role_proc_db:put_data({DataId, Data,Ver},UpdateFun),
  ?OK.

is_data_dirty(RoleId)->
  lc_role_proc_db:is_data_dirty(RoleId).

remove_data(RoleId)->
  lc_role_proc_db:remove_data(RoleId).



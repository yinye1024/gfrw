%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_tpl_pdb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/0]).
-export([put_tpl_item/1]).
-export([get_tpl_type/1,get_tpl_item/1,get_all_tplList/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  RoleId = role_adm_mgr:get_roleId(),
  role_tpl_pdb_holder:init(RoleId),
  ?OK.

get_tpl_type(TplId)->
  TplItem = get_tpl_item(TplId),
  role_tpl_item:get_type(TplItem).

get_tpl_item(TplId)->
  Data = priv_get_data(),
  TplItem = role_tpl_pdb_pojo:get_item(TplId,Data),
  TplItem.

put_tpl_item(TplItem)->
  Data = priv_get_data(),
  Data_1 = role_tpl_pdb_pojo:put_item(TplItem,Data),
  priv_update_data(Data_1).

get_all_tplList()->
  Data = priv_get_data(),
  ItemMap = role_tpl_pdb_pojo:get_item_map(Data),
  yyu_map:all_values(ItemMap).

priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_tpl_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(MultiData)->
  NewMultiData = role_tpl_pdb_pojo:incr_ver(MultiData),
  role_tpl_pdb_holder:put_data(NewMultiData),
  ?OK.



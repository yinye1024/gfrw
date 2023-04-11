%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_avatar_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined

-export([do_head_change/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================

do_head_change(HeadId,HeadBorder)->
  DataPojo = priv_get_data(),
  DataPojo_1 = role_avatar_pdb_pojo:set_headId(HeadId,DataPojo),
  DataPojo_2 = role_avatar_pdb_pojo:set_head_border(HeadBorder,DataPojo_1),
  priv_update_data(DataPojo_2),
  {?TRUE,HeadId,HeadBorder}.


priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_avatar_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(Data)->
  NewData = role_avatar_pdb_pojo:incr_ver(Data),
  role_avatar_pdb_holder:put_data(NewData),
  ?OK.



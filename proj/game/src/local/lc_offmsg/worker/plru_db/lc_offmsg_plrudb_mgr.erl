%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_offmsg_plrudb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/1,update_to_db/0,check_lru/0]).
-export([add_msg/1,remove_by_index/1,get_all_msg/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(_GenId)->
  lc_offmsg_plrudb_holder:proc_init(),
  ?OK.
update_to_db()->
  lc_offmsg_plrudb_holder:update_to_db(),
  ?OK.
check_lru()->
  lc_offmsg_plrudb_holder:do_lru(),
  ?OK.


add_msg({RoleId,Msg})->
  Offmsg = priv_get_data(RoleId),
  NewOffmsg = lc_offmsg_pojo:add_msg(Msg,Offmsg),
  priv_update_offmsg(NewOffmsg),
  ?OK.

remove_by_index({RoleId,MsgIndex})->
  Offmsg = priv_get_data(RoleId),
  NewOffmsg = lc_offmsg_pojo:remove_by_index(MsgIndex,Offmsg),
  priv_update_offmsg(NewOffmsg),
  ?OK.

get_all_msg({RoleId,LocalCbPojo})->
  Offmsg = priv_get_data(RoleId),
  yyu_local_callback_pojo:do_callback(Offmsg,LocalCbPojo),
  ?OK.

priv_get_data(RoleId)->
  Data =
  case lc_offmsg_plrudb_holder:get_data(RoleId) of
    ?NOT_SET ->
      Offmsg = lc_offmsg_pojo:new_pojo(RoleId),
      priv_update_offmsg(Offmsg),
      Offmsg;
    DataTmp->DataTmp
  end,
  Data.

priv_update_offmsg(Offmsg)->
  NewOffmsg = lc_offmsg_pojo:incr_ver(Offmsg),
  lc_offmsg_plrudb_holder:put_data(NewOffmsg),
  %% 每次更新要同时更新ets缓存
  s2s_lc_offmsg_adm_mgr:put_data(NewOffmsg),
  ?OK.


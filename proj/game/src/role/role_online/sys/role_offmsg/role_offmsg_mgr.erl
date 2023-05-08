%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_offmsg_mgr).
-author("yinye").
-behavior(role_mgr_behaviour).

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([get_mod/0]).

-export([role_init/1,data_load/1,after_data_load/1,loop_5_seconds/2,clean_midnight/2,clean_week/2,on_login/1,on_terminate/1]).
-export([notify_new_msg/0,cb_on_get_all_msg/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->?MODULE.

%% 角色创建，或者角色进程初始化的时候执行
role_init(_RoleId)->
  ?OK.
%% 角色进程初始化的时候执行
data_load(_RoleId)->
  ?OK.
%% 角色进程初始化，data_load 后执行
after_data_load(_RoleId)->
  ?OK.
%% 大约每隔5秒执行一次，具体执行情况要看是否有消息堆积
loop_5_seconds(_RoleId,_NowTime)->
  ?OK.
%% 跨天执行,一般是一些清理业务
clean_midnight(_RoleId,_LastCleanTime)->
  ?OK.
%% 跨周执行,一般是一些清理业务
clean_week(_RoleId,_LastCleanTime)->
  ?OK.
%% 玩家登陆的时候执行
on_login(_RoleId)->
  handle_msg(),
  ?OK.
%% 玩家进程关闭的时候，持久化之前执行
on_terminate(_RoleId)->
  role_prop_mgr:save_active_heroIdList(),
  ?OK.

notify_new_msg()->
  ?OK.
handle_msg()->
  RoleId = role_adm_mgr:get_roleId(),
  LocalCbPojo = role_offmsg_cb_handler:get_cb_on_get_all_msg(),
  lc_offmsg_app_api:get_data(RoleId,LocalCbPojo),
  ?OK.

cb_on_get_all_msg(OffMsgPojo)->
  RoleId = role_adm_mgr:get_roleId(),
  MsgItemList = lc_offmsg_pojo:get_msg_list(OffMsgPojo),
  NewLastIndex = lc_offmsg_pojo:get_msg_index(OffMsgPojo),

  RoleOffMsgData = priv_get_data(),
  %% 先更新index 避免重复执行msg
  LastIndex = role_offmsg_pdb_pojo:get_last_index(RoleOffMsgData),
  RoleOffMsgData_1 = role_offmsg_pdb_pojo:set_last_index(NewLastIndex,RoleOffMsgData),
  priv_update_data(RoleOffMsgData_1),
  %% 再执行所有的msg,并通知offmsg 进程清理msg
  priv_handle_msg_item(MsgItemList,LastIndex),
  lc_offmsg_app_api:remove_by_index(RoleId,NewLastIndex),
  ?OK.
priv_handle_msg_item([MsgItem|Less],LastIndex) ->
  case lc_offmsg_item:get_index(MsgItem) > LastIndex of
    ?TRUE ->
      ?TRY_CATCH(s2s_role_offmsg_mgr:apply_msg(self(),lc_offmsg_item:get_msg(MsgItem))),
      ?OK;
    ?FALSE ->?OK
  end,
  priv_handle_msg_item(Less,LastIndex);
priv_handle_msg_item([],_LastIndex) ->
  ?OK.


priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_offmsg_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(MultiData)->
  NewMultiData = role_offmsg_pdb_pojo:incr_ver(MultiData),
  role_offmsg_pdb_holder:put_data(NewMultiData),
  ?OK.



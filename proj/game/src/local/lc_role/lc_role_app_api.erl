%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%%    设计要点
%%%    1 worker 进程内用Lrudb对该worker进程管理的用户数据进行更新管理和持久化管理，避免进程内的数据堆积，
%%%    2 Lrudb 每次更新写入ets， 提供业务的全局访问，保证ets的数据是最新的。
%%%    3 ets get操作为空的时候直接从数据库获取数据。
%%%    4 ets 做时间缓存，到期自动删除数据。
%%%    5 别的业务进程读取ets数据，worker进程也在加载数据到ets的时候，会有几率冲突，出现短暂的数据不一致，但最终会以worker进程内的数据为准。
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_role_app_api).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([ets_init/0, start_svr/0, stop_svr/0]).
-export([get_list/1,get_data/1]).
-export([update_or_new_role/1,set_online/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%%
ets_init()->
  s2s_lc_role_adm_mgr:ets_init(),
  s2s_lc_role_worker_mgr:ets_init(),
  ?OK.

start_svr()->
  s2s_lc_role_worker_mgr:start_sup_link(),
  s2s_lc_role_adm_mgr:start_sup_link(),
  ?OK.

stop_svr()->
  gs_lc_role_adm_mgr:stop(),
  ?OK.

get_list(RoleIdList)->
  LcRoleList = yyu_list:map(fun(RoleId) -> get_data(RoleId) end,RoleIdList),
  LcRoleList.

get_data(RoleId)->
  LcRolePojo = lc_role_adm_mgr:get_data(RoleId),
  LcRolePojo.

update_or_new_role(LcRolePojo)->
  s2s_lc_role_worker_mgr:update_or_new_role(LcRolePojo),
  ?OK.
set_online(RoleId,IsOnline)->
  s2s_lc_role_worker_mgr:set_online(RoleId,IsOnline),
  ?OK.

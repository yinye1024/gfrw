%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%%   业务实现要点
%%%    1 好友申请添加到lc，但在玩家进程进行处理
%%%    2 玩家好友数据在lc进行管理，提供全服访问
%%%
%%%   技术设计要点
%%%    1 worker 进程内用Lrudb对该worker进程管理的用户数据进行更新管理和持久化管理，避免进程内的数据堆积，
%%%    2 Lrudb 每次更新写入ets， 提供业务的全局访问，保证ets的数据是最新的。
%%%    3 ets get操作为空的时候直接从数据库获取数据。
%%%    4 ets 做时间缓存，到期自动删除数据。
%%%    5 别的业务进程读取ets数据，worker进程也在加载数据到ets的时候，会有几率冲突，出现短暂的数据不一致，但最终会以worker进程内的数据为准。
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_friend_app_api).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([ets_init/0, start_svr/0, stop_svr/0]).
-export([get_data/1,update_if_in_cache/1]).
-export([add_blackId/2,rm_blackId/2]).
-export([add_friendId/2,rm_friendId/2]).
-export([get_all_apply/2,add_apply/2,rm_apply_byIndex/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%%
ets_init()->
  s2s_lc_friend_worker_mgr:ets_init(),
  ?OK.

start_svr()->
  s2s_lc_friend_worker_mgr:start_sup_link(),
  s2s_lc_friend_adm_mgr:start_sup_link(),
  ?OK.

stop_svr()->
  gs_lc_friend_adm_mgr:stop(),
  ?OK.

get_data(RoleId)->
  FriendPdbPojo = s2s_lc_friend_adm_mgr:get_data(RoleId),
  FriendPdbPojo.
update_if_in_cache(FriendPdbPojo)->
  FriendPdbPojo = s2s_lc_friend_adm_mgr:update_if_in_cache(FriendPdbPojo),
  FriendPdbPojo.

get_all_apply(RoleId,LocalCbPojo)->
  s2s_lc_friend_worker_mgr:get_all_apply(RoleId,LocalCbPojo),
  ?OK.

add_blackId(RoleId,BlackRoleId)->
  s2s_lc_friend_worker_mgr:add_blackId(RoleId,BlackRoleId),
  ?OK.
rm_blackId(RoleId,BlackRoleId)->
  s2s_lc_friend_worker_mgr:rm_blackId(RoleId,BlackRoleId),
  ?OK.

add_friendId(RoleId, FriendRoleId)->
  s2s_lc_friend_worker_mgr:add_friendId(RoleId,FriendRoleId),
  ?OK.
rm_friendId(RoleId,FriendRoleId)->
  s2s_lc_friend_worker_mgr:rm_friendId(RoleId,FriendRoleId),
  ?OK.


add_apply(RoleId, ApplyItem)->
  s2s_lc_friend_worker_mgr:add_apply(RoleId, ApplyItem),
  ?OK.
rm_apply_byIndex(RoleId,Index)->
  s2s_lc_friend_worker_mgr:rm_apply_byIndex(RoleId, Index),
  ?OK.
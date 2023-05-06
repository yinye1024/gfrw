%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 14:26
%%%-------------------------------------------------------------------
-module(role_mgr_behaviour).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(LifeCycleMgrList,{

}).

%% 角色创建，或者角色进程初始化的时候执行
-callback role_init(RoleId::integer())-> atom().
%% 角色进程初始化的时候执行
-callback data_load(RoleId::integer())-> atom().
%% 角色进程初始化，data_load 后执行
-callback after_data_load(RoleId::integer())-> atom().
%% 大约每隔5秒执行一次，具体执行情况要看是否有消息堆积
-callback loop_5_seconds(RoleId::integer(),NowTime::integer())-> atom().
%% 跨天执行,一般是一些清理业务
-callback clean_midnight(RoleId::integer(),LastCleanTime::integer())-> atom().
%% 跨周执行,一般是一些清理业务
-callback clean_week(RoleId::integer(),LastCleanTime::integer())-> atom().
%% 玩家登陆的时候执行
-callback on_login(RoleId::integer())-> atom().
%% 玩家进程关闭的时候，持久化之前执行
-callback on_terminate(RoleId::integer())-> atom().

%% API
%%-export([role_init/1,data_load/1,after_data_load/1,loop_5_seconds/2,clean_midnight/2,clean_week/2,on_login/1]).
%%%% ===================================================================================
%%%% API functions implements
%%%% ===================================================================================
%%get_mod()->?MODULE.
%%
%%%% 角色创建，或者角色进程初始化的时候执行
%%role_init(_RoleId)->
%%  ?OK.
%%%% 角色进程初始化的时候执行
%%data_load(_RoleId)->
%%  ?OK.
%%%% 角色进程初始化，data_load 后执行
%%after_data_load(_RoleId)->
%%  ?OK.
%%%% 大约每隔5秒执行一次，具体执行情况要看是否有消息堆积
%%loop_5_seconds(_RoleId,_NowTime)->
%%  ?OK.
%%%% 跨天执行,一般是一些清理业务
%%clean_midnight(_RoleId,_LastCleanTime)->
%%  ?OK.
%%%% 跨周执行,一般是一些清理业务
%%clean_week(_RoleId,_LastCleanTime)->
%%  ?OK.
%%%% 玩家登陆的时候执行
%%on_login(_RoleId)->
%%  ?OK.

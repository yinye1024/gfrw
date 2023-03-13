%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%%    设计要点
%%%    1 用Lrudb对数据进行更新管理和持久化管理，避免进程内的数据堆积，
%%%    2 Lrudb 每次更新写入ets， 提供业务的全局访问，保证ets的数据是最新的。
%%%    3 ets get操作为空的时候直接从数据库获取数据。
%%%    4 ets 做时间缓存，到期自动删除数据。
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_glb_role_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/0, loop_tick/0,persistent/0,terminate/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  glb_role_adm_mgr:proc_init(),

  glb_role_adm_ticker_mgr:init(),
  role_ticker_mgr:add_loop(1,{3600,fun glb_role_adm_mgr:check_and_clean_expired/0}),

  %% 初始化worker 进程
  s2s_glb_role_mgr:gen_init(),
  ?OK.

loop_tick()->
  glb_role_adm_ticker_mgr:tick(),
  ?OK.

persistent()->
  ?OK.

terminate()->
  s2s_glb_role_mgr:stop_all(),
  ?OK.


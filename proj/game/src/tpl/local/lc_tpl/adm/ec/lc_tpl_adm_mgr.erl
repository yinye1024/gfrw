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
-module(lc_tpl_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/0, check_and_clean_expired/0]).
-export([get_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  lc_tpl_ets_time_cache_dao:proc_init(),
  ?OK.

check_and_clean_expired()->
  lc_tpl_ets_time_cache_dao:check_and_clean_expired(),
  ?OK.

get_data(TplId)->
  Data =
  case lc_tpl_ets_time_cache_dao:get_data(TplId) of
    ?NOT_SET ->
      case lc_tpl_pdb_dao:get_data(TplId) of
        ?NOT_SET ->
          ?NOT_SET;
        TplPdbPojo ->
          lc_tpl_ets_time_cache_dao:put_data(TplPdbPojo),
          TplPdbPojo
      end;
    DataTmp ->
      DataTmp
  end,
  Data.



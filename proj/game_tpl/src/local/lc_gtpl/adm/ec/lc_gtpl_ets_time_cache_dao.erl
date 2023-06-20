%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_gtpl_ets_time_cache_dao).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/0,is_inited/0]).
-export([get_data/1,put_data/1,remove/1]).
-export([check_and_clean_expired/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% 一般使用这个就可以了，单进程写，多进程读，针对写少读多的情况。
proc_init() ->
  yyu_ets_time_cache_dao:init(?MODULE),
  ?OK.

is_inited()->
  yyu_ets_time_cache_dao:is_inited(?MODULE).

get_data(TplId)->
  Data =
  case yyu_ets_time_cache_dao:get_data(?MODULE,TplId) of
    ?NOT_SET ->?NOT_SET;
    {_ExpiredTime, DataTmp}->
      DataTmp
  end,
  Data.

put_data(GlbTpl)->
  TplId = lc_gtpl_pdb_pojo:get_id(GlbTpl),
  CachedTimeInSecond = 3600,
  yyu_ets_time_cache_dao:put_data(?MODULE,TplId, GlbTpl,CachedTimeInSecond),
  ?OK.

remove(TplId)->
  yyu_ets_time_cache_dao:remove(?MODULE,TplId),
  ?OK.

check_and_clean_expired()->
  yyu_ets_time_cache_dao:check_and_clean_expired(?MODULE),
  ?OK.






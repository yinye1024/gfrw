%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(tpl_plru_cache_dao).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/0]).
-export([get_lru_data/1,put_lru_data/1,check_lru/0, put_back_expired_data/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  yyu_proc_lru_cache_dao:proc_init(?MODULE,3600),
  ?OK.

get_lru_data(TplId)->
  Data = yyu_proc_lru_cache_dao:get_lru_data(?MODULE,TplId),
  Data.

put_lru_data(GlbTplPojo)->
  TplId = tpl_pdb_pojo:get_id(GlbTplPojo),
  yyu_proc_lru_cache_dao:put_lru_data(?MODULE,TplId,GlbTplPojo),
  ?OK.

check_lru()->
  ExpiredDataMap = yyu_proc_lru_cache_dao:check_lru(?MODULE),
  ExpiredDataMap.

%% 从 check_lru 获得 ExpiredDataMapTmp
%% ExpiredDataMapTmp 成功操作完，没有得到处理的data重新放入到过期数据里
%% 等待下一轮处理
put_back_expired_data(ExpiredDataMap)->
  yyu_proc_lru_cache_dao:put_back_expired_data(?MODULE,ExpiredDataMap),
  ?OK.

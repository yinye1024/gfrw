%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_plrudb_holder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/0,update_to_db/0,check_lru/0]).
-export([get_data/1, put_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  gtpl_plru_proc_db:proc_init(),
  gtpl_plru_pdb_holder:proc_init(),
  gtpl_plru_cache_dao:proc_init(),
  ?OK.

update_to_db()->
  gtpl_plru_proc_db:update_to_db(),
  ?OK.

check_lru()->
  ExpiredDataMap = gtpl_plru_cache_dao:check_lru(),
  LeftExpiredDataMap = priv_clean_expired_data(yyu_map:to_kv_list(ExpiredDataMap),yyu_map:new_map()),
  gtpl_plru_cache_dao:put_back_expired_data(LeftExpiredDataMap),
  ?OK.
priv_clean_expired_data([{DataId,Data}|Less],AccUnhandledMap)->
  AccUnhandledMap_1 =
  case gtpl_plru_pdb_holder:is_data_dirty(DataId) of
    ?TRUE ->
      gtpl_plru_pdb_holder:remove_data(DataId),
      AccUnhandledMap;
    ?FALSE ->
      yyu_map:put_value(DataId,Data,AccUnhandledMap)
  end,
  priv_clean_expired_data(Less,AccUnhandledMap_1);
priv_clean_expired_data([],AccUnhandledMap)->
  AccUnhandledMap.

get_data(TplId)->
  Data =
    case gtpl_plru_cache_dao:get_lru_data(TplId) of
      ?NOT_SET ->
        case gtpl_plru_pdb_holder:get_data(TplId) of
          ?NOT_SET ->
            ?NOT_SET;
          DataTmp ->
            gtpl_plru_cache_dao:put_lru_data(DataTmp),
            DataTmp
        end;
      DataTmp_1 ->
        DataTmp_1
    end,
  Data.

put_data(GlbTpl)->
  NewGlbTpl = gtpl_plru_pdb_pojo:incr_ver(GlbTpl),
  gtpl_plru_pdb_holder:put_data(NewGlbTpl),
  gtpl_plru_cache_dao:put_lru_data(NewGlbTpl),
  ?OK.

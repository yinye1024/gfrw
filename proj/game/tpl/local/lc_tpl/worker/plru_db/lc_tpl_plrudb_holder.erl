%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_tpl_plrudb_holder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/0,update_to_db/0,do_lru/0]).
-export([get_data/1, put_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  lc_tpl_proc_db:proc_init(),
  lc_tpl_pdb_holder:proc_init(),
  lc_tpl_plrudb_cache_dao:proc_init(),
  ?OK.

update_to_db()->
  lc_tpl_proc_db:update_to_db(),
  ?OK.

do_lru()->
  ExpiredDataMap = lc_tpl_plrudb_cache_dao:check_and_remove_expired(),
  priv_clean_expired_data(yyu_map:to_kv_list(ExpiredDataMap)),
  ?OK.
priv_clean_expired_data([{TplId,_Data}|Less])->
  lc_tpl_proc_db:update_to_db(TplId),
  lc_tpl_pdb_holder:remove_data(TplId),
  priv_clean_expired_data(Less);
priv_clean_expired_data([])->
  ?OK.

get_data(TplId)->
  Data =
    case lc_tpl_plrudb_cache_dao:get_lru_data(TplId) of
      ?NOT_SET ->
        case lc_tpl_pdb_holder:get_data(TplId) of
          ?NOT_SET ->
            ?NOT_SET;
          DataTmp ->
            lc_tpl_plrudb_cache_dao:put_lru_data(DataTmp),
            DataTmp
        end;
      DataTmp_1 ->
        DataTmp_1
    end,
  Data.

put_data(GlbTpl)->
  NewGlbTpl = lc_tpl_pdb_pojo:incr_ver(GlbTpl),
  lc_tpl_pdb_holder:put_data(NewGlbTpl),
  lc_tpl_plrudb_cache_dao:put_lru_data(NewGlbTpl),
  ?OK.

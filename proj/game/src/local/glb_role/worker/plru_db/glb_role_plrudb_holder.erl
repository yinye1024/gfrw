%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(glb_role_plrudb_holder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/0,update_to_db/0,do_lru/0]).
-export([get_data/1, put_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  glb_role_proc_db:proc_init(),
  glb_role_pdb_holder:proc_init(),
  glb_role_plru_cache_dao:proc_init(),
  ?OK.

update_to_db()->
  glb_role_proc_db:update_to_db(),
  ?OK.

do_lru()->
  ExpiredDataMap = glb_role_plru_cache_dao:check_and_remove_expired(),
  priv_clean_expired_data(yyu_map:to_kv_list(ExpiredDataMap)),
  ?OK.
priv_clean_expired_data([{RoleId,_Data}|Less])->
  glb_role_proc_db:update_to_db(RoleId),
  glb_role_pdb_holder:remove_data(RoleId),
  priv_clean_expired_data(Less);
priv_clean_expired_data([])->
  ?OK.

get_data(RoleId)->
  Data =
    case glb_role_plru_cache_dao:get_lru_data(RoleId) of
      ?NOT_SET ->
        case glb_role_pdb_holder:get_data(RoleId) of
          ?NOT_SET ->
            ?NOT_SET;
          DataTmp ->
            glb_role_plru_cache_dao:put_lru_data(DataTmp),
            DataTmp
        end;
      DataTmp_1 ->
        DataTmp_1
    end,
  Data.

put_data(GlbRole)->
  NewGlbRole = glb_role_pdb_pojo:incr_ver(GlbRole),
  glb_role_pdb_holder:put_data(NewGlbRole),
  glb_role_plru_cache_dao:put_lru_data(NewGlbRole),
  ?OK.
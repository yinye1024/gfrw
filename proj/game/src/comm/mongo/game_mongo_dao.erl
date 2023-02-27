%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(game_mongo_dao).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-define(PoolId,?MODULE).

%% API functions defined
-export([init/2, stop/1, ensure_indexes/2]).
-export([ insert/2,batch_insert/2,
          update/2,bulk_update/2,update_selection/3,
          delete/2,batch_delete/2]).
-export([ get_by_id/2,find_one/2,find_one/3,
          get_list/2,find_list/2,find_list/3,
          incr_and_get_autoId/1,find_and_modify/3]).
-export([get_count/2,find_batch/2,find_batch/4,next_batch/1, close_batch/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================

%% =======================  WorkMod 相关方法 ============================================================
%% yymg_mongo_mgr:ensure_sup_started().
init(PoolSize,McCfg)->
  yymg_mongo_api:ensure_sup_started(),
  PoolPid = yymg_mongo_api:new_pool(?PoolId,PoolSize,McCfg),
  PoolPid.

stop(PoolPid)->
  yymg_mongo_api:stop_pool(PoolPid),
  ?OK.

ensure_indexes(Collection, IndexSpec)->
  yymg_mongo_api:ensure_indexes(?PoolId,{Collection, IndexSpec}),
  ?OK.

insert(Collection, ItemMap)->
  yymg_mongo_api:insert(?PoolId,{Collection, ItemMap}),
  ?OK.

batch_insert(Collection, ItemMapList)->
  yymg_mongo_api:batch_insert(?PoolId,{Collection, ItemMapList}),
  ?OK.
update(Collection, ItemMap)->
  update(Collection, ItemMap, ?TRUE).
update(Collection, ItemMap, IsUpsert) when is_boolean(IsUpsert)->
  yymg_mongo_api:update(?PoolId,{Collection, ItemMap, IsUpsert}),
  ?OK.

update_selection(Collection, SelectMap,UpdateMap)->
  yymg_mongo_api:update_selection(?PoolId,{Collection, SelectMap,UpdateMap}),
  ?OK.

%% 无大小限制
bulk_update(Collection,ItemList)->
  bulk_update(Collection,ItemList,?TRUE).
bulk_update(Collection,ItemList,IsUpsert) when is_list(ItemList)->
  yymg_mongo_api:bulk_update(?PoolId,{Collection,ItemList,IsUpsert}),
  ?OK.

delete(Collection, SelectorMap) when is_map(SelectorMap)->
  yymg_mongo_api:delete(?PoolId,{Collection, SelectorMap}),
  ?OK.

batch_delete(Collection, QueryMap_LimitList) when is_list(QueryMap_LimitList)->
  yymg_mongo_api:batch_delete(?PoolId,{Collection, QueryMap_LimitList}),
  ?OK.

incr_and_get_autoId(AutoName) when is_atom(AutoName)->
  AutoId = yymg_mongo_api:incr_and_get_autoId(?PoolId,AutoName),
  AutoId.

find_and_modify(Collection, QueryMap,UpdateMap)->
  {?OK,Result} = yymg_mongo_api:find_and_modify(?PoolId,{Collection, QueryMap,UpdateMap}),
  {?OK,Result}.

get_by_id(Collection,DataId)->
  QueryMap = #{'_id'=>DataId},
  case find_one(Collection, QueryMap) of
    {?OK,Data}->Data;
    {?NOT_FOUND}->?NOT_SET
  end.
%% return all fields of found record if Projector = #{}
find_one(Collection, QueryMap)->
  find_one(Collection, QueryMap, #{}).
find_one(Collection, QueryMap, Projector)->
  Result = yymg_mongo_api:find_one(?PoolId,{Collection, QueryMap, Projector}),
  Result.

get_list(Collection, QueryMap)->
  {?OK, ItemList} = find_list(Collection, QueryMap),
  ItemList.
%% return all fields of found record if Projector = #{}
find_list(Collection, QueryMap)->
  find_list(Collection, QueryMap, #{}).
find_list(Collection, QueryMap, Projector)->
  {?OK, ItemList} = yymg_mongo_api:find_list(?PoolId,{Collection, QueryMap, Projector}),
  {?OK, ItemList}.


%% ==================== 批量查找 要管理好 cursorId (开始)==========================================
get_count(Collection, QueryMap)->
  Count = yymg_mongo_api:get_count(?PoolId,{Collection, QueryMap}),
  Count.

%% return all fields of found record if Projector = #{}
find_batch(Collection,QueryMap,Skip,BatchSize)->
  find_batch(Collection,{QueryMap,#{},Skip,BatchSize}).
find_batch(Collection,{QueryMap,Projector,Skip,BatchSize})->
  {CursorPid,ItemList} = yymg_mongo_api:find_batch(?PoolId,{Collection,{QueryMap,Projector,Skip,BatchSize}}),
  {CursorPid,ItemList}.

next_batch(CursorPid)->
  {?OK, ItemList} = yymg_mongo_api:next_batch(CursorPid),
  ItemList.

close_batch(CursorPid)->
  yymg_mongo_api:close_batch(CursorPid),
  ?OK.
%% ==================== 批量查找 要管理好 cursorId (结束)==========================================






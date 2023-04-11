%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_tpl_pdb_holder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).

%% API functions defined
-export([proc_init/0,get_data/1,put_data/1, update_func/1]).
-export([is_data_dirty/1,remove_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  ?OK.

get_data(TplId)->
  Data =
  case lc_tpl_proc_db:get_data(TplId) of
    ?NOT_SET ->
      case lc_tpl_pdb_dao:get_data(TplId) of
        ?NOT_SET ->?NOT_SET;
        DataTmp ->
          put_data(DataTmp),
          DataTmp
      end;
    DataTmp->DataTmp
  end,
  Data.

put_data(Data)->
  TplId = lc_tpl_pdb_pojo:get_id(Data),
  UpdateFun = fun ?MODULE:update_func/1,
  Ver = lc_tpl_pdb_pojo:get_ver(Data),
  lc_tpl_proc_db:put_data({TplId, Data,Ver},UpdateFun),
  ?OK.

is_data_dirty(TplId)->
  lc_tpl_proc_db:is_data_dirty(TplId).

remove_data(TplId)->
  lc_tpl_proc_db:remove_data(TplId).



%% 只给tpl_mutil_proc_db入库的时候调用，业务不能调用该接口
%% 不能用私有方法，因为按erlang的更新机制，5分钟如果热更两次的话，这个方法会失效
update_func(Data)->
  lc_tpl_pdb_dao:update(Data),
  ?OK.

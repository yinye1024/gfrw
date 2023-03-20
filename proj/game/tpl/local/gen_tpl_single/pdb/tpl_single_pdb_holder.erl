%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(tpl_single_pdb_holder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).

%% API functions defined
-export([init/1,get_data/1,put_data/1, update_func/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(SingleId)->
  case tpl_single_pdb_dao:get_data(SingleId) of
    ?NOT_SET ->
      Data = tpl_single_pdb_dao:create(SingleId),
      put_data(Data),
      ?OK;
    Data->
      put_data(Data),
      ?OK
  end,
  ?OK.

get_data(SingleId)->
  Data =
  case tpl_single_proc_db:get_data(?DATA_TYPE) of
    ?NOT_SET ->
      case tpl_single_pdb_dao:get_data(SingleId) of
        ?NOT_SET ->?NOT_SET;
        DataTmp ->
          put_data(DataTmp),
          DataTmp
      end;
    DataTmp->DataTmp
  end,
  Data.

put_data(Data)->
  UpdateFun = fun ?MODULE:update_func/1,
  Ver = tpl_single_pdb_pojo:get_ver(Data),
  tpl_single_proc_db:put_data({?DATA_TYPE, Data,Ver},UpdateFun),
  ?OK.
%% 只给tpl_mutil_proc_db入库的时候调用，业务不能调用该接口
%% 不能用私有方法，因为按erlang的更新机制，5分钟如果热更两次的话，这个方法会失效
update_func(Data)->
  tpl_single_pdb_dao:update(Data),
  ?OK.

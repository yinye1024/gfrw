%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(tpl_multi_pdb_holder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).

%% API functions defined
-export([init/1,get_data/1,put_data/1, update_func/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(MultiId)->
  ?OK.

get_data(RoleId)->
  Data =
  case tpl_multi_proc_db:get_data(RoleId) of
    ?NOT_SET ->
      case tpl_multi_pdb_dao:get_data(RoleId) of
        ?NOT_SET ->?NOT_SET;
        DataTmp ->
          put_data(DataTmp),
          DataTmp
      end;
    DataTmp->DataTmp
  end,
  Data.

put_data(Data)->
  RoleId = tpl_multi_pdb_pojo:get_id(Data),
  UpdateFun = fun ?MODULE:update_func/1,
  Ver = tpl_multi_pdb_pojo:get_ver(Data),
  tpl_multi_proc_db:put_data({RoleId, Data,Ver},UpdateFun),
  ?OK.
%% 只给tpl_mutil_proc_db入库的时候调用，业务不能调用该接口
%% 不能用私有方法，因为按erlang的更新机制，5分钟如果热更两次的话，这个方法会失效
update_func(Data)->
  tpl_multi_pdb_dao:update(Data),
  ?OK.

%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_mail_pdb_holder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).

%% API functions defined
-export([init/1,get_data/1,put_data/1, update_func/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(DataId)->
  case role_mail_pdb_dao:get_by_id(DataId) of
    ?NOT_SET ->
      Data = role_mail_pdb_dao:create(DataId),
      put_data(Data),
      ?OK;
    Data->
      put_data(Data),
      ?OK
  end,
  ?OK.

get_data(DataId)->
  Data =
  case role_proc_db:get_data(?DATA_TYPE) of
    ?NOT_SET ->
      case role_mail_pdb_dao:get_by_id(DataId) of
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
  Ver = role_mail_pdb_pojo:get_ver(Data),
  role_proc_db:put_data({?DATA_TYPE, Data,Ver},UpdateFun),
  ?OK.
%% 只给 role_offline_mail_pdb_dao 入库的时候调用，业务不能调用该接口
%% 不能用私有方法，因为按erlang的更新机制，5分钟如果热更两次的话，这个方法会失效
update_func(Data)->
  role_mail_pdb_dao:update(Data),
  ?OK.

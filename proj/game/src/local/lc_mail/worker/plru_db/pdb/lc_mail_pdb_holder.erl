%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_pdb_holder).
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

get_data(RoleId)->
  Data =
  case lc_mail_proc_db:get_data(RoleId) of
    ?NOT_SET ->
      case lc_mail_pdb_dao:get_data(RoleId) of
        ?NOT_SET ->?NOT_SET;
        DataTmp ->
          put_data(DataTmp),
          DataTmp
      end;
    DataTmp->DataTmp
  end,
  Data.

put_data(Data)->
  RoleId = lc_mail_pojo:get_id(Data),
  UpdateFun = fun ?MODULE:update_func/1,
  Ver = lc_mail_pojo:get_ver(Data),
  lc_mail_proc_db:put_data({RoleId, Data,Ver},UpdateFun),
  ?OK.

is_data_dirty(RoleId)->
  lc_mail_proc_db:is_data_dirty(RoleId).

remove_data(RoleId)->
  lc_mail_proc_db:remove_data(RoleId).



%% 只给mail_mutil_proc_db入库的时候调用，业务不能调用该接口
%% 不能用私有方法，因为按erlang的更新机制，5分钟如果热更两次的话，这个方法会失效
update_func(Data)->
  lc_mail_pdb_dao:update(Data),
  ?OK.

%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_friend_pdb_holder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).

%% API functions defined
-export([proc_init/0,get_data/1, priv_put_to_pc/1, update_func/1]).
-export([create/1,update/1]).
-export([is_data_dirty/1,remove_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  ?OK.

get_data(FriendId)->
  Data =
  case lc_friend_proc_db:get_data(FriendId) of
    ?NOT_SET ->
      case lc_friend_pdb_dao:get_data(FriendId) of
        ?NOT_SET ->?NOT_SET;
        DataTmp ->
          priv_put_to_pc(DataTmp),
          DataTmp
      end;
    DataTmp->DataTmp
  end,
  Data.
create(Data)->
  lc_friend_pdb_dao:create(Data),
  ?OK.

update(Data)->
  priv_put_to_pc(Data),
  ?OK.


priv_put_to_pc(Data)->
  FriendId = lc_friend_pdb_pojo:get_id(Data),
  UpdateFun = fun ?MODULE:update_func/1,
  Ver = lc_friend_pdb_pojo:get_ver(Data),
  lc_friend_proc_db:put_data({FriendId, Data,Ver},UpdateFun),
  ?OK.

is_data_dirty(FriendId)->
  lc_friend_proc_db:is_data_dirty(FriendId).

remove_data(FriendId)->
  lc_friend_proc_db:remove_data(FriendId).



%% 只给入库的时候调用，业务不能调用该接口
%% 不能用私有方法，因为按erlang的更新机制，5分钟如果热更两次的话，这个方法会失效
update_func(Data)->
  lc_friend_pdb_dao:update(Data),
  ?OK.

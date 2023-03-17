%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_mail_pdb_dao).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).
-define(Collection, yyu_offline_mail:to_binary(?MODULE)).

%% API functions defined
-export([create/1,update/1, get_by_id/1,delete/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
create(PdbData)->
  game_mongo_dao:insert(?Collection, PdbData),
  ?OK.

update(PdbData)->
  case role_mail_pdb_pojo:is_class(PdbData) andalso role_mail_pdb_pojo:has_id(PdbData) of
    ?TRUE ->
      game_mongo_dao:update(?Collection, PdbData);
    ?FALSE ->
      ErrorReason = "update item class not right or id is empty",
      yyu_error:throw_error(ErrorReason)
  end,
  ?OK.


get_by_id(DataId)->
  Data = game_mongo_dao:get_by_id(?Collection, DataId),
  Data.


delete(RoleId)->
  game_mongo_dao:delete(?Collection, RoleId),
  ?OK.


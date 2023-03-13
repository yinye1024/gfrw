%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_shop_pdb_dao).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).
-define(Collection, yyu_misc:to_binary(?MODULE)).

%% API functions defined
-export([create/1,update/1, get_by_id/1,get_by_name/1,get_by_user/2,delete/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
create(RolePojo)->
  game_mongo_dao:insert(?Collection, RolePojo),
  ?OK.

update(UpdateData)->
  case role_shop_pdb_pojo:is_class(UpdateData) andalso role_shop_pdb_pojo:has_id(UpdateData) of
    ?TRUE ->
      game_mongo_dao:update(?Collection, UpdateData);
    ?FALSE ->
      ErrorReason = "update item class not right or id is empty",
      yyu_error:throw_error(ErrorReason)
  end,
  ?OK.


get_by_id(RoleId)->
  Data = game_mongo_dao:get_by_id(?Collection, RoleId),
  Data.

get_by_name(Name)->
  QueryMap = #{name => Name},
  case game_mongo_dao:find_one(?Collection, QueryMap) of
    {?OK,Data}->Data;
    {?NOT_FOUND}->?NOT_SET
  end.

get_by_user(UserId,SvrId)->
  QueryMap = #{userId => UserId,svrId=>SvrId},
  case game_mongo_dao:find_one(?Collection, QueryMap) of
    {?OK,Data}->Data;
    {?NOT_FOUND}->?NOT_SET
  end.


delete(RoleId)->
  game_mongo_dao:delete(?Collection, RoleId),
  ?OK.


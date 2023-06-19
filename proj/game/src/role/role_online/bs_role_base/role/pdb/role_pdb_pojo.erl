%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/login_pb.hrl").


-define(Class,?MODULE).
%% API functions defined
-export([new_pojo/2,is_class/1,has_id/1,get_id/1,get_ver/1,incr_ver/1]).
-export([get_userId/1, get_svrId/1, get_name/1, get_gender/1]).
-export([to_p_roleInfo/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(RoleId,{UserId,SvrId,Name,Gender})->
  #{
    '_id' => RoleId,ver=>0,class=>?MODULE,
    userId => UserId,
    svrId => SvrId,
    name => Name,
    gender => Gender
  }.

is_class(SelfMap)->
  yyu_map:get_value(class,SelfMap) == ?Class.

has_id(SelfMap)->
  get_id(SelfMap) =/= ?NOT_SET.

get_id(SelfMap) ->
  yyu_map:get_value('_id', SelfMap).

get_ver(SelfMap) ->
  yyu_map:get_value(ver, SelfMap).
incr_ver(SelfMap) ->
  CurVer = get_ver(SelfMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, SelfMap).

to_p_roleInfo(SelfMap)->
  #p_roleInfo{
    role_id = get_id(SelfMap),
    name = get_name(SelfMap),
    gender = get_gender(SelfMap),
    exp = 1,
    level = 1,
    vip = 1
  }.

get_userId(SelfMap) ->
  yyu_map:get_value(userId, SelfMap).

get_svrId(SelfMap) ->
  yyu_map:get_value(svrId, SelfMap).

get_name(SelfMap) ->
  yyu_map:get_value(name, SelfMap).

get_gender(SelfMap) ->
  yyu_map:get_value(gender, SelfMap).


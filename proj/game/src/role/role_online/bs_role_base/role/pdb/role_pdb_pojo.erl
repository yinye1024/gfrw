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
-include_lib("protobuf/include/login_pb.hrl").


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

is_class(ItemMap)->
  yyu_map:get_value(class,ItemMap) == ?Class.

has_id(ItemMap)->
  get_id(ItemMap) =/= ?NOT_SET.

get_id(ItemMap) ->
  yyu_map:get_value('_id', ItemMap).

get_ver(ItemMap) ->
  yyu_map:get_value(ver, ItemMap).
incr_ver(ItemMap) ->
  CurVer = get_ver(ItemMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, ItemMap).

to_p_roleInfo(ItemMap)->
  #p_roleInfo{
    role_id = get_id(ItemMap),
    name = get_name(ItemMap),
    gender = get_gender(ItemMap),
    exp = 1,
    level = 1,
    vip = 1
  }.

get_userId(ItemMap) ->
  yyu_map:get_value(userId, ItemMap).

get_svrId(ItemMap) ->
  yyu_map:get_value(svrId, ItemMap).

get_name(ItemMap) ->
  yyu_map:get_value(name, ItemMap).

get_gender(ItemMap) ->
  yyu_map:get_value(gender, ItemMap).


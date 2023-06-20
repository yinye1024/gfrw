%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_plru_pdb_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/1,is_class/1,has_id/1,get_id/1,get_ver/1,incr_ver/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(DataId)->
  #{
    '_id' => DataId,class=>?MODULE, ver=>0

  }.

is_class(SelfMap)->
  yyu_map:get_value(class,SelfMap) == ?MODULE.

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

%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_adm_dao).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


-define(Collection, yyu_misc:to_binary(?MODULE)).

%% API functions defined
-export([create/1,update/1,get_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
create(DataId)->
  NewData = lc_mail_adm_pojo:new_pojo(DataId),
  game_mongo_dao:insert(?Collection, NewData),
  NewData.

update(UpdateData)->
  game_mongo_dao:update(?Collection, UpdateData),
  ?OK.

get_data(DataId)->
  Data = game_mongo_dao:get_by_id(?Collection, DataId),
  Data.



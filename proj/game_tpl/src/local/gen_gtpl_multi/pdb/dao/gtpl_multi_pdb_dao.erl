%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_multi_pdb_dao).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).
-define(Collection, yyu_misc:to_binary(?MODULE)).

%% API functions defined
-export([create/1,update/1,get_data/1,delete/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
create(MultiId)->
  NewData = gtpl_multi_pdb_pojo:new_pojo(MultiId),
  game_mongo_dao:insert(?Collection, NewData),
  NewData.

update(UpdateData)->
  game_mongo_dao:update(?Collection, UpdateData),
  ?OK.

get_data(MultiId)->
  Data = game_mongo_dao:get_by_id(?Collection, MultiId),
  Data.

delete(MultiId)->
  game_mongo_dao:delete(?Collection, MultiId),
  ?OK.


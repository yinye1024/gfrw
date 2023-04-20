%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_adm_holder).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(Ets_TName,?MODULE).
-define(DATA_ID,1).
%% API functions defined
-export([ets_init/0,proc_init/0]).
-export([get_data/0,update_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
ets_init()->
  yyu_ets_cache_dao:init(?Ets_TName),
  ?OK.

proc_init()->
  case lc_mail_adm_dao:get_data(?DATA_ID) of
    ?NOT_SET ->
      NewData = lc_mail_adm_dao:create(?DATA_ID),
      yyu_ets_cache_dao:put_data(?Ets_TName,?DATA_ID,NewData),
      ?OK;
    Data ->
      yyu_ets_cache_dao:put_data(?Ets_TName,?DATA_ID,Data),
      ?OK
  end,
  ?OK.

get_data()->
  Data = yyu_ets_cache_dao:get_data(?Ets_TName,?DATA_ID),
  Data.

update_data(Data)->
  lc_mail_adm_dao:update(Data),
  yyu_ets_cache_dao:put_data(?Ets_TName,?DATA_ID,Data),
  ?OK.

%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_gw_pc_dao).
-author("yinye").


-include_lib("yyutils/include/yyu_comm.hrl").

-define(DATA_TYPE,?MODULE).
-define(DATA_ID,1).

%% API functions defined
-export([init/0, is_init/0,get_data/0, put_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  yyu_proc_cache_dao:init(?DATA_TYPE),
  DataPojo = role_gw_pc_pojo:new_pojo(?DATA_ID),
  yyu_proc_cache_dao:put_data(?DATA_TYPE,?DATA_ID,DataPojo),
  ?OK.

is_init()->
  yyu_proc_cache_dao:is_inited(?DATA_TYPE).

put_data(DataPojo)->
  yyu_proc_cache_dao:put_data(?DATA_TYPE,?DATA_ID,DataPojo),
  ?OK.

get_data()->
  DataPojo = yyu_proc_cache_dao:get_data(?DATA_TYPE,?DATA_ID),
  DataPojo.

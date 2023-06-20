%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_single_pdb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/1]).
-export([get_data/0,update_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(SingleId)->
  gtpl_single_pdb_holder:init(SingleId),
  ?OK.

get_data()->
  SingleId = gtpl_single_pc_mgr:get_singleId(),
  Data = gtpl_single_pdb_holder:get_data(SingleId),
  Data.

update_data(SingleData)->
  NewSingleData = gtpl_single_pdb_pojo:incr_ver(SingleData),
  gtpl_single_pdb_holder:put_data(NewSingleData),
  ?OK.

%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_multi_pdb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/1,update_to_db/0]).
-export([get_data/0,update_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(MultiId)->
  gtpl_multi_proc_db:init(),
  gtpl_multi_pdb_holder:init(MultiId),
  ?OK.
update_to_db()->
  gtpl_multi_proc_db:update_to_db(),
  ?OK.

get_data()->
  MultiId = gtpl_multi_pc_mgr:get_multiId(),
  Data = gtpl_multi_pdb_holder:get_data(MultiId),
  Data.

update_data(MultiData)->
  NewMultiData = gtpl_multi_pdb_pojo:incr_ver(MultiData),
  gtpl_multi_pdb_holder:put_data(NewMultiData),
  ?OK.


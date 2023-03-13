%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(tpl_single_proc_db).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(DataMapKey,tpl_single_pdb_dk).
-define(VerMapKey,tpl_single_pdb_vk).

%% API functions defined
-export([init/0, get_data/1,get_all_dataList/0,put_data/2,remove_data/1,update_to_db/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  yyu_proc_db_dao:init({?DataMapKey,?VerMapKey}),
  ?OK.

get_data(Key)->
  Data = yyu_proc_db_dao:get_data(?DataMapKey,Key),
  Data.

get_all_dataList()->
  DataList = yyu_proc_db_dao:get_all_dataList(?DataMapKey),
  DataList.

put_data({Key,Data,Ver},UpdateFun)->
  yyu_proc_db_dao:put_data({?DataMapKey,?VerMapKey},{Key,Data,Ver},UpdateFun),
  ?OK.

remove_data(Key)->
  yyu_proc_db_dao:remove_data({?DataMapKey,?VerMapKey},Key),
  ?OK.

update_to_db()->
  yyu_proc_db_dao:update_to_db({?DataMapKey,?VerMapKey}),
  ?OK.

%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_plrudb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/1,update_to_db/0,check_lru/0]).
-export([new_role/1,set_online/2, update_role/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(_GenId)->
  gtpl_plrudb_holder:proc_init(),
  ?OK.
update_to_db()->
  gtpl_plrudb_holder:update_to_db(),
  ?OK.
check_lru()->
  gtpl_plrudb_holder:check_lru(),
  ?OK.



new_role(GlbTpl)->
  gtpl_plrudb_holder:put_data(GlbTpl),
  ?OK.

set_online(TplId,IsOnline)->
  GlbTpl = priv_get_data(TplId),
  NewGlbTpl = gtpl_plru_pdb_pojo:set_is_online(IsOnline,GlbTpl),
  update_role(NewGlbTpl),
  ?OK.

priv_get_data(TplId)->
  Data = gtpl_plrudb_holder:get_data(TplId),
  Data.

update_role(GlbTpl)->
  NewGlbTpl = gtpl_plru_pdb_pojo:incr_ver(GlbTpl),
  gtpl_plrudb_holder:put_data(NewGlbTpl),
  ?OK.


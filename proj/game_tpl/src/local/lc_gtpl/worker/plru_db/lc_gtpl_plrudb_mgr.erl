%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_gtpl_plrudb_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/1,update_to_db/0,check_lru/0]).
-export([new_gtpl/1,set_online/2, update_gtpl/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init(_GenId)->
  lc_gtpl_plrudb_holder:proc_init(),
  ?OK.
update_to_db()->
  lc_gtpl_plrudb_holder:update_to_db(),
  ?OK.
check_lru()->
  lc_gtpl_plrudb_holder:do_lru(),
  ?OK.



new_gtpl(GlbTpl)->
  lc_gtpl_plrudb_holder:put_data(GlbTpl),
  ?OK.

set_online(TplId,IsOnline)->
  GlbTpl = priv_get_data(TplId),
  NewGlbTpl = lc_gtpl_pdb_pojo:set_is_online(IsOnline,GlbTpl),
  update_gtpl(NewGlbTpl),
  ?OK.

priv_get_data(TplId)->
  Data = lc_gtpl_plrudb_holder:get_data(TplId),
  Data.

update_gtpl(GlbTpl)->
  NewGlbTpl = lc_gtpl_pdb_pojo:incr_ver(GlbTpl),
  lc_gtpl_plrudb_holder:put_data(NewGlbTpl),
  ?OK.


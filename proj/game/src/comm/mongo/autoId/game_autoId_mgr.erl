%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 13. 1月 2023 17:23
%%%-------------------------------------------------------------------
-module(game_autoId_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API
-export([get_role_autoId/0]).
get_role_autoId()->
  priv_get_autoId(role).

priv_get_autoId(Key)->
  SvrId = game_cfg:get_svrId(),
  AutoIdName =   yyu_misc:to_atom((yyu_misc:to_list(Key)++"_"++yyu_misc:to_list(SvrId))),
  ?LOG_INFO({autoId_name,AutoIdName}),
  NewAutoId = game_mongo_dao:incr_and_get_autoId(AutoIdName),
  NewAutoId.
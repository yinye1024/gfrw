%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_res_data_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(BsDataKey,?MODULE).
%% API functions defined
-export([get_data/0,put_data/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_data()->
  case robot_pc_mgr:get_bs_data(?BsDataKey) of
    ?NOT_SET -> robot_res_data:new_pojo();
    BsData ->BsData
  end.

put_data(BsData)->
  robot_pc_mgr:put_bs_data(?BsDataKey,BsData).


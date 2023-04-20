%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 13. 4月 2023 9:15
%%%-------------------------------------------------------------------
-module(ts_tester).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
%% API
-export([do/0]).
do()->

%%  Params = [<<"RoleId">>,<<"MailType">>],
%%  P1 = string:join(Params,","),
%%  P2 = "{"++P1++"}",
%%  {RoleId,MailType,Title,Content,AttachItemList} = yyu_misc:string_to_term(),

  yyu_misc:term_to_string({1034,1,"biaoti","内容"}),
  yyu_misc:string_to_term("{1034,11,aaa,aaa,aa}").
%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     返回分页结果
%%% @end
%%% Created : 20. 十月 2021 14:47
%%%-------------------------------------------------------------------
-module(adm_httpd_resp_page).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(Page_Item_Count,10).

%% API functions defined
-export([new_success/3,new_fail/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_success(PageNo,TotalCount,List) ->
  #{
     success=>?TRUE,
     pageNo=> PageNo,           %% 当前页数
     totalCount=> TotalCount,       %% 总共条数
     totalPage=>TotalCount div ?Page_Item_Count, %% 总页数
     pageItemCount=> ?Page_Item_Count,    %% 单页条数

     list=> List   %%每页显示数据记录的集合
  }.

new_fail(Tips) ->
  #{
    tips => Tips,
    success=> ?FALSE
  }.


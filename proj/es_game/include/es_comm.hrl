%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 四月 2021 11:50
%%%-------------------------------------------------------------------
-author("yinye").

-ifndef(ES_COMM).
-define(ES_COMM,es_comm_hrl).



-define(TRUE,true).
-define(FALSE,false).

-define(OK,ok).
-define(Skip,skip).
-define(FAIL,fail).

-define(REPLY,reply).
-define(NO_REPLY,noreply).
-define(STOP,stop).
-define(NORMAL,normal).
-define(ERROR,error).
-define(UNKNOWN,unknown).

-define(UNDEFINED,undefined).
-define(NOT_FOUND,not_found).
-define(NOT_SET,not_set).
-define(NO_CHANGE,no_change).


-define(IF(C,TF,FF),(case (C) of ?TRUE ->(TF);?FALSE->(FF) end)).
-define(IF(C,TF),(case (C) of ?TRUE ->(TF);?FALSE->?OK end)).


-endif.
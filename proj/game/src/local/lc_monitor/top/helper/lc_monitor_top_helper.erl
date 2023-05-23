%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(lc_monitor_top_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([get_sup_mod/1, find_all_top_list/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_sup_mod(Pid) ->
  case recon:info(Pid,dictionary) of
    {dictionary,Dict}->
      case lists:keyfind('$ancestors',1,Dict) of
        {'$ancestors',[SupAtom|_Less]} ->
          SupAtom;
        _Other ->
          ?NOT_SET
      end;
    _ ->
      ?NOT_SET
  end.

%% return {MsgLenTopList,MemTopList,RedsTopList,InrcRedsTopList}
find_all_top_list(TopSize,TopItemList)->
  {MsgLenGbT,MemGbt,RedsGbt,InrcRedsGbt} = priv_insert_item(TopItemList, TopSize,{gb_trees:empty(),gb_trees:empty(),gb_trees:empty(),gb_trees:empty()}),
  {
    priv_to_topItem_list(gb_trees:to_list(MsgLenGbT),[]),
    priv_to_topItem_list(gb_trees:to_list(MemGbt),[]),
    priv_to_topItem_list(gb_trees:to_list(RedsGbt),[]),
    priv_to_topItem_list(gb_trees:to_list(InrcRedsGbt),[])
  }.

priv_insert_item([TopItem|Less], TopSize,{MsgLenGbT,MemGbt,RedsGbt,InrcRedsGbt}) ->
  {MsgLen,Mem,Reds,InrcReds} = lc_monitor_top_pc_item:get_cur_values(TopItem),
  MsgLenGbT_1 = priv_insert_to_gbTree({MsgLen,TopItem},TopSize,MsgLenGbT),
  MemGbt_1 = priv_insert_to_gbTree({Mem,TopItem},TopSize,MemGbt),
  RedsGbt_1 = priv_insert_to_gbTree({Reds,TopItem},TopSize,RedsGbt),
  InrcRedsGbt_1 = priv_insert_to_gbTree({InrcReds,TopItem},TopSize,InrcRedsGbt),
  priv_insert_item(Less, TopSize,{MsgLenGbT_1,MemGbt_1,RedsGbt_1,InrcRedsGbt_1});
priv_insert_item([], _TopSize,{MsgLenGbT,MemGbt,RedsGbt,InrcRedsGbt})->
  {MsgLenGbT,MemGbt,RedsGbt,InrcRedsGbt}.

priv_insert_to_gbTree({AttrVal,TopItem},TopSize,GbTree)->
  GbTree_1 =
    case gb_trees:size(GbTree) >= TopSize of
      ?TRUE ->
        case AttrVal =< 0 of
          ?FALSE ->
            case gb_trees:smallest(GbTree) of
              {AttrVal, TopItemList} ->
                priv_update_key({AttrVal,TopItemList},TopItem,TopSize,GbTree);
              {SmallestAttr, _OriItemList} when AttrVal > SmallestAttr ->
                GbTreeTmp = gb_trees:delete_any(SmallestAttr, GbTree),
                priv_insert_or_update_key(AttrVal,TopItem,TopSize,GbTreeTmp);
              _ ->
                GbTree
            end;
          ?TRUE ->
            GbTree
        end;
      ?FALSE ->
        priv_insert_or_update_key(AttrVal,TopItem,TopSize,GbTree)
    end,
  GbTree_1.

priv_update_key({AttrVal,TopItemList},TopItem,TopSize,GbTree)->
  GbTree_1 =
  case yyu_list:size_of(TopItemList) >= TopSize of
    ?TRUE -> GbTree;
    ?FALSE ->
      gb_trees:update(AttrVal, [TopItem | TopItemList], GbTree)
  end,
  GbTree_1.
priv_insert_or_update_key(AttrVal,TopItem,TopSize,GbTree)->
  GbTree_1 =
    case gb_trees:lookup(AttrVal,GbTree) of
      {value, TopItemList}->
        priv_update_key({AttrVal,TopItemList},TopItem,TopSize,GbTree);
      _ ->
        gb_trees:insert(AttrVal, [TopItem], GbTree)
    end,
  GbTree_1.

priv_to_topItem_list([{_AttrVal, TopItemList}|Less],AccList)->
  AccList_1 = yyu_list:union_add_all(TopItemList,AccList),
  priv_to_topItem_list(Less,AccList_1);
priv_to_topItem_list([],AccList)->
  yyu_list:reverse(AccList).


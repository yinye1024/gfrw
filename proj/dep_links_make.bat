:: game
mklink /D %~dp0\game\_checkouts\protobuf\  %~dp0\protobuf
mklink /D %~dp0\game\_checkouts\yyutils\  %~dp0\..\..\yyutils
mklink /D %~dp0\game\_checkouts\network\  %~dp0\..\..\network
mklink /D %~dp0\game\_checkouts\mgd4erl\  %~dp0\..\..\mgd4erl


:: stress
mklink /D %~dp0\stress\_checkouts\game\  %~dp0\game
mklink /D %~dp0\stress\_checkouts\protobuf\  %~dp0\protobuf
mklink /D %~dp0\stress\_checkouts\yyutils\  %~dp0\..\..\yyutils
mklink /D %~dp0\stress\_checkouts\network\  %~dp0\..\..\network
mklink /D %~dp0\stress\_checkouts\mgd4erl\  %~dp0\..\..\mgd4erl
pause
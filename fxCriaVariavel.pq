/*
   fxCriaParametros
   Objetivo : Cria parametros contidos na tabela tbParametros
   Autor....: ROGERIO TONINI
   Data.....: 25/04/2024
   ---------------------------------------------------------------------------------------
   Parametro:
   _Parametro - Nome do parametro a ser criado
*/

(
    _strParametro as text
) =>

let
     SelecionaVariavel = 
        Table.SelectRows(
           dParametros, 
            each 
                Text.Upper([Parametros]) = Text.Upper(_strParametro)
        ),

    _TipoColuna = 
        Text.Upper(SelecionaVariavel{0}[TpDado]),

    AlteraTpColuna = 
        Table.TransformColumnTypes(
            SelecionaVariavel,
            if _TipoColuna = "D"
                then
                    { {"Valor", type date} }

            else if _TipoColuna = "L"
                then
                    { {"Valor", type logical} }

            else if _TipoColuna = "N"
                then
                    { {"Valor", type number} }

                else
                    { {"Valor", type text} }
        ),

    ValorColuna = 
        AlteraTpColuna{0}[Valor]
in
    ValorColuna
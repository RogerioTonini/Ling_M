/*
* Função..: fxCorrigeCabec
* Objetivo: Retirar espaços do nome das colunas
* Criador.: ROGERIO TONINI - rogerio.tonini@gmail.com
* Data....: 29/08/2024
* -------------------------------------------------------------------------
* Parametros:
*   _Tabela : Nome da tabela a ser tratada
*/
(
    _Tabela as table
) =>

let
    FonteDados = 
        List.Transform(
            Table.ColumnNames(_Tabela), 
            each Text.Replace(_, " ", "")
        ),

    ColunasRenomeadas = 
        Table.Buffer(
            Table.RenameColumns(
                _Tabela, 
                List.Zip(
                    {
                        Table.ColumnNames(_Tabela), 
                        FonteDados
                    }
                )
            )
        )
in
    ColunasRenomeadas
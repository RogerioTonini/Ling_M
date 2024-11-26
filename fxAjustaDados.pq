/*
* Função..: fxAjustaDados
* Objetivo: Retirar espaços do nome das colunas
* Criador.: ROGERIO TONINI - rogerio.tonini@gmail.com
* Data....: 30/08/2024
* -------------------------------------------------------------------------
* Parametros:
*   _Tabela....: Nome da tabela a ser tratada
    _NomeColuna: Nome da coluna a tratar
    _TpAjuste..: 0 = Caracteres Minúsculos / 1 = Caractres Maiúsculos
*/
(
    _Tabela     as table,
    _NomeColuna as text, 
    _TpAjuste   as number
) =>

let
    TabelaDados =
        Table.TransformColumns(
            Table.TransformColumns(
                _Tabela,
                {
                    {_NomeColuna, Text.Trim}
                }
            ),
            {
                if _TpAjuste = 0 then
                    {_NomeColuna, Text.Lower}
                else
                    {_NomeColuna, Text.Upper}
            }
        )
in
    TabelaDados
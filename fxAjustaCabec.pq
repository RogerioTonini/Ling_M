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
let
    Rotina = 
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
        TabelaDados,

    metadados = [
        Documentation.Name  = "fxAjustaCabec",
        Documentation.Description = "
            Retirar espaços dos nomes das colunas e configurar todos os caracteres para mínusculos ou o 1º maiúsculo
            por Rogerio Tonini, rogerio.tonini@gmail.com, +55 11 98504-8872",

        Documentation.Examples = {
            // exemplo 01
            [
                Description = "descricao do exemplo 1",
                Code = "
                    ConcatenaLinhasEmUnicoTexto(

                        | Cod | 
                        |   A |                    
                        |  BB |                       
                        | CCC |  

                        , ','
                    )                          
                ",
                Result = "
                    A, BB, CCC             
                "
            ]
        }
    ]
in
    Value.ReplaceType( Rotina, Value.ReplaceMetadata( Value.Type( Rotina ), metadados ) )
/*
    Função..: fxExplodeDados_XLS
    Objetivo: Expandir as colunas de um arquivo com as extensão: XLS, XLSX, XLSB
    Criador.: ROGERIO TONINI
    Data....: 10/10/2023
    -------------------------------------------------------------------------
    Parametros:
        _NomeArquivo: Nome do arquivo a ser tratado
*/

(
    _CaminhoArquivo as text,
    _NomeDoArquivo  as text
) =>

let
    Source = 
        Excel.Workbook(
            File.Contents( _CaminhoArquivo & _NomeDoArquivo ), 
            null, 
            true
        ),

    SelecionaTabela =
        Table.Buffer(
            Source{ [ Item = "CategoriaProduto" ,Kind = "Sheet" ] }[Data]
        ),

    Cfg_Cabec = 
        Table.PromoteHeaders(
            SelecionaTabela, 
            [ PromoteAllScalars = true ]
        )
in
    Cfg_Cabec
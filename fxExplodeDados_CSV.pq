/*
    Função..: fxExplodeDados_CSV
    Objetivo: Expandir as colunas de um arquivo de extensão: CSV, TXT
    Criador.: ROGERIO TONINI
    Data....: 10/10/2023
    -------------------------------------------------------------------------
    Parametros:
        _LocalArquivos...: Caminho + Nome do arquivo a ser tratado
        _CaracterDelimit.: Caracter Delimitador que separa os dados
        _NumeroColunas...: Quantidade de colunas que contém o arquivo
        _Cod_Encoding....: Código dos caracteres especiais
*/

(
    _LocalArquivos   as text,
    _CaracterDelimit as text, 
    _NumeroColunas   as number, 
    _Cod_Encoding    as number
) =>

let
    FonteDados = 
        Csv.Document(
            File.Contents(_LocalArquivos), 
            [
                Delimiter  = _CaracterDelimit, 
                Columns    = _NumeroColunas, 
                Encoding   = _Cod_Encoding,
                QuoteStyle = QuoteStyle.None
            ]
        )
in
    FonteDados
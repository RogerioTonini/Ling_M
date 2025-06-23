(
    _strPasta   as text,
    _strExtArqs as text
) =>

let
    FonteDados = 
        Table.SelectRows(
            Folder.Files( _strPasta ),
            each ( [Extension] = _strExtArqs )
        ),

    Caminho_E_Arquivo =
        Table.CombineColumns(
            FonteDados,
            {
                "Folder Path", 
                "Name"
            },
            Combiner.CombineTextByDelimiter(
                "", 
                QuoteStyle.None
            ),
            "Caminho_E_Arquivo"
        ),

    ConteudoArquivos =
        Table.AddColumn(
            Caminho_E_Arquivo, 
            "ConteudoArquivos", 
            each 
                fxExplodeDados_CSV(
                    [Caminho_E_Arquivo], 
                    _CaractereDelimitador, 
                    _QtdColunas,      /* Quatidade de colunas */
                    _CodigoEncoding   /* Código Encondig */
                )
            ),

    ColunasMantidas = 
        Table.SelectColumns(
            ConteudoArquivos,
            {"ConteudoArquivos"}
        )
in
    ColunasMantidas
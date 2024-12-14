// (
    // __PathFiles as text
// ) as table =>

let
    FonteDados =
        Table.SelectRows(
            Folder.Files( _CaminhoArquivos ),
            each [Extension] = _ExtensaoArquivos
        ),

    RemoveOutrasColunas = 
        Table.SelectColumns(
            FonteDados,
            {"Content"}
        ),

    ADD_ColConteudoArquivo = 
        Table.AddColumn(
            RemoveOutrasColunas,
            "ConteudoArquivos", 
            each 
                Csv.Document(
                    [Content],
                    [
                        Delimiter  = _CaractereDelimitador,
                        Columns    = _QtdColunas,
                        Encoding   = _CodigoEncoding,
                        QuoteStyle = QuoteStyle.None
                    ]
                )
        ),

    ColunaMantida = 
        Table.SelectColumns(
            ADD_ColConteudoArquivo,
            {"ConteudoArquivos"}
        ),

    _DadosExpandidos_ = 
        Table.Buffer(
            fxExpandeColunasTabela_Teste(
                ColunaMantida, 
                "ConteudoArquivos"
            )
        )
in
    ColunaMantida
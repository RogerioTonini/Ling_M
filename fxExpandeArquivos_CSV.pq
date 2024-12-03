(
    __CaminhoArquivo as text
) as table =>
let
    FonteDados =
        Table.SelectRows(
            Folder.Files( __CaminhoArquivo ),
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

    _DadosExpandidos_ = 
        Table.Buffer(
            fxExpandeColunasTabela(
                ADD_ColConteudoArquivo, 
                "ConteudoArquivos"
            )
        )
in
    _DadosExpandidos_
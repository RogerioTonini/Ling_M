(
    _CaminhoArquivo as text,
    _NomeDoArquivo  as text,
    _TipoDaConsulta as text
) as table =>

let
    Source = 
        Table.SelectRows(
            Folder.Files( _CaminhoArquivo ), 
            each [Name] = _NomeDoArquivo 
        ),

    RemoveColunas = 
        Table.SelectColumns(
            Source,
            { "Content" }
        ),

    ADD_ConteudoArquivo = 
        Table.AddColumn(
            RemoveColunas, 
            "ConteudoArquivo", 
            each Excel.Workbook( [Content] )
        ),

    ColunaMantida = 
        Table.SelectColumns(
            ADD_ConteudoArquivo,
            {"ConteudoArquivo"}
        ),

    ExpandeDados = 
        fxExpandeColunasTabela( 
            ColunaMantida, 
            "ConteudoArquivo" 
        )
in
    Table.Buffer(
        Table.SelectRows(
            ExpandeDados, 
            each [Kind] = _TipoDaConsulta
        )
    )
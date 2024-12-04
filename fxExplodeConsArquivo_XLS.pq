(
    __CaminhoArquivo as text,
    __NomeDoArquivo  as text,
    __TipoDaConsulta as text
) as table =>

let
    Source = 
        Table.SelectRows(
            Folder.Files( __CaminhoArquivo ), 
            each [Name] = __NomeDoArquivo 
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
            each [Kind] = __TipoDaConsulta
        )
    )
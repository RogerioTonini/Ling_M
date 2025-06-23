(
    _strPasta   as text,
    _strExtArqs as text
) =>

let
    FonteDados =
        Table.SelectRows(
            Table.TransformColumns(
                Folder.Files( _strPasta ),
                { {"Extension", Text.Upper, type text} }
            ),
            each [Extension] = _strExtArqs
        ),

    Caminho_E_Arquivo =
        Table.CombineColumns(
            FonteDados,
            { "Folder Path", "Name" },
            Combiner.CombineTextByDelimiter(
                "",
                QuoteStyle.None
            ),
            "Caminho_E_Arquivo"
        ),

    ColunasMantidas = 
        Table.Buffer(
            Table.SelectColumns(
                Caminho_E_Arquivo,
                { "Caminho_E_Arquivo" }
            )
        )
in
    ColunasMantidas
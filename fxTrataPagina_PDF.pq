// Padroniza layout extrato Banco Bradesco
(
    _Tabela   as table, 
    _PagAtual as number
) =>

let
    _QtdeColunas = 
        Table.ColumnCount( _Tabela{ [ ID_Linha = _PagAtual ] } [Data] ),

    _TabelaTemp = 
        _Tabela{ [ ID_Linha = _PagAtual ] } [Data],

    _TabelaFinal = 
        if _QtdeColunas = 6
        then
            Table.SelectColumns(
                _TabelaTemp, 
                {
                    "Column1", 
                    "Column2", 
                    "Column3", 
                    "Column4", 
                    "Column5"
                }
            )        

        else if _QtdeColunas = 7
            then
                Table.RenameColumns(
                    Table.SelectColumns(
                        _TabelaTemp, 
                        {
                            "Column1", 
                            "Column2", 
                            "Column4", 
                            "Column5", 
                            "Column6"
                        }
                    ),
                    {
                        { "Column4", "Column3" }, 
                        { "Column5", "Column4" }, 
                        { "Column6", "Column5" }
                    }
                )

        else if _QtdeColunas = 10
            then
                Table.RenameColumns(
                    Table.SelectColumns(
                        _TabelaTemp, 
                        {
                            "Column1",
                            "Column2",
                            "Column7",
                            "Column8",
                            "Column9"
                        }
                    ),
                    {
                        { "Column7", "Column3" }, 
                        { "Column8", "Column4" }, 
                        { "Column9", "Column5" }
                    }
                )

        else if _QtdeColunas = 11
            then
                Table.RenameColumns(
                    Table.SelectColumns(
                        _TabelaTemp, 
                        {
                            "Column1",
                            "Column2",
                            "Column8",
                            "Column9",
                            "Column10"
                        }
                    ),
                    {
                        { "Column8",  "Column3" }, 
                        { "Column9",  "Column4" }, 
                        { "Column10", "Column5" }
                    }
                )
        else
            Table.FromRecords(
                { [
                    Column1 = "SemDados",
                    Column2 = null,
                    Column3 = null,
                    Column4 = null,
                    Column5 = null
                ] }
            )
in
    _TabelaFinal
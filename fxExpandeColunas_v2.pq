let
    ExpandeColunas = 
        (
            _TabelaOrigem as table, 
            _NomeColuna as text
        ) as table =>
    let
        ColunaExiste =                       // Verifica se a coluna existe
            List.Contains(
                Table.ColumnNames( _TabelaOrigem ), 
                _NomeColuna
            ),

        Resultado =
            if ColunaExiste then
                let
                    Valores =               // Coleta os valores da coluna
                        Table.Column(
                            _TabelaOrigem, 
                            _NomeColuna
                        ),

                    TabRegsValidos = 
                        List.RemoveNulls( Valores ),

                    TemValor = List.Count(TabRegsValidos) > 0
                in
                    if List.Count(TabRegsValidos) > 0 then
                        let
                            _PrimRegistro = TabRegsValidos{0},
                            
                            TabelaExpandida =
                                if Value.Is( _PrimRegistro, type record) then
                                    Table.ExpandRecordColumn(
                                        _TabelaOrigem,
                                        _NomeColuna,
                                        List.Union(
                                            List.Transform(
                                                TabRegsValidos, 
                                                each Record.FieldNames( _ )
                                            )
                                        )
                                    )
                                else if Value.Is( _PrimRegistro, type table) then
                                    Table.ExpandTableColumn(
                                        _TabelaOrigem,
                                        _NomeColuna,
                                        List.Union(
                                            List.Transform(
                                                TabRegsValidos, 
                                                each Table.ColumnNames( _ )
                                            )
                                        )
                                    )
                                else
                                    _TabelaOrigem
                                    // error "A coluna '" & _NomeColuna & "' não é do tipo 'record' nem 'table'."
                        in
                            TabelaExpandida
                    else
                        _TabelaOrigem
            else
                _TabelaOrigem
                // error "A coluna '" & _NomeColuna & "' não existe na tabela."
    in
        Resultado,

       metadados = 
            [
                Documentation.Name = 
                    "Função: fxExpandeColunas( TabelaOrigem, NomeColuna (nome da coluna que contém as demais colunas ) ). A Saída é uma Tabela",

                Documentation.Description = 
                    "Objetivo: Expandir colunas de Tabelas que contenham registros tipo: [ Record ] ou [ Table ],
                     detectando o tipo de dado e aplicando a expansão correta.  ||
                       Data criação: Jun/2025 / Autor: Rogerio Tonini   ||
                       Contatos: e-mail....: rogerio.tonini@gmail.com   ||
                       LinkedIn: www.linkedin.com/in/rogerio-tonini  ||
                       GitHub: https://github.com/RogerioTonini/Ling_M/blob/main/fxExpandeColunas_v2.pq   ||
                       Discord / Telegram / Whatsapp: (11) 98504-8872",
                Documentation.Examples = 
                    {
                        [
                            Description = 
                                "Expandir uma coluna do tipo 'record'",

                            Code = 
                                "fxExpandirColuna(
    Table.FromRecords(
        {
            [ Dados = [ a = 1, b = 2 ] ],
            [ Dados = [ a = 3, b = 4 ] ]
        }
    ),
    ""Dados""
)",

                            Result = 
                                "a | b
--|--
1 | 2
3 | 4"
                        ],
                        [
                            Description =
                                "Expandir uma coluna do tipo 'table'",
                            Code = 
                                "fxExpandirColuna(
    Table.FromRecords(
        {
            [ SubTabela = #table( { ""ID"", ""Nome"" }, { {1, ""Ana""    }, { 2,  ""Bruno""} } ) ],
            [ SubTabela = #table( { ""ID"", ""Nome"" }, { {3, ""Carlos"" }, { 4, ""Duda""  } } ) ]
        }
    ),
    ""SubTabela""
)",

                            Result = 
                                "ID | Nome
---|-----
1  | Ana
2  | Bruno
3  | Carlos
4  | Duda"
                        ]
                    }
            ]
in
    Value.ReplaceType(
        ExpandeColunas, 
        Value.ReplaceMetadata(
            Value.Type( ExpandeColunas ), 
            metadados
        )
    )
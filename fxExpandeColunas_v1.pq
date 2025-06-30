(
    _TabelaOrigem as table,
    _NomeColuna   as text
) as table =>

let
    ColunaExiste =              // Verifica se a coluna existe na tabela
        List.Contains(
            Table.ColumnNames( _TabelaOrigem ), 
            _NomeColuna
        ),

    _TabelaDados_ = 
        if not ColunaExiste then
            _TabelaOrigem
        else
            let
                Valores =                           // Coleta os valores da coluna
                    Table.Column(
                        _TabelaOrigem,
                        _NomeColuna
                    ),

                TabelaRegsValidos =                 // Remove nulos
                    List.RemoveNulls( Valores ),

                TabelaFinal =                       // Verifica se há valores válidos
                    if List.Count( TabelaRegsValidos ) = 0 then
                        _TabelaOrigem
                    else
                        let
                            PrimeiroValor = TabelaRegsValidos{0},

                            ExpandeRecord =         // Expansão para tipo record
                                let
                                    _ListaCampos = 
                                        List.Union(
                                            List.Transform(
                                                TabelaRegsValidos, 
                                                each Record.FieldNames( _ )
                                            ) 
                                    ),

                                    TabelaExpandida =
                                        Table.ExpandRecordColumn(
                                            _TabelaOrigem,
                                            _NomeColuna, 
                                            _ListaCampos, 
                                            _ListaCampos
                                        )
                                in
                                    TabelaExpandida,

                            ExpandeTabela =         // Expansão para tipo table
                                let
                                    _ListaCampos = 
                                        List.Union(
                                            List.Transform(
                                                TabelaRegsValidos, 
                                                each Table.ColumnNames( _ )
                                            )
                                        ),

                                    TabelaExpandida =
                                        Table.ExpandTableColumn(
                                            _TabelaOrigem,
                                            _NomeColuna,
                                            _ListaCampos,
                                            _ListaCampos)
                                in
                                    TabelaExpandida,

                            
                            ResultadoDetectado =    // Verifica tipo e aplica expansão
                                if Value.Is( PrimeiroValor, type record ) then
                                    ExpandeRecord
                                else if Value.Is( PrimeiroValor, type table ) then
                                    ExpandeTabela
                                else
                                    _TabelaOrigem
                        in
                            ResultadoDetectado
                in
                    TabelaFinal
in
    _TabelaDados_
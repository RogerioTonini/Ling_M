// Carga arquivos PDF - Extrato Banco Bradesco 

(
    _CaminhoArquivos as text
) =>

let
    FonteDados = 
        Pdf.Tables(
            File.Contents( _CaminhoArquivos ), 
                [Implementation="1.3"]
        ),

    TipoFiltrado = 
        Table.SelectRows(
            FonteDados, 
            // variavel: _FiltroDados_PDF, contém o tipo (Kind) do filtro a ser aplicado
            each ( [Kind] = _FiltroDados_PDF )
        ),

    ADD_ID_Linha = 
        Table.AddIndexColumn(
            TipoFiltrado,
            "ID_Linha",
            0,
            1,
            Int32.Type
        ),

    DadosTratados = 
        Table.AddColumn(
            ADD_ID_Linha, 
            "TabelaDados", 
            each fxTrataPagina_PDF( ADD_ID_Linha, [ID_Linha] )
        ),

    _ExplodeDados_ = 
        Table.Buffer( 
            Table.SelectColumns(
                fxExpandeColunasTabela( 
                    DadosTratados, 
                    "TabelaDados" 
                ),
                {
                    "Column1",
                    "Column2",
                    "Column3",
                    "Column4",
                    "Column5"
                }
            )
        )
in
    _ExplodeDados_
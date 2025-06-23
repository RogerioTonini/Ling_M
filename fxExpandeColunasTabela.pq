(
   _NomeTabela      as table,
   _NomeColunaDados as text
)  as table =>

let
    // Lista que contém os arquivos importados em forma de Tabela
    Etapa1 =
        Table.Column(
            _NomeTabela,
            _NomeColunaDados
        ),

    // Converte as Tabelas para Listas e ao invés dos Dados, captura o nome das Colunas
    Etapa2 =
        List.Transform(
            Etapa1,
            each Table.ColumnNames(_)
        ),

    // Cria uma Lista contendo o Nome de todas as colunas
    ListaNomeColunas =
        List.Union(
            Etapa2
        ),

    Saida =
        Table.ExpandTableColumn(
            _NomeTabela,
            _NomeColunaDados,
            ListaNomeColunas,
            ListaNomeColunas
        )
in
    Saida

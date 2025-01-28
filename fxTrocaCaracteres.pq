//
// Função que substitui valores específicos por outros, no caso [null] por VAZIO
//
(
    _Tabela as table
) as table =>
let
	_NomesColunas = 
        List.Buffer(Table.ColumnNames(_Tabela)),
    ValorSubstituido = 
		Table.ReplaceValue(
			_NomesColunas,
			null,
			"",
			Replacer.ReplaceValue,
			_NomesColunas
		)
in
    ValorSubstituido

// Tabela exemplo:
// Original:
// +------+------+------+
// |  A   |   B  |   C  |
// +------+------+------+
// |   29 |   43 |   41 |
// |   33 | null |   41 |
// | null |   52 |   99 |
// |   10 |   67 | null |
// +------+------+------+
//
// Transformada:
// +----+----+----+
// |  A |  B | C  |
// +----+----+----+
// | 29 | 43 | 41 |
// | 33 |    | 41 |
// |    | 52 | 99 |
// | 10 | 67 |    |
// +----+----+----+
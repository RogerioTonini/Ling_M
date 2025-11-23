(
    _LocalArquivos   as text,
    _CaracterDelimit as text, 
    _Cod_Encoding    as number
) =>

let
    FonteDados = 
        Csv.Document(
            File.Contents(_LocalArquivos), 
            [
                Delimiter  = _CaracterDelimit, 
                Encoding   = _Cod_Encoding,
                QuoteStyle = QuoteStyle.None
            ]
        )
in
    FonteDados
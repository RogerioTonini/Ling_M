// fxConvDatasToTexto ==> Trata a quantidade de caracteres dos números dos Meses / Dias

(
    _dateValue as date
)  as text =>
    
let
    TransformDateToText = 
        Text.From(Date.Year(_dateValue)) & 
        Text.PadStart(Text.From(Date.Month(_dateValue)), 2, "0") & 
        Text.PadStart(Text.From(Date.Day(_dateValue)), 2, "0")
in
    TransformDateToText
// fxConvDatasToTexto ==> Trata a quantidade de caracteres dos números dos Meses / Dias

(
    _dateValue as date
)  as text =>
    
let
    TransformDateToText = 
        Text.From(Date.Year(_dateValue)) & 
        Text.PadStart(Text.From(Date.Month(_dateValue)), 2, "0") & 
        Text.PadStart(Text.From(Date.Day(_dateValue)), 2, "0"),

    /* ------------------------------ DOCUMENTAÇÃO ------------------------------ */

    metadados = [
        Documetation.Name = "fxConverteDatasToTexto.pq",
        Documentation.Description = 
            "---------------------------------------------------------------------------------------------
            Objetivo da Função.: Completar com o caractere Zero a esquerda nos Meses/Dias que forem 
                                    menor que 10 e formatar a data como YYYYmmdd
            Data...............: 28/08/2024
            Autor..............: Rogerio Tonini 
            Contatos...........: e-mail...: rogerio.tonini@gmail.com
                                 LinkedIn.: www.linkedin.com/in/rogerio-tonini
                                 Discord / Telegram / Whatsapp.: +55 11 98504-8872
            ---------------------------------------------------------------------------------------------",
        Documentation.Example = {
            [
                Description = "
                fxConverteDataToTextod(_dateValue)
                Parametro(s) a ser(em) passados:
                    _dateValue : Data"
            ]
        }
    ]
in
    Value.ReplaceType(
        TransformDateToText,
        Value.ReplaceMetadata(
            Value.Type( TransformDateToText ), 
            metadados
        )
    )
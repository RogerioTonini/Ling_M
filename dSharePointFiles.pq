/*
* Rotina....:tbArquivosSharePoint 
* Objetivo..: Filtrar o conteudo de um site qualquer do SharePoint
* Criado por: ROGERIO TONINI
* Data......: 28/08/2024
*/

let
    FonteDados = 
        Table.Buffer(
            SharePoint.Contents(
                _CaminhoArquivos, 
                [ApiVersion = 15]
            )
            // Seleciona a Pasta que contém os Arquivos, no exemplo "Arquivos_a_Tratar"
            {[Name="Shared Documents"]}[Content]
            {[Name="General"]}[Content]
            {[Name="Arquivos_a_Tratar"]}[Content]
        ),

    /* ------------------------------ DOCUMENTAÇÃO ------------------------------ */

    metadados = [
        Documetation.Name = "dSharePointFiles.pq",
        Documentation.Description = "
            ---------------------------------------------------------------------------------------------
            Objetivo da Função.: Filtrar o conteúdo de uma ou mais Pastas em um Site do SharePoint
            Data...............: 28/08/2024
            Autor..............: Rogerio Tonini 
            Contatos...........: e-mail...: rogerio.tonini@gmail.com
                                 LinkedIn.: www.linkedin.com/in/rogerio-tonini
                                 Discord / Telegram / Whatsapp.: +55 11 98504-8872
            ---------------------------------------------------------------------------------------------",
        Documentation.Example = {
            [
                Description = "
                dSharePointFiles(https://WorkSpace.sharepoint.com/sites/NomeSite)
                Parametro(s) a ser(em) passados:
                    _CaminhoArquivos : Parâmetro/Variável, tipo TEXTO. Conteúdo caminho do Site.
                                        Caminho dos arquivos (CSV, PDF, TXT, XLS, etc) que serão tratados"
            ]
        }
    ]
in
    Value.ReplaceType(
        FonteDados,
        Value.ReplaceMetadata(
            Value.Type( FonteDados ), 
            metadados
        )
    )
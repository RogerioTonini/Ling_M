let
    Rotina = 

    ( _tabela as table ) as table =>

    let

        // Define uma lista de caracteres especiais
        caracteresEspeciais = 
            Text.ToList("""'`~!@#$%^&*()-_=+[]{}|;:\,.<>?/\ #(lf)#(cr)#(tab)"),

        // Função para normalizar qualquer texto em PascalCase
        fxNormalizaTextos =
            ( textoEntrada as text ) as text=>

            let
                // Remove acentuação
                textoSemAcentuacao = 
                    Text.FromBinary(Text.ToBinary(textoEntrada, 1251)),

                // Define uma função para substituir todos os caracteres especiais por espaço
                fxSubstitueCaracteresEspeciais = 
                    ( _texto as text ) as text => 
                        List.Accumulate(
                            caracteresEspeciais,
                            _texto,
                            ( state , current) => Text.Replace( state, current, " " )
                        ),

                // Aplica a função fxSubtitueEspacosPorEspaco
                textoLimpo = 
                    fxSubstitueCaracteresEspeciais(textoSemAcentuacao),

                // Capitaliza
                textoCapitalizado = 
                    Text.Proper(textoLimpo), 

                // Remove todos os espaços
                textoNormalizado = Text.Replace(textoCapitalizado, " ", "")
            in
                textoNormalizado,

        // Extrai os nomes originais das colunas da tabela
        nomesOriginais = 
            Table.ColumnNames( _tabela ), 

        // Gera uma lista normalizada dos nomes das colunas
        nomesNormalizados = 
            List.Transform( nomesOriginais, fxNormalizaTextos ), 

        // Cria uma lista "De-Para
        nomesDePara = 
            List.Zip( { nomesOriginais, nomesNormalizados } ),

        // Renomeia as colunas com os nomes normalizados
        colunasRenomeadas = 
            Table.RenameColumns( _tabela, nomesDePara )
    in
        colunasRenomeadas,

        metadados = 
            [
                Documentation.Name  = 
                    "fxNormalizaNomesColunas - Normalizar os nomes das colunas em PascalCase",
                    
                Documentation.Description = 
                    "em 16/09/2024, por Alison Pezzott, https://github.com/alisonpezzott/youtube-20240916-normaliza-colunas",

                Documentation.Examples = 
                    { [
                        Description = 
                            "Substituir todos os caracteres especiais por caracteres padrão e eliminar todos os espaços",

                        Code = 
                            "Os caracteres PIPES são os separadores das colunas. Formato das colunas na entrada dos dados: 
|Mês   Ano |% comissão#[lf]Anterior|   % Comissão    >nova_forma#[lf]final   |  diferença|",

                        Result = "| Mes | ComissaoAnterior | ComissaoNovaFormaFinal | Diferenca |"
                    ] }
            ]
in
    Value.ReplaceType( Rotina, Value.ReplaceMetadata( Value.Type( Rotina ), metadados ) )
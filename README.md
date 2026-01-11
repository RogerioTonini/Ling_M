# Funções, Scripts em  Linguagem M (Power Query)

    dimUF_Regiao - Objetivo: Criar a tabela dimensão dimUF_Regiao
                   Colunas: 
                        ID_UF,  tipo: Int32.Type, Conteúdo: ID da unidade federativa
                        NomeUF, tipo: Text.Type,  Conteúdo: Nome da unidade
                        SiglaUF tipo: Text.Type,  Conteúdo: Sigla da unidade
                        Regiao  tipo: Text.Type,  Conteúdo: Região a qual a unidade pertence

    fxNormalizaNomesColunas - Objetivo.: Normalizar os nomes das colunas em PascalCase.
                                         Substituir todos os caracteres especiais por caracteres padrão e eliminar todos os espaços
                              Parâmetro: _Tabela: Nome da **tabela** a ser tratada.

    fxSharePointFiles - Objetivo.: Filtrar o conteúdo de uma ou mais Pastas em um Site do SharePoint
                        Parâmetro: _CaminhoArquivos : Parâmetro/Variável, tipo TEXTO. Conteúdo caminho do Site. 
                                                        Caminho dos arquivos (CSV, PDF, TXT, XLS, etc) que serão tratados.

    fxTrocaCaracteres - Objetivo.: Substituir valores específicos por outros, no caso [null] por VAZIO.
                        Parâmetro: _Tabela: Nome da **tabela** a ser tratada.

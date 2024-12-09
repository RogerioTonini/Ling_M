let
    Source = 
        Table.FromRecords(
            {
                [ ID_UF =  1, Pais = "Brasil", NomeUF = "Acre",                SiglaUF = "AC", Regiao = "Norte"        ],
                [ ID_UF =  2, Pais = "Brasil", NomeUF = "Alagoas",             SiglaUF = "AL", Regiao = "Nordeste"     ],
                [ ID_UF =  3, Pais = "Brasil", NomeUF = "Amapá",               SiglaUF = "AP", Regiao = "Norte"        ],
                [ ID_UF =  4, Pais = "Brasil", NomeUF = "Amazonas",            SiglaUF = "AM", Regiao = "Norte"        ],
                [ ID_UF =  5, Pais = "Brasil", NomeUF = "Bahia",               SiglaUF = "BA", Regiao = "Nordeste"     ],
                [ ID_UF =  6, Pais = "Brasil", NomeUF = "Ceará",               SiglaUF = "CE", Regiao = "Nordeste"     ],
                [ ID_UF =  7, Pais = "Brasil", NomeUF = "Distrito Federal",    SiglaUF = "DF", Regiao = "Centro Oeste" ],
                [ ID_UF =  8, Pais = "Brasil", NomeUF = "Espírito Santo",      SiglaUF = "ES", Regiao = "Sudeste"      ],
                [ ID_UF =  9, Pais = "Brasil", NomeUF = "Goiás",               SiglaUF = "GO", Regiao = "Centro Oeste" ],
                [ ID_UF = 10, Pais = "Brasil", NomeUF = "Maranhão",            SiglaUF = "MA", Regiao = "Nordeste"     ],
                [ ID_UF = 11, Pais = "Brasil", NomeUF = "Mato Grosso",         SiglaUF = "MT", Regiao = "Centro Oeste" ],
                [ ID_UF = 12, Pais = "Brasil", NomeUF = "Mato Grosso do Sul",  SiglaUF = "MS", Regiao = "Centro Oeste" ],
                [ ID_UF = 13, Pais = "Brasil", NomeUF = "Minas Gerais",        SiglaUF = "MG", Regiao = "Sudeste"      ],
                [ ID_UF = 14, Pais = "Brasil", NomeUF = "Pará",                SiglaUF = "PA", Regiao = "Norte"        ],
				[ ID_UF = 15, Pais = "Brasil", NomeUF = "Paraíba",             SiglaUF = "PB", Regiao = "Nordeste"     ],
                [ ID_UF = 16, Pais = "Brasil", NomeUF = "Paraná",              SiglaUF = "PR", Regiao = "Sul"          ],
                [ ID_UF = 17, Pais = "Brasil", NomeUF = "Pernambuco",          SiglaUF = "PE", Regiao = "Nordeste"     ],
                [ ID_UF = 18, Pais = "Brasil", NomeUF = "Piauí",               SiglaUF = "PI", Regiao = "Nordeste"     ],
                [ ID_UF = 19, Pais = "Brasil", NomeUF = "Roraima",             SiglaUF = "RR", Regiao = "Norte"        ],
                [ ID_UF = 20, Pais = "Brasil", NomeUF = "Rondônia",            SiglaUF = "RO", Regiao = "Norte"        ],
                [ ID_UF = 21, Pais = "Brasil", NomeUF = "Rio de Janeiro",      SiglaUF = "RJ", Regiao = "Sudeste"      ],
                [ ID_UF = 22, Pais = "Brasil", NomeUF = "Rio Grande do Norte", SiglaUF = "RN", Regiao = "Nordeste"     ],
                [ ID_UF = 23, Pais = "Brasil", NomeUF = "Rio Grande do Sul",   SiglaUF = "RS", Regiao = "Sul"          ],
                [ ID_UF = 24, Pais = "Brasil", NomeUF = "Santa Catarina",      SiglaUF = "SC", Regiao = "Sul"          ],
                [ ID_UF = 25, Pais = "Brasil", NomeUF = "São Paulo",           SiglaUF = "SP", Regiao = "Sudeste"      ],
                [ ID_UF = 26, Pais = "Brasil", NomeUF = "Sergipe",             SiglaUF = "SE", Regiao = "Nordeste"     ],
                [ ID_UF = 27, Pais = "Brasil", NomeUF = "Tocantins",           SiglaUF = "TO", Regiao = "Centro Oeste" ]
            },
            type 
                table[ 
                    ID_UF   = Int32.Type, 
                    NomeUF  = Text.Type,
                    SiglaUF = Text.Type,
                    Regiao  = Text.Type
                ]
        )
in
    Source
let
    Source = 
        Table.FromRecords(
            {
                [ ID_UF =  1, NomeUF = "Acre",                SiglaUF = "AC", Regiao = "Norte"        ],
                [ ID_UF =  2, NomeUF = "Alagoas",             SiglaUF = "AL", Regiao = "Nordeste"     ],
                [ ID_UF =  3, NomeUF = "Amapá",               SiglaUF = "AP", Regiao = "Norte"        ],
                [ ID_UF =  4, NomeUF = "Amazonas",            SiglaUF = "AM", Regiao = "Norte"        ],
                [ ID_UF =  5, NomeUF = "Bahia",               SiglaUF = "BA", Regiao = "Nordeste"     ],
                [ ID_UF =  6, NomeUF = "Ceará",               SiglaUF = "CE", Regiao = "Nordeste"     ],
                [ ID_UF =  7, NomeUF = "Distrito Federal",    SiglaUF = "DF", Regiao = "Centro Oeste" ],
                [ ID_UF =  8, NomeUF = "Espírito Santo",      SiglaUF = "ES", Regiao = "Sudeste"      ],
                [ ID_UF =  9, NomeUF = "Goiás",               SiglaUF = "GO", Regiao = "Centro Oeste" ],
                [ ID_UF = 10, NomeUF = "Maranhão",            SiglaUF = "MA", Regiao = "Nordeste"     ],
                [ ID_UF = 11, NomeUF = "Mato Grosso",         SiglaUF = "MT", Regiao = "Centro Oeste" ],
                [ ID_UF = 12, NomeUF = "Mato Grosso do Sul",  SiglaUF = "MS", Regiao = "Centro Oeste" ],
                [ ID_UF = 13, NomeUF = "Minas Gerais",        SiglaUF = "MG", Regiao = "Sudeste"      ],
                [ ID_UF = 14, NomeUF = "Pará",                SiglaUF = "PA", Regiao = "Norte"        ],
				[ ID_UF = 15, NomeUF = "Paraíba",             SiglaUF = "PB", Regiao = "Nordeste"     ],
                [ ID_UF = 16, NomeUF = "Paraná",              SiglaUF = "PR", Regiao = "Sul"          ],
                [ ID_UF = 17, NomeUF = "Pernambuco",          SiglaUF = "PE", Regiao = "Nordeste"     ],
                [ ID_UF = 18, NomeUF = "Piauí",               SiglaUF = "PI", Regiao = "Nordeste"     ],
                [ ID_UF = 19, NomeUF = "Roraima",             SiglaUF = "RR", Regiao = "Norte"        ],
                [ ID_UF = 20, NomeUF = "Rondônia",            SiglaUF = "RO", Regiao = "Norte"        ],
                [ ID_UF = 21, NomeUF = "Rio de Janeiro",      SiglaUF = "RJ", Regiao = "Sudeste"      ],
                [ ID_UF = 22, NomeUF = "Rio Grande do Norte", SiglaUF = "RN", Regiao = "Nordeste"     ],
                [ ID_UF = 23, NomeUF = "Rio Grande do Sul",   SiglaUF = "RS", Regiao = "Sul"          ],
                [ ID_UF = 24, NomeUF = "Santa Catarina",      SiglaUF = "SC", Regiao = "Sul"          ],
                [ ID_UF = 25, NomeUF = "São Paulo",           SiglaUF = "SP", Regiao = "Sudeste"      ],
                [ ID_UF = 26, NomeUF = "Sergipe",             SiglaUF = "SE", Regiao = "Nordeste"     ],
                [ ID_UF = 27, NomeUF = "Tocantins",           SiglaUF = "TO", Regiao = "Centro Oeste" ]
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
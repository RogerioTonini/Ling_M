let
    _DataInicial = 
        #date( _AnoInicio, 1, 1 ),

    _DataFinal = 
        Date.EndOfYear( 
            Date.From( 
                DateTime.LocalNow()
            ) 
        ),

    _Duracao = 
        Duration.Days(_DataFinal - _DataInicial) + 1,

    _ListaDatas  = 
        List.Buffer( 
            List.Sort( 
                List.Dates( 
                    _DataInicial, 
                    _Duracao, 
                    #duration( 1, 0, 0, 0 ) 
                ), 
            Order.Ascending
            ) 
        ),

    ___ = "",

    AdicionarColunas = 
        List.Transform(
            _ListaDatas, 
            each {
                List.PositionOf( _ListaDatas, _ ) + 1,           // ID_DataBase
                Number.FromText( Date.ToText( _, "yyyyMMdd") ),  // DataBase_Serial
                Number.FromText( Date.ToText( _, "yyyyMM") ),    // AnoMes_Serial
                _,                                               // DataBase
                Date.DayOfWeek( _ ) + 1,                         // DiaSem_Num

                // DiaSem_Letra - Character.FromNumber(8203) - caractere invísivel (zero-width spacing )
                Text.Repeat( Character.FromNumber(8203), 6 -  Date.DayOfWeek( _ ) ) 
                    & Text.Start( Text.Proper( Date.ToText( _, "ddd", Culture.Current) ), 1 ),
                Text.Proper( Date.ToText( _,"ddd", Culture.Current ) ),                   // DiaSem_Abrv
                Text.Proper( Date.DayOfWeekName( _ ) ),                                   // DiaSem_Ext
                Text.PadStart( Number.ToText( Date.Day( _ ) ), 2, " " ),                  // Dia_TXT
                Date.Day( _ ),                                                            // Dia_Num
                Date.Month( _ ),                                                          // Mes_Num
                Text.Start( Text.Proper( Date.ToText( _, "MMM", Culture.Current) ), 1 ),  // MesNome_Letra
                Text.Proper( Date.ToText( _, "MMM", Culture.Current) ),                   // MesNome_Abrv
                Text.Proper( Date.MonthName( _ ) ),                                       // MesNome_Ext
                Text.Proper( Date.ToText(_, "MMM-yyyy") ),                                // MesNomeAbrv_Ano
                Text.Proper( Date.ToText(_, "MMMM-yyyy") ),                               // MesExt_Ano
                Date.Year( _ ),                                                           // Ano_Num
                Date.DaysInMonth( _ ),                                                    // QtdDiasMes
                Date.WeekOfMonth( _ ),                                                    // SemanaMes
                Date.WeekOfYear( _ ),                                                     // SemanaAno
                Number.RoundUp( Date.Month( _ ) / 2 ),                                    // Número Bimestre - Usado para ordenar
                Text.From ( Date.Year( _ ) ) & "-B" & 
                    Text.From( Number.RoundUp( Date.Month( _ ) / 2 ) ),                   // Ano + Bimestre
                Date.QuarterOfYear( _ ),                                                  // Número Trimestre - Usado para ordenar
                Text.From ( Date.Year( _ ) ) & "-T" & 
                    Text.From( Date.QuarterOfYear( _ ) ),                                 // Ano + Trimestre
                Number.RoundUp( Date.Month( _ ) / 4 ),                                    // Número Quadrimestre - Usado para ordenar
                Text.From ( Date.Year( _ ) ) & "-Q" & 
                    Text.From( Number.RoundUp( Date.Month( _ ) / 4 ) ),                   // Ano + Quadrimestre 
                Number.RoundUp( Date.Month( _ ) / 6 ),                                    // Número Semestre - Usado para ordenar
                Text.From ( Date.Year( _ ) ) & "-S" &
                    Text.From( Number.RoundUp( Date.Month( _ ) / 6 ) ),                   // Ano + Semestre

                // DiasDecorridos - Qtde de dias decorridos desde a data inicial e a data final
                Number.RoundUp( Number.From ( _ ) -  Number.From( DateTime.LocalNow() ) ),

                // MesesDecorridos - Qtde de meses decorridos desde a data inicial e a final
                ( ( ( ( Date.Year( _DataFinal ) - Date.Year( _ ) ) * 12) + ( Date.Month( _DataFinal ) ) ) - Date.Month( _ ) ),
                
                Date.StartOfMonth( _ ),      // DataMesInicio 
                Date.EndOfMonth( _ ),        // DataMesFim 
                Date.StartOfQuarter( _ ),    // DataTrimestreInicio 
                Date.EndOfQuarter( _ ),      // DataTrimestreFim
                Date.StartOfYear( _ ),       // DataAnoInicio
                Date.EndOfYear( _ ),         // DataAnoFim 

                // DiaUtil
                let
                    _Data = _,

                    _AnoData = 
                        Date.Year( _Data ),

                    _LstFinalDeSemana = 
                        List.Contains( { 0, 6 }, Date.DayOfWeek( _Data ) ),

                    fxModExcel =  
                        ( x, y ) => 
                            let 
                                m = Number.Mod( Number.From( x ), y )
                            in 
                                if m < 0 then m + y else m,

                    _DataPascoa = 
                        Date.From(
                            Number.Round( Number.From( #date( _AnoData, 4, 1 ) ) / 7 + fxModExcel( 19 * fxModExcel( _AnoData, 19 ) - 7, 30 ) * 0.14, 0, RoundingMode.Up ) * 7 - 6
                        ),

                    _LstFeriados = 
                        List.Contains(
                            {
                                #date( _AnoData,  1,  1 ),                     // Dia Mundial de Confraternização
                                #date( _AnoData,  1, 25 ),                     // Aniversário município de São Paulo
                                #date( _AnoData,  4, 21 ),                     // Tiradentes
                                #date( _AnoData,  5,  1 ),                     // Dia do Trabalhador
                                #date( _AnoData,  7,  9 ),                     // Revolução Constitucionalista de 1932
                                #date( _AnoData,  9,  7 ),                     // Independência do Brasil
                                #date( _AnoData, 10, 12 ),                     // Nossa Senhora Aparecida
                                #date( _AnoData, 11,  2 ),                     // Finados
                                #date( _AnoData, 11, 15 ),                     // Proclamação da República
                                #date( _AnoData, 11, 20 ),                     // Consciência Negra
                                #date( _AnoData, 12, 25 ),                     // Natal
                                #date( _AnoData, 12, 31 ),                     // Véspera Ano Novo
                                Date.From( Number.From( _DataPascoa ) - 48 ),  // Segunda-feira de Carnaval
                                Date.From( Number.From( _DataPascoa ) - 47 ),  // Terça-feira de Carnaval
                                Date.From( Number.From( _DataPascoa ) -  2 ),  // Sexta-Feira Santa
                                _DataPascoa,                                   // Páscoa
                                Date.From( Number.From( _DataPascoa ) + 60 ),  // Corpus Christi
                                Date.From( Number.From( _DataPascoa ) - 46 )   // Quarta-feira de Cinzas
                            },
                            _Data
                        )
                in 
                    if _LstFinalDeSemana or _LstFeriados then false else true,

                // DataAnoAnterior
                let
                    _DataAnoAnterior = 
                        Date.AddYears( _, -1 )
                in
                    // Verifica se o ano é Bissexto
                    Date.AddDays(
                        _DataAnoAnterior, 
                        if Number.Mod( Date.Year( _DataAnoAnterior ), 4 ) = 0 then 2 else 1
                    )
            }
        ),

     ListaParaTabela = 
        #table(
            type table [
                #"ID_DataBase"         = Int32.Type,    // Faixa de números: -2.147.483.648 a 2.147.483.647
                #"DataBase_Serial"     = Int32.Type,
                #"AnoMes_Num"          = Int32.Type,
                #"DataBase"            = date,
                #"DiaSem_Num"          = Int8.Type,     // Faixa de números: -128 a 128
                #"DiaSem_Letra"        = text,
                #"DiaSem_Abrv"         = text,
                #"DiaSem_Ext"          = text,
                #"Dia_TXT"             = text,
                #"Dia_Num"             = Int8.Type,
                #"Mes_Num"             = Int8.Type,
                #"MesNome_Letra"       = text,
                #"MesNome_Abrv"        = text,
                #"MesNome_Ext"         = text,
                #"MesNomeAbrv_Ano"     = text,
                #"MesNomeExt_Ano"      = text,
                #"Ano_Num"             = Int16.Type,    // Faixa de números: -32.767 a 32.767
                #"QtdDiasMes"          = Int16.Type,
                #"SemanaMes"           = Int8.Type,
                #"SemanaAno"           = Int8.Type,
                #"Bimestre_Num"        = Int8.Type,
                #"Bimestre"            = text,
                #"Trimestre_Num"        = Int8.Type,
                #"Trimestre"           = text,
                #"Quadrimestre_Num"    = Int8.Type,
                #"Quadrimestre"        = text,
                #"Semestre_Num"        = Int8.Type,
                #"Semestre"            = text,
                #"DiasDecorridos"      = Int16.Type,
                #"MesesDecorridos"     = Int16.Type,
                #"DataMesInicio"       = date,
                #"DataMesFim"          = date,
                #"DataTrimestreInicio" = date,
                #"DataTrimestreFim"    = date,
                #"DataAnoInicio"       = date,
                #"DataAnoFim"          = date,
                #"DiaUtil"             = logical,
                #"DataAnoAnterior"     = date
            ],
            AdicionarColunas
        )
in
    ListaParaTabela
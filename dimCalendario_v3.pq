let
    __Inicializacao_das_variaveis__ = "",

    _mesIncAnoFiscal     = 4,                                                    // Especifica o mês do início do ano fiscal. Padrão: 4 (Abril)
    _diaIncMesFechamento = 16,                                                   /* Dia de início do mês de fechamento. Padrão: dia 16
                                                                                    Siginifica que o mês de fechamento vai de 16 do mês corrente até o dia 15 do próximo mês */
    _idioma              = "pt-BR",                                              // Especifica o idioma. Padrão: pt-BR (Português do Brasil)
    _dataInicial         = #date( _AnoInicio, 1, 1 ),                            // Especifica a data inicial 
    _dataFinal           = Date.EndOfYear( Date.From( DateTime.LocalNow( ) ) ),  // Especifica a data final. Padrão: Final do ano atual 
    _dataAtual           = Date.From( DateTime.LocalNow( ) ),                    // Especifica a data atual. Padrão: Data atual do servidor 
    _intDataInicial      = Number.From( _dataInicial ),                          // Valor númerico da Data Inicial
    _intDataFinal        = Number.From( _dataFinal ),                            // Valor númerico da Data Final
    _intInicioSemana     = Day.Monday,                                           // Especifica o início da semana. Padrão: Day.Monday (Segunda-feira) 
    _lstDatas            =                                                       // Lista contendo todas as datas 
        List.Buffer( 
            List.Transform( 
                { _intDataInicial .. _intDataFinal }, 
                Date.From 
            ) 
        ),
    _lstAnos             =                                                       //Lista com todos os anos 
        List.Buffer( 
            { Date.Year( _dataInicial ) .. Date.Year( _dataFinal ) } 
        ),

    __Geracao_da_tabela__ = "", 

    dimCalendario = 
        let
            //Feriados fixos que ocorrem em todos os anos 
            _tabFeriadosFixos = 
                #table ( 
                    type table [ 
                        Dia       = Int64.Type, 
                        Mes       = Int64.Type, 
                        Feriado   = text,
                        TpFeriado = text
                    ],
                    {   // Dia, Mês, Feriado, Tipo Feriado:[L]ocal (Municipal), [M]undial, [N]acional, [P]onto facultativo
                        { 01, 01, "Confraternização Universal",   "M" },
                        { 25, 01, "Aniversário Cidade de SP",     "L" },
                        { 21, 04, "Tiradentes",                   "N" },
                        { 01, 05, "Dia do Trabalhador",           "M" },
                        { 09, 07, "Rev. Constitucionalista 1932", "L" },
                        { 07, 09, "Independência do Brasil",      "N" },
                        { 12, 10, "N. Senhora Aparecida",         "N" },
                        { 02, 11, "Finados",                      "N" },
                        { 15, 11, "Proclamação da República",     "N" },
                        { 20, 11, "Consciência Negra",            "N" },
                        { 25, 12, "Natal",                        "M" },
                        { 24, 12, "Véspera de Natal",             "P" },
                        { 31, 12, "Véspera de Ano Novo",          "P" } 
                    } 
                ),

            fxGeraFeriadosFixos =                       // Função que gera os feriados fixos para todos os anos 
                ( ano ) => 
                    Table.AddColumn( 
                        _tabFeriadosFixos, 
                        "Data", 
                        each #date( ano, [Mes], [Dia] ), 
                        type date 
                    ) 
                    [ [Data], [Feriado], [TpFeriado] ],

            dimFeriadosFixos =                          // Gera a tabela de feriados fixos 
                Table.Combine( 
                    List.Transform( 
                        _lstAnos, 
                        fxGeraFeriadosFixos 
                    ) 
                ),

            fxGeraFeriadosMoveis =                      // Função que gera os feriados móveis 
                ( ano ) => 
                    let 
                        modExcel = 
                            ( x, y ) => 
                                let 
                                    m = Number.Mod ( x, y ) 
                                in 
                                    if  m < 0 then m + y else m, 
                        pascoa =  
                            Date.From( 
                                Number.Round( 
                                    Number.From( #date ( ano, 4, 1 ) ) / 7 
                                    +  modExcel( 19 * modExcel ( ano, 19 ) - 7, 30 ) * 0.14, 
                                    0, 
                                    RoundingMode.Up 
                                ) * 7 - 6 
                            ), 

                        dimCadFeriadosMoveis = 
                            #table( 
                                type table[ 
                                    Data      = date, 
                                    Feriado   = text,
                                    TpFeriado = text
                                ], 
                                { 
                                    { Date.AddDays( pascoa, -48 ), "Segunda-feira de Carnaval", "N" },
                                    { Date.AddDays( pascoa, -47 ), "Terça-feira de Carnaval",   "N" },
                                    { Date.AddDays( pascoa, -46 ), "Quarta-feira de Cinzas",    "N" },
                                    { Date.AddDays( pascoa, -2 ),  "Sexta-Feira Santa",         "M" },
                                    { pascoa                    ,  "Páscoa",                    "M" },
                                    { Date.AddDays( pascoa, 60 ),  "Corpus Christi",            "M" }
                                } 
                            ) 
                    in 
                        dimCadFeriadosMoveis, 

            dimFeriadosMoveis =                         // Gera a tabela de feriados móveis 
                Table.Combine( 
                    List.Transform( 
                        _lstAnos, 
                        fxGeraFeriadosMoveis 
                    ) 
                ),

            dimFeriados =                               // Tabela contendo todos os feriados 
                Table.Combine( 
                    { dimFeriadosFixos, dimFeriadosMoveis } 
                ),

            fxLinhaCalendario =                         // Define a função de transformação de cada data 
                ( data ) => 
                    let 
                        // Transformações de simples passada para reutilização
                        zws                = Character.FromNumber( 8203 ),       // Caracter invisível (zero-width spacing )
                        dataOffset         = Number.From( data - _dataAtual ), 
                        ano                = Date.Year( data ), 
                        mes                = Date.Month( data ), 
                        trimestre          = Date.QuarterOfYear( data ), 
                        anoInicial         = Date.Year( _dataInicial ),
                        anoAtual           = Date.Year( _dataAtual ), 
                        anoFinal           = Date.Year( _dataFinal ), 
                        anoOffset          = ano - anoAtual, 
                        mesInicial         = Date.Month( _dataInicial ), 
                        mesAtual           = Date.Month( _dataAtual ), 
                        trimestreInicial   = Date.QuarterOfYear( _dataInicial ), 
                        trimestreAtual     = Date.QuarterOfYear( _dataAtual ), 
                        diaSemana          = Date.DayOfWeek( data, _intInicioSemana ) + 1, 
                        diaSemanaIndiceZws = Text.Repeat( zws, 7 - diaSemana ), 
                        
                        semanaDoAnoIsoNo = 
                            let 
                                quintaNaSemana          = Date.AddDays( data, 3 - Date.DayOfWeek ( data, Day.Monday ) ), 
                                inicioAnoQuintaNaSemana = #date( Date.Year( quintaNaSemana ), 1, 1 ), 
                                difDias                 = Duration.Days( quintaNaSemana - inicioAnoQuintaNaSemana ) 
                            in 
                                Number.IntegerDivide( difDias, 7, 0 ) + 1, 

                        semanaDoAnoNum         = Date.WeekOfYear( data, _intInicioSemana ), 
                        diaSemanaNome          = Text.Proper( Date.DayOfWeekName ( data, _idioma ) ), 
                        mesNome                = Text.Proper( Date.MonthName ( data, _idioma ) ), 
                        mesIndiceZws           = Text.Repeat( zws, 12 - mes ), 
                        mesAnoIndice           = 12 * ( ano - anoInicial ) + mes, 
                        inicioMes              = Date.StartOfMonth( data ),
                        fimMes                 = Date.EndOfMonth( data ),
                        diaMes                 = Date.Day( data ), 
                        mesOffset              = ( ( ano * 12 ) - 1 + mes ) - ( ( anoAtual * 12 ) - 1 + mesAtual ), 
                        trimestreOffset        = ( ( ano * 4 ) - 1 + trimestre ) - ( ( anoAtual * 4 ) - 1 + trimestreAtual ), 
                        trimestreAno           = "T" & Text.From( trimestre ) & "/" & Text.From( ano ), 
                        anoIso                 = Date.Year( Date.AddDays( data, 26 - semanaDoAnoIsoNo ) ), 
                        inicioSemanaIsoLinha   = Date.StartOfWeek( data, Day.Monday ), 
                        fimSemanaIsoLinha      = Date.EndOfWeek( data, Day.Monday ), 
                        inicioSemanaLinha      = Date.StartOfWeek( data, _intInicioSemana ), 
                        fimSemanaLinha         = Date.EndOfWeek( data, _intInicioSemana ), 
                        inicioSemanaIsoInicial = Date.StartOfWeek( data, Day.Monday ), 
                        inicioSemanaInicial    = Date.StartOfWeek( _dataInicial, _intInicioSemana ), 
                        inicioSemanaIsoAtual   = Date.StartOfWeek( _dataAtual, Day.Monday ),
                        inicioSemanaAtual      = Date.StartOfWeek( _dataAtual, _intInicioSemana ), 
                        semanaIsoOffset        = Number.From( inicioSemanaIsoLinha - inicioSemanaIsoAtual ) / 7,
                        semanaOffset           = Number.From( inicioSemanaLinha - inicioSemanaAtual ) / 7, 
                        semanaAnoIso           = "S" & Text.PadStart( Text.From( semanaDoAnoIsoNo ), 2, "0" ) & "/" & Text.From( anoIso ), 
                        semanaAno              = "S" & Text.PadStart( Text.From( semanaDoAnoNum ), 2, "0" ) & "/" & Text.From( ano ), 
                
                        semanaDoMes = 
                            let 
                                inicioMes         = Date.StartOfMonth( Date.StartOfWeek ( data, _intInicioSemana ) ), 
                                primeirosSeteDias = List.Dates( inicioMes, 7, #duration ( 1, 0, 0, 0 ) ), 
                                primeiroDia       = List.Select( primeirosSeteDias, each Date.DayOfWeek ( _, _intInicioSemana ) = 0 ) { 0 } 
                            in 
                                Number.RoundUp( Duration.Days ( data-primeiroDia ) / 7 + 0.05 ), 

                        anoSemanal           = Date.Year( inicioSemanaLinha ), 
                        mesSemanal           = Date.Month( inicioSemanaLinha ) , 
                        mesSemanalNome       = Text.Proper( Date.MonthName( inicioSemanaLinha, _idioma ) ), 
                        mesSemanalNomeAbrev  = Text.Start( mesSemanalNome, 3 ), 
                        semanaDoMesPadraoNum = Date.WeekOfMonth( data, _intInicioSemana ), 
                        quinzenaDoMesNo      = if Date.Day( data ) <= 15 then 1 else 2, 
                        quinzenaDoMesNoAtual = if Date.Day( _dataAtual ) <= 15 then 1 else 2, 
                        mesAno               = Text.Proper( Date.ToText ( data, [ Format = "MMM/yy", Culture = _idioma ] ) ), 
                        quinzenaMesAno       = "Qui " & Text.From( quinzenaDoMesNo ) & " - " & mesAno, 
                        quinzenaIndice       = 24 * ( ano - anoInicial ) + 2 * ( mes - mesInicial ) + quinzenaDoMesNo, 
                        quinzenaIndiceAtual  = 24 *  ( anoAtual - anoInicial ) + 2 * ( mesAtual - mesInicial ) + quinzenaDoMesNoAtual, 
                        quinzenaOffset       = quinzenaIndice - quinzenaIndiceAtual, 
                        semestreNo           = if mes <= 6      then 1 else 2, 
                        semestreNoAtual      = if mesAtual <= 6 then 1 else 2, 
                        semestreIndice       = ( 2 * ( ano - anoInicial ) ) + semestreNo, 
                        semestreIndiceAtual  = ( 2 * ( anoAtual - anoInicial ) ) + semestreNoAtual, 
                        semestreOffset       = semestreIndice - semestreIndiceAtual, 
                        semestreAno          = "S" & Text.From( semestreNo ) & " - " & Text.From( ano ), 
                        bimestreNo           = Number.RoundUp( mes / 2, 0 ), 
                        bimestreNoAtual      = Number.RoundUp( mesAtual / 2, 0 ), 
                        bimestreAno          = "B" & Text.From( bimestreNo ) & " - " & Text.From( ano ), 
                        bimestreIndice       = ( 6 * ( ano - anoInicial ) ) + bimestreNo, 
                        bimestreIndiceAtual  = ( 6 * ( anoAtual - anoInicial ) ) + bimestreNoAtual, 
                        bimestreOffset       = bimestreIndice - bimestreIndiceAtual, 

                        feriado = 
                            try 
                                dimFeriados{ [ Data = data ] }[Feriado] 
                            otherwise 
                                null, 

                        diaUtilNo = 
                            if feriado <> null or List.Contains( { 6 .. 7 }, Date.DayOfWeek( data, Day.Monday ) + 1 ) 
                            then 0 
                            else 1, 
  
                        mesDiaNo     = Date.Month( data ) * 100 + Date.Day( data ), 
  
                        estacaoAnoNo = 
                            if mesDiaNo >= 321 and mesDiaNo <= 620 
                                then 1 
                            else if mesDiaNo >= 621 and mesDiaNo <= 921 
                                then 2
                            else if mesDiaNo >= 922 and mesDiaNo <= 1221
                                then 3
                                else 4 ,

                        dataReferenciaFechamento = 
                            if diaMes <= _diaIncMesFechamento - 1 
                                then data
                                else Date.AddMonths( data, 1 )  
                    in 
                        {   // Saída das transformações 
                            Number.From( data - _dataInicial ) + 1,                 // DataIndice 
                            data,                                                   // Data 
                            dataOffset,                                             // DataOffset 

                            if dataOffset = 0
                                then "Data Atual"                                   // DataNomeAtual 
                            else if dataOffset = -1
                                then "Data Anterior" 
                            else if dataOffset = 1
                                then "Próxima Data" 
                                else Date.ToText( data, "dd/MM/yyyy" ), 

                            ano,                                                    // AnoNum 
                            Date.StartOfYear( data ),                               // AnoInicio
                            Date.EndOfYear( data ),                                 // AnoFim 
                            ano - anoInicial + 1,                                   // AnoIndice 
                            ano,                                                    // AnoDecrescenteNome 
                            ano * -1,                                               // AnoDescrescenteNum 
                            if mes >= _mesIncAnoFiscal                              // AnoFiscal 
                                then ano 
                                else ano - 1,
                            
                            anoOffset,                                              // AnoOffset 

                            if anoOffset = 0 
                                then "Ano Atual"                                    // AnoNomeAtual 
                            else if anoOffset = -1 
                                then "Ano Anterior" 
                            else if anoOffset = 1
                                then "Próximo Ano" 
                                else Date.ToText( data, "yyyy" ),

                            diaMes,                                                 // DiaDoMesNum 
                            Date.DayOfYear( data ),                                 // DiaDoAnoNum 
                            diaSemana,                                              // DiaDaSemanaNum 
                            diaSemanaNome,                                          // DiaDaSemanaNome 
                            Text.Start( diaSemanaNome, 3 ),                         // DiaDaSemanaNomeAbrev 
                            diaSemanaIndiceZws & Text.Start( diaSemanaNome, 1 ),    // DiaDaSemanaNomeIniciais 
                            mes,                                                    // MesNum 
                            mesNome,                                                // MesNome 
                            Text.Start( mesNome, 3 ),                               // MesNomeAbrev 
                            mesIndiceZws & Text.Start( mesNome, 1 ),                // MesNomeIniciais 
                            ano * 100 + mes,                                        // MesAnoNum 
                            mesAno,                                                 // MesAnoMome 
                            mes * 100 + diaMes,                                     // MesDiaNum 
                            Text.Proper( Date.ToText(data, [Format = "MMM/dd", Culture = _idioma] )), // MesDiaNome
                            Date.StartOfMonth( data ),                              // MesInicio 
                            Date.EndOfMonth( data ),                                // MesFim 
                            mesAnoIndice,                                           // MesIndice 
                            mesOffset,                                              // MesOffset 
 
                            if mesOffset = 0                                        // MesNomeAtual 
                                then "Mês Atual"
                            else if mesOffset = -1
                                then "Mês Anterior" 
                            else if mesOffset = 1 
                                then "Próximo Mês" 
                                else mesNome, 

                            if mesOffset = 0                                        // MesNomeAbrevAtual 
                                then "Mês Atual" 
                                else if mesOffset = -1 
                                    then "Mês Anterior" 
                                else if mesOffset = 1 
                                    then "Próximo Mês" 
                                    else Text.Start ( mesNome, 3 ), 
                            
                            if mesOffset = 0                                        // MesAnoNomeAtual 
                                then "Mês Atual" 
                                else if mesOffset = -1
                                    then "Mês Anterior" 
                                else if mesOffset = 1
                                    then "Próximo Mês" 
                                    else mesAno, 
                            
                            trimestre,                                              // TrimestreNum 
                            Date.StartOfQuarter( data ),                            // TrimestreInicio 
                            Date.EndOfQuarter( data ),                              // TrimestreFinal 
                            ano * 100 + trimestre,                                  // TrimestreAnoNum
                            trimestreAno,                                           // TrimestreAnoNome 
                            4 * ( ano - anoInicial ) + trimestre,                   // TrimestreIndice 
                            trimestreOffset,                                        // TrimestreOffset 

                            if trimestreOffset = 0                                  // TrimestreAnoNomeAtual 
                                then "Trimestre Atual" 
                            else if trimestreOffset = -1
                                then "Trimestre Anterior" 
                            else if trimestreOffset = 1
                                then "Próximo Trimestre" 
                                else trimestreAno, 

                            semanaDoAnoIsoNo,                                       // SemanaIsoNum 
                            anoIso,                                                 // AnoIsoNum 
                            anoIso * 100 + semanaDoAnoIsoNo,                        // SemanaIsoAnoNum 
                            semanaAnoIso,                                           // SemanaIsoAnoNome 
                            inicioSemanaIsoLinha,                                   // SemanaIsoInicio 
                            fimSemanaIsoLinha,                                      // SemanaIsoFim 
                            Number.From( inicioSemanaIsoLinha - inicioSemanaIsoInicial ) / 7 + 1,   // SemanaIsoIndice 
                            semanaOffset,                                           // SemanaIsoOffset 

                            if semanaIsoOffset = 0                                  // SemanaIsoAnoNomeAtual
                                then "Semana Atual" 
                            else if semanaIsoOffset = -1
                                then "Semana Anterior" 
                            else if semanaIsoOffset = 1
                                then "Próxima Semana" 
                                else semanaAnoIso, 

                            semanaDoAnoNum,                                         // SemanaNo 
                            ano * 100 + semanaDoAnoNum,                             // SemanaAnoNum 
                            semanaAno,                                              // SemanaAnoNome 
                            inicioSemanaLinha,                                      // SemanaInicio 
                            fimSemanaLinha,                                         // SemanaFim 
                            Date.ToText ( inicioSemanaLinha, "dd/MM/yyyy" ) & " a " & Date.ToText ( fimSemanaLinha, "dd/MM/yyyy" ),   // SemanaPeriodo
                            Number.From ( inicioSemanaLinha - inicioSemanaInicial ) / 7 + 1,                                          // SemanaIndice 
                            semanaOffset,                                           // SemanaOffset

                            if semanaOffset = 0                                     // SemanaAnoNomeAtual 
                                then "Semana Atual" 
                            else if semanaOffset = -1 
                                then "Semana Anterior" 
                            else if semanaOffset = 1
                                then "Próxima Semana" 
                                else semanaAno, 

                            semanaDoMes,                                            // SemanaDoMesNum 
                            anoSemanal,                                             // AnoSemanalNum 
                            mesSemanal,                                             // MesSemanalNum 
                            mesSemanalNome,                                         // MesSemanalNome 
                            mesSemanalNomeAbrev,                                    // MesSemanalNomeAbrev 
                            anoSemanal * 100 + mesSemanal,                          // MesAnoSemanalNum 
                            Text.Proper( Date.ToText( inicioSemanaLinha, [ Format="MMM/yy", Culture = _idioma ] )),    // MesAnoSemanalNome 
                            semanaDoMesPadraoNum,                                   // SemanaDoMesPadraoNum
                            mesAno & " " & Text.From( semanaDoMesPadraoNum ),       // SemanaDoMesAnoPadraoNome
                            ano * 10000 + mes * 100 + semanaDoMesPadraoNum,         // SemanaDoMesAnoPadraoNum
                            quinzenaDoMesNo,                                        // QuinzenaDoMesNum 
                            mes * 10 + quinzenaDoMesNo,                             // QuinzenaMesNum 
                            "Qui " & Text.From(quinzenaDoMesNo) & " - " & mesNome,  // QuinzenaMesNome             
                            ano * 10000 + mes * 100 + quinzenaDoMesNo,              // QuinzenaMesAnoNum 
                            quinzenaMesAno,                                         // QuinzenaMesAnoNome 

                            let                                                     // QuinzenaPeriodo
                                inicioQuinzena = if quinzenaDoMesNo = 1 then inicioMes else Date.AddDays( inicioMes, 15 ),
                                fimQuinzena    = if quinzenaDoMesNo = 2 then fimMes    else Date.AddDays( inicioMes, 14 )
                            in
                                Date.ToText( inicioQuinzena, "dd/MM/yyyy" ) & " a " & Date.ToText( fimQuinzena, "dd/MM/yyyy" ),

                            quinzenaIndice,                                         // QuinzenaIndice
                            quinzenaOffset,                                         // QuinzenaOffset 

                            if quinzenaOffset = 0
                                then "Quinzena Atual"                               // QuinzenaMesAnoNomeAtual 
                            else if quinzenaOffset = -1
                                then "Quinzena Anterior" 
                            else if quinzenaOffset = 1
                                then "Próxima Quinzena" 
                                else quinzenaMesAno, 

                            semestreNo,                                             // SemestreDoAnoNum 
                            ano * 100 + semestreNo,                                 // SemestreAnoNum 
                            "S" & Text.From(semestreNo) & " - " & Text.From(ano),   // SemestreAnoNome
                            semestreIndice,                                         // SemestreIndice 
                            semestreOffset,                                         // Semestre Offset 
                        
                            if semestreOffset = 0                                   // SemestreAnoNomeAtual 
                                then "Semestre Atual" 
                            else if semestreOffset = -1
                                then "Semestre Anterior" 
                            else if semestreOffset = 1
                                then "Próximo Semestre" 
                                else semestreAno, 
            
                            bimestreNo,                                             // BimestreDoAnoNum 
                            ano * 100 + bimestreNo,                                 // BimestreAnoNum 
                            bimestreAno,                                            // BimestreAnoNome 
                            bimestreIndice,                                         // BimestreIndice 
                            bimestreOffset,                                         // BimestrOffset 

                            if bimestreOffset = 0                                   // BimestreAnoNomeAtual
                                then "Bimestre Atual" 
                            else if bimestreOffset = -1
                                then "Bimestre Anterior" 
                            else if bimestreOffset = 1
                                then "Próximo Bimestre" 
                                else bimestreAno, 

                            feriado,                                                // FeriadoNome 
                            diaUtilNo,                                              // DiaUtilNum 

                            if diaUtilNo = 0                                        // DiaUtilNome 
                                then "Dia Não Útil" 
                                else "Dia Útil",
                            
                            estacaoAnoNo,                                           // EstacaoAnoNum 

                            if estacaoAnoNo = 1                                     // EstacaoAnoNome 
                                then "Outono" 
                            else if estacaoAnoNo = 2
                                then "Inverno" 
                            else if estacaoAnoNo = 3
                                then "Primavera" 
                                else "Verão",

                            Date.Month( dataReferenciaFechamento ),                                                            // MesFechamentoNum
                            Text.Proper( Date.ToText( dataReferenciaFechamento, [ Format = "MMMM", Culture = _idioma ] ) ),    // MesFechamentoNome
                            Text.Proper( Date.ToText( dataReferenciaFechamento, [ Format = "MMM", Culture = _idioma ] ) ),     // MesFechamentoNomeAbrev
                            Date.Year( dataReferenciaFechamento ),                                                             // AnoFechamentoNum
                            Date.Year( dataReferenciaFechamento ) * 100 + Date.Month ( dataReferenciaFechamento ),             // MesAnoFechamentoNum
                            Text.Proper( Date.ToText( dataReferenciaFechamento, [ Format = "MMM/yy", Culture = _idioma ] ) ),  // MesAnoFechamentoNome
                            dataOffset > 0                                                                                     // DataFutura
                        },


            dimCalendarioTmp =                                  // Gera a tabela calendário 
                #table( 
                    // Nomes e tipos das colunas 
                    type table [ 
                        DataIndice               = Int64.Type,
                        Data                     = date, 
                        DataOffset               = Int64.Type, 
                        DataNomeAtual            = text, 
                        AnoNum                   = Int64.Type, 
                        AnoInicio                = date,
                        AnoFim                   = date, 
                        AnoIndice                = Int64.Type, 
                        AnoDecrescenteNome       = Int64.Type, 
                        AnoDecrescenteNum        = Int64.Type, 
                        AnoFiscal                = Int64.Type, 
                        AnoOffset                = Int64.Type, 
                        AnoNomeAtual             = text, 
                        DiaDoMesNum              = Int64.Type, 
                        DiaDoAnoNum              = Int64.Type, 
                        DiaDaSemanaNum           = Int64.Type, 
                        DiaDaSemanaNome          = text, 
                        DiaDaSemanaNomeAbrev     = text, 
                        DiaDaSemanaNomeIniciais  = text,
                        MesNum                   = Int64.Type, 
                        MesNome                  = text, 
                        MesNomeAbrev             = text, 
                        MesNomeIniciais          = text, 
                        MesAnoNum                = Int64.Type, 
                        MesAnoNome               = text, 
                        MesDiaNum                = Int64.Type, 
                        MesDiaNome               = text, 
                        MesInicio                = date, 
                        MesFim                   = date, 
                        MesIndice                = Int64.Type, 
                        MesOffset                = Int64.Type, 
                        MesNomeAtual             = text, 
                        MesNomeAbrevAtual        = text, 
                        MesAnoNomeAtual          = text, 
                        TrimestreNum             = Int64.Type, 
                        TrimestreInicio          = date, 
                        TrimestreFim             = date, 
                        TrimestreAnoNum          = Int64.Type,
                        TrimestreAnoNome         = text, 
                        TrimestreIndice          = Int64.Type, 
                        TrimestreOffset          = Int64.Type, 
                        TrimestreAnoNomeAtual    = text, 
                        SemanaIsoNum             = Int64.Type,
                        AnoIsoNum                = Int64.Type, 
                        SemanaIsoAnoNum          = Int64.Type, 
                        SemanaIsoAnoNome         = text, 
                        SemanaIsoInicio          = date, 
                        SemanaIsoFim             = date, 
                        SemanaIsoIndice          = Int64.Type, 
                        SemanaIsoOffset          = Int64.Type, 
                        SemanaIsoAnoNomeAtual    = text, 
                        SemanaNum                = Int64.Type, 
                        SemanaAnoNum             = Int64.Type, 
                        SemanaAnoNome            = text, 
                        SemanaInicio             = date, 
                        SemanaFim                = date, 
                        SemanaPeriodo            = text,
                        SemanaIndice             = Int64.Type, 
                        SemanaOffset             = Int64.Type, 
                        SemanaAnoNomeAtual       = text, 
                        SemanaDoMesNum           = Int64.Type, 
                        AnoSemanalNum            = Int64.Type, 
                        MesSemanalNum            = Int64.Type, 
                        MesSemanalNome           = text, 
                        MesSemanalNomeAbrev      = text, 
                        MesAnoSemanalNum         = Int64.Type, 
                        MesAnoSemanalNome        = text, 
                        SemanaDoMesPadraoNum     = Int64.Type,
                        SemanaDoMesAnoPadraoNome = text, 
                        SemanaDoMesAnoPadraoNum  = Int64.Type, 
                        QuinzenaDoMesNum         = Int64.Type,
                        QuinzenaMesNum           = Int64.Type, 
                        QuinzenaMesNome          = text, 
                        QuinzenaMesAnoNum        = Int64.Type, 
                        QuinzenaMesAnoNome       = text, 
                        QuinzenaPeriodo          = text,
                        QuinzenaIndice           = Int64.Type, 
                        QuinzenaOffset           = Int64.Type, 
                        QuinzenaMesAnoNomeAtual  = text, 
                        SemestreDoAnoNum         = Int64.Type, 
                        SemestreAnoNum           = Int64.Type, 
                        SemestreAnoNome          = text, 
                        SemestreIndice           = Int64.Type, 
                        SemestreOffset           = Int64.Type, 
                        SemestreAnoNomeAtual     = text,
                        BimestreDoAnoNum         = Int64.Type, 
                        BimestreAnoNum           = Int64.Type, 
                        BimestreAnoNome          = text, 
                        BimestreIndice           = Int64.Type, 
                        BimestreOffset           = Int64.Type, 
                        BimestreAnoNomeAtual     = text, 
                        FeriadoNome              = text, 
                        DiaUtilNum               = Int64.Type, 
                        DiaUtilNome              = text, 
                        EstacaoAnoNum            = Int64.Type, 
                        EstacaoAnoNome           = text, 
                        MesFechamentoNum         = Int64.Type,
                        MesFechamentoNome        = text, 
                        MesFechamentoNomeAbrev   = text, 
                        AnoFechamentoNum         = Int64.Type,
                        MesAnoFechamentoNum      = Int64.Type,
                        MesAnoFechamentoNome     = text,
                        DataFutura               = Logical.Type 
                    ], 
                    //Invoca função de transformação 
                    List.Transform( 
                        _lstDatas, 
                        fxLinhaCalendario 
                    ) 
                ),

                adDiaUtilMes =                          // Adiciona o número do dia útil do mês
                    let
                        tabela = 
                            Table.Buffer( 
                                Table.SelectColumns( 
                                    dimCalendarioTmp, 
                                    { "DiaDoMesNum", "MesIndice", "DiaUtilNum" } 
                                ) 
                            ), 

                        addDiaUtilMes = 
                            Table.AddColumn(
                                tabela, 
                                "DiaUtilDoMes", 
                                each 
                                    let 
                                        __mesIndice = [MesIndice], 
                                        __DiaDoMes  = [DiaDoMesNum] 
                                    in 
                                        List.Sum( 
                                            Table.SelectRows( 
                                                tabela, 
                                                each [MesIndice] = __mesIndice and [DiaDoMesNum] <= __DiaDoMes 
                                            )
                                            [DiaUtilNum]
                                        ), 
                                    Int64.Type
                                    )[ [MesIndice], [DiaDoMesNum], [DiaUtilDoMes] ], 

                        join = 
                            Table.Join(
                                dimCalendarioTmp, { "MesIndice", "DiaDoMesNum" },
                                addDiaUtilMes, { "MesIndice", "DiaDoMesNum" }
                            ) 
                        in
                            join         
                    in
                        adDiaUtilMes 
in
    dimCalendario
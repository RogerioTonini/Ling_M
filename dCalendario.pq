/* -------------------------------------------------------------------------------------------------------------------------------
Script.....: Criação Tabela Calendário
Autor......: Wanderlei Hüttel - Contato: https://www.linkedin.com/in/wanderleihuttel / https://github.com/wanderleihuttel/powerbi
Alterações.: Rogerio Tonini - https://www.linkedin.com/in/rogerio-tonini / https://github.com/RogerioTonini
----------------------------------------------------------------------------------------------------------------------------------
Referências :
- Literatura Estudos:
    Alison Pezzott...: https://www.youtube.com/@fluentebi
    Benito Savastano.: https://www.youtube.com/watch?v=Y6E-zZjg7y8&t=104s&ab_channel=Jo%C3%A3oBenitoSavastano
    Joviano Silveira.: https://joviano.com/blog/ / https://cursos.joviano.com/m/courses
    XPERIUN..........: https://app.xperiun.com/entrar
- Literatura histórica / técnica:
    UFRGS.....: https://www.inf.ufrgs.br/~cabral/Pascoa.html
    Wikipedia.: https://pt.wikipedia.org/wiki/C%C3%A1lculo_da_P%C3%A1scoa#:~:text=A%20P%C3%A1scoa%20%C3%A9%20celebrada%20no,do%20m%C3%AAs%20lunar%20de%20Nissan.
----------------------------------------------------------------------------------------------------------------------------------
Informações diversas :
- Cálculo Feriados Móveis - Referências:
    Fórmula EXCEL: ARRED( DATA( A1; 4; 1 ) / 7 + MOD( 19 * MOD( A1; 19 ) - 7; 30 ) * 14%; 0 ) * 7 - 6 
- Ordenar no Modelo Semântico
    +-----------------+-------------+
    | Coluna Ordenar  | Pela Coluna |
    +-----------------+-------------+
    | DiaSem_Letra    | DiaSem_Num  |
    | MesNomeAbrv_Ano | AnoMes_Num  |
    | MesNomeExt_Ano  | AnoMes_Num  |
    +-----------------+-------------+
----------------------------------------------------------------------------------------------------------------------------------
Funcionamento : Para "ativa-la"- Criar uma variável chamada _DataInicio, inserindo uma data qualquer
----------------------------------------------------------------------------------------------------------------------------------
Alterações:
16/10/2020 - Adequação de nome de colunas
10/01/2021 - Criação da coluna MesesDecorridos - Demonstrar qtde de meses decorridos entre a data atual e a mais antiga.
01/12/2024 - Script refatorado, 
            1 - Inclusão das colunas: DiasDecorridos, Quadrimestre, Feriados e Dia no Ano Anterior,
            2 - Atualização da documentação no script
            3 - Adequação do tamanho (bits) das colunas tipo Int.
----------------------------------------------------------------------------------------------------------------------------------
*/
let
    _DataInicial = 
        #date( Date.Year( _DataInicio ), Date.Month( _DataInicio ), Date.Day( _DataInicio ) ),

    _DataFinal = 
        Date.EndOfYear( Date.From( DateTime.LocalNow() ) ),

    _Duracao = 
        Duration.Days(_DataFinal - _DataInicial) + 1,

    _ListaDatas  = 
        List.Buffer( 
            List.Sort( 
                List.Dates( 
                    _DataInicial, 
                    _Duracao, 
                    #duration(1, 0, 0, 0) 
                ), 
            Order.Ascending ) 
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
                Text.Repeat( Character.FromNumber(8203), 6 -  Date.DayOfWeek( _ ) ) & Text.Start( Text.Proper( Date.ToText( _, "ddd", Culture.Current) ), 1 ),

                Text.Proper( Date.ToText( _,"ddd", Culture.Current ) ),   // DiaSem_Abrv
                Text.Proper( Date.DayOfWeekName( _ ) ),                   // DiaSem_Ext
                Text.PadStart( Number.ToText( Date.Day( _ ) ), 2, " " ),  // Dia_TXT
                Date.Day( _ ),                                            // Dia_Num
                Date.Month( _ ),                                          // Mes_Num
                Date.Year( _ ),                                           // Ano_Num
                Date.DaysInMonth( _ ),                                    // QtdDiasMes
                Text.Proper( Date.ToText( _, "MMM", Culture.Current) ),   // MesNome_Abrv
                Text.Proper( Date.MonthName( _ ) ),                       // MesNome_Ext
                Text.Proper( Date.ToText(_, "MMM/yyyy") ),                // MesNomeAbrv_Ano
                Text.Proper( Date.ToText(_, "MMMM/yyyy") ),               // MesNomeExt_Ano
                Date.WeekOfMonth( _ ),                                    // SemanaMes
                Date.WeekOfYear( _ ),                                     // SemanaAno
                Number.RoundUp( Date.Month( _ ) / 2 ),                    // Bimestre
                Date.QuarterOfYear( _ ),                                  // Trimestre
                Number.RoundUp( Date.Month( _ ) / 4 ),                    // Quadrimestre 
                Number.RoundUp( Date.Month( _ ) / 6 ),                    // Semestre

                // DiasDecorridos - Qtde de dias decorridos desde a data inicial e a data final
                Number.RoundUp( Number.From ( _ ) -  Number.From( DateTime.LocalNow() ) ),

                // MesesDecorridos - Qtde de meses decorridos desde a data inicial e a final
                ( ( ( ( Date.Year( _DataFinal ) - Date.Year( _ ) ) * 12) + ( Date.Month( _DataFinal ) ) ) - Date.Month( _ ) ),

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

                    _DataPascoa = Date.From(
                        Number.Round(
                            Number.From( #date( _AnoData, 4, 1 ) ) / 7 + fxModExcel( 19 * fxModExcel( _AnoData, 19 ) - 7, 30 ) * 0.14, 0, RoundingMode.Up ) * 7 - 6
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
                                Date.From( Number.From( _DataPascoa ) + 60 )   // Corpus Christi
                                // Date.From( Number.From( _DataPascoa ) - 46 ),  // Quarta-feira de Cinzas
                            },
                            _Data
                        )
                in 
                    if _LstFinalDeSemana or _LstFeriados then false else true,

                if Date.From( DateTimeZone.SwitchZone( DateTimeZone.UtcNow(), -3) ) <> _  then false else true,   // DiaCorrente
                if not ( Date.IsInCurrentMonth( _ ) and Date.IsInCurrentYear( _ ) ) then false else true,         // MesCorrente
                if not Date.IsInCurrentYear( _ ) then false else true,                                            // AnoCorrente

                // DataAnoAnterior
                let
                    _DataAnoAnterior = 
                        Date.AddYears( _, -1 )
                in
                    // Verifica se o ano é Bissexto
                    Date.AddDays(
                        _DataAnoAnterior, 
                        if Number.Mod( Date.Year( _DataAnoAnterior ), 4) = 0 then 2 else 1
                    )
            }
        ),

    ListaParaTabela = 
        #table(
            type table [
                #"ID_DataBase"     = Int32.Type,    // Faixa de números: -2.147.483.648 a 2.147.483.647
                #"DataBase_Serial" = Int32.Type,
                #"AnoMes_Num"      = Int32.Type,
                #"DataBase"        = date,
                #"DiaSem_Num"      = Int8.Type,     // Faixa de números: -128 a 128
                #"DiaSem_Letra"    = text,
                #"DiaSem_Abrv"     = text,
                #"DiaSem_Ext"      = text,
                #"Dia_TXT"         = text,
                #"Dia_Num"         = Int8.Type,
                #"Mes_Num"         = Int8.Type,
                #"Ano_Num"         = Int16.Type,    // Faixa de números: -32.767 a 32.767
                #"QtdDiasMes"      = Int16.Type,
                #"MesNome_Abrv"    = text,
                #"MesNome_Ext"     = text,
                #"MesNomeAbrv_Ano" = text,
                #"MesNomeExt_Ano"  = text,
                #"SemanaMes"       = Int8.Type,
                #"SemanaAno"       = Int8.Type,
                #"Bimestre"        = Int16.Type,
                #"Trimestre"       = Int8.Type,
                #"Quadrimestre"    = Int8.Type,
                #"Semestre"        = Int8.Type,
                #"DiasDecorridos"  = Int16.Type,
                #"MesesDecorridos" = Int16.Type,
                #"DiaUtil"         = logical,
                #"DiaCorrente"     = logical,
                #"MesCorrente"     = logical,
                #"AnoCorrente"     = logical,
                #"DataAnoAnterior" = date
            ],
            AdicionarColunas
        )
in
    Table.Buffer(ListaParaTabela)
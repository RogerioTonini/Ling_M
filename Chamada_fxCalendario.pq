let
    Funcao = 
        Text.FromBinary( 
            Web.Contents(_GitHub & "dCalendario.pq") 
        ),

    TransformandoEmFuncao = 
        "(_AnoInicial as number) => " & Funcao,
        
    AvaliandoExpressao = 
        Expression.Evaluate(
            TransformandoEmFuncao,
            #shared
        )
in
    AvaliandoExpressao
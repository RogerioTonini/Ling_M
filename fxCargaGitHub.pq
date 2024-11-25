// A variavel GITHUB conte o endereço WEB https://raw.githubusercontent.com/Usuario/Ling_M/refs/heads/main/

let
    FuncaoInvocada = 
        Expression.Evaluate( 
            Text.FromBinary( 
                Web.Contents( _GitHub & "NomeFuncao" ) 
            ), 
            #shared 
        )
in
    FuncaoInvocada
# Ling_M
Biblioteca Linguagem M

<details>
    <summary> - dCalendario </summary>
<p> -------------------------------------------------------------------------------------------------------------------------------
<p> Script.....: Criação Tabela Calendário
<p> Autor......: Wanderlei Hüttel - Contato: https://www.linkedin.com/in/wanderleihuttel / https://github.com/wanderleihuttel/powerbi
<p> Alterações.: Rogerio Tonini - https://www.linkedin.com/in/rogerio-tonini / https://github.com/RogerioTonini
<p> ----------------------------------------------------------------------------------------------------------------------------------
<p> Referências :
<p> - Literatura Estudos:
<p>     Alison Pezzott...: https://www.youtube.com/@fluentebi
<p>     Benito Savastano.: https://www.youtube.com/watch?v=Y6E-zZjg7y8&t=104s&ab_channel=Jo%C3%A3oBenitoSavastano
<p>     Joviano Silveira.: https://joviano.com/blog/ / https://cursos.joviano.com/m/courses
<p>     XPERIUN..........: https://app.xperiun.com/entrar
<p> - Literatura histórica / técnica:
<p>     UFRGS.....: https://www.inf.ufrgs.br/~cabral/Pascoa.html
<p>     Wikipedia.: https://pt.wikipedia.org/wiki/C%C3%A1lculo_da_P%C3%A1scoa#:~:text=A%20P%C3%A1scoa%20%C3%A9%20celebrada%20no,do%20m%C3%AAs%20lunar%20de%20Nissan.
<p> ----------------------------------------------------------------------------------------------------------------------------------
<p> Informações diversas :
<p> - Cálculo Feriados Móveis - Referências:
<p>     Fórmula EXCEL: ARRED( DATA( A1; 4; 1 ) / 7 + MOD( 19 * MOD( A1; 19 ) - 7; 30 ) * 14%; 0 ) * 7 - 6 
<p> - Ordenar no Modelo Semântico
<p>     +-----------------+-------------+
<p>     | Coluna Ordenar  | Pela Coluna |
<p>     +-----------------+-------------+
<p>     | DiaSem_Letra    | DiaSem_Num  |
<p>     | MesNomeAbrv_Ano | AnoMes_Num  |
<p>     | MesNomeExt_Ano  | AnoMes_Num  |
<p>     +-----------------+-------------+
<p> ----------------------------------------------------------------------------------------------------------------------------------
<p> Alterações:
<p> 16/10/2020 - Adequação de nome de colunas
<p> 10/01/2021 - Criação da coluna MesesDecorridos - Demonstrar qtde de meses decorridos entre a data atual e a mais antiga.
<p> 01/12/2024 - Script refatorado: 
<p>             1 - Inclusão das colunas: DiasDecorridos, Quadrimestre, Feriados e Dia no Ano Anterior,
<p>             2 - Atualização da documentação no script
<p>             3 - Adequação do tamanho (bits) das colunas tipo Int.
<p> ----------------------------------------------------------------------------------------------------------------------------------
</details>
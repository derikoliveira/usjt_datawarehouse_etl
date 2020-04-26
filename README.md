# Projeto de Datawarehousing & Data Mining

### Universidade São Judas Tadeu

## Como Executar

1. Clone o projeto localmente.

2. Faça a importação dos sqls dentro de `banco` para o MySQL.
    
    Um é dependente do outro, então importe na seguinte ordem:
    
    1. `fato_script.sql`
    2. `agregado_script.sql`

3. Crie um usuário `alunos` com senha `alunos`.

4. Rode o script `main.py`, dentro de `src`.

    ```
    $ python src/main.py
    ```

## Proposta

Queremos acompanhar a execução orçamentária do governo no ano passado (2019). Para isso, faça o seguinte: 

1. Vá até o Portal da Transparência do Governo Federal na área de Dados Abertos. Acesse os dados de 
Execução da Despesa. Leia o dicionário de dados. Você deve baixar todos os arquivos de 2019, de 
Janeiro a Dezembro. Abra um dos arquivos com Pandas para dar uma olhada nele. 

2. No mesmo portal irá encontrar os dados do Orçamento da Despesa. Leia o dicionário de dados. 
Baixe o arquivo de 2019. Note que você só terá um arquivo. Abra-o com Pandas para dar uma olhada nele. 

3. Crie uma tabela fato com duas métricas. Valor orçado, que vem do Orçamento da Despesa e valor 
liquidado, que vem da Execução da Despesa (ignore os outros valores da execução).  

4. As dimensões que queremos acompanhar são:

    1. Dimensão Órgão, com a hierarquia Órgão Superior, Órgão Subordinado e Unidade Orçamentária 
    (deixe Unidade Gestora de fora).
    2. Dimensão Programa: Programa Orçamentário e Ação (deixe Programa de Governo de Fora).
    3. Dimensão Área de Atuação: Função e Subfunção.  
    4. Dimensão Temporal: Mês e Ano.

5. Note que a granularidade da dimensão temporal é mês, mas o dados de orçamento você só 
tem do ano. Para mensalizar, divida o valor anual por 12.

6. As tabelas devem ser criadas no MySQL.

7. Olhe o dashboard de Despesa Pública de 2019. Crie 5 agregados:
    1. Total por Órgão Superior por Ano.
    2. Total por Função por Ano.
    3. Total por Programa por Ano.
    4. Total por Órgão por Ano.
    5. Total por Órgão e Programa por Ano. 

8. Calcule o espaço em disco necessário se quiséssemos guardar os dados de execução 
orçamentária dos últimos 20 anos (considere o volume de 2019 como média anual.) 

9. Faça os scripts de carga, em Python, para carregar os arquivos dos 12 meses de 
execução orçamentária e o arquivo de orçamento na tabela fato e suas dimensões e 
nas agregações e suas dimensões.
 
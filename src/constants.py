from collections import OrderedDict

DESPESAS_COL = OrderedDict({
    'ano_mes': 'Ano e mês do lançamento',
    'cod_orgao_superior': 'Código Órgão Superior', 'nome_orgao_superior': 'Nome Órgão Superior',
    'cod_orgao_subordinado': 'Código Órgão Subordinado', 'nome_orgao_subordinado': 'Nome Órgão Subordinado',
    'cod_uni_orc': 'Código Unidade Orçamentária', 'nome_uni_orc': 'Nome Unidade Orçamentária',
    'cod_funcao': 'Código Função', 'nome_funcao': 'Nome Função',
    'cod_subfuncao': 'Código Subfução', 'nome_subfuncao': 'Nome Subfunção',
    'cod_prog_orc': 'Código Programa Orçamentário', 'nome_prog_orc': 'Nome Programa Orçamentário',
    'cod_acao': 'Código Ação', 'nome_acao': 'Nome Ação',
    'valor_liquidado': 'Valor Liquidado (R$)'
})

ORCAMENTOS_COL = OrderedDict({
    'exercicio': 'EXERCÍCIO',
    'cod_orgao_superior': 'CÓDIGO ÓRGÃO SUPERIOR', 'nome_orgao_superior': 'NOME ÓRGÃO SUPERIOR',
    'cod_orgao_subordinado': 'CÓDIGO ÓRGÃO SUBORDINADO', 'nome_orgao_subordinado': 'NOME ÓRGÃO SUBORDINADO',
    'cod_uni_orc': 'CÓDIGO UNIDADE ORÇAMENTÁRIA', 'nome_uni_orc': 'NOME UNIDADE ORÇAMENTÁRIA',
    'cod_funcao': 'CÓDIGO FUNÇÃO', 'nome_funcao': 'NOME FUNÇÃO',
    'cod_subfuncao': 'CÓDIGO SUBFUNÇÃO', 'nome_subfuncao': 'NOME SUBFUNÇÃO',
    'cod_prog_orc': 'CÓDIGO PROGRAMA ORÇAMENTÁRIO', 'nome_prog_orc': 'NOME PROGRAMA ORÇAMENTÁRIO',
    'cod_acao': 'CÓDIGO AÇÃO', 'nome_acao': 'NOME AÇÃO',
    'valor_orcado': 'ORÇAMENTO REALIZADO (R$)',
})

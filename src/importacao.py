import pandas as pd
import numpy as np

from constants import DESPESAS_COL, ORCAMENTOS_COL


class Importacao:
    def __init__(self, despesas_caminho_arq, orcamentos_caminho_arq, mysql_obj):
        self.mysql_obj = mysql_obj
        despesas = self.criar_despesas_df(despesas_caminho_arq)
        orcamentos = self.criar_orcamentos_df(orcamentos_caminho_arq)
        self.fato_orcamento_df = self.criar_fato_orcamento_df(despesas, orcamentos)

    def importar(self):
        self.inserir_tempo()
        self.inserir_programa()
        self.inserir_acao()
        self.inserir_orgao_superior()
        self.inserir_orgao_subordinado()
        self.inserir_unidade_orcamentaria()
        self.inserir_funcao()
        self.inserir_subfuncao()
        self.inserir_fato_orcamento()

        self.inserir_ag_tempo()
        self.inserir_ag_orgao_subordinado_ano()
        self.inserir_ag_orgao_superior_ano()

    def criar_despesas_df(self, despesas_caminho_arq):
        print('Criando DataFrame Despesas')
        despesas_list = [pd.read_csv(
            caminho,
            delimiter=';', decimal=',',
            encoding='ANSI',
            usecols=list(DESPESAS_COL.values())
        ) for caminho in despesas_caminho_arq]
        despesas = pd.concat(despesas_list)
        despesas.columns = list(DESPESAS_COL.keys())
        print(f'Despesas: {len(despesas)}')
        print(f'Quantidade de NaNs:\n{despesas.isna().sum()}')
        print('Trocando NaNs por strings vazias')
        despesas.fillna('', inplace=True)
        return despesas

    def criar_orcamentos_df(self, orcamentos_caminho_arq):
        print('Criando DataFrame Orçamento')
        orcamentos = pd.read_csv(
            orcamentos_caminho_arq,
            delimiter=';', decimal=',',
            encoding='ANSI',
            dtype={ORCAMENTOS_COL['exercicio']: np.object},
            usecols=list(ORCAMENTOS_COL.values())
        )
        orcamentos.columns = list(ORCAMENTOS_COL.keys())
        orcamentos_mensais = self.dividir_orcamento_por_mes(orcamentos)
        return orcamentos_mensais

    def dividir_orcamento_por_mes(self, orcamento_anual):
        """Multiplica o DataFrame em 12, dividindo o 'valor_orcado' pela mesma quantidade"""
        orcamentos_list = []
        orcamento_anual['valor_orcado'] = orcamento_anual['valor_orcado'] / 12
        for mes in range(12):
            orcamento_mensal = orcamento_anual.copy()
            orcamento_mensal['ano_mes'] = orcamento_mensal['exercicio'] + '/' + str(mes + 1).zfill(2)
            orcamentos_list.append(orcamento_mensal)
        orcamentos_mensais = pd.concat(orcamentos_list)
        return orcamentos_mensais

    def criar_fato_orcamento_df(self, despesas, orcamentos):
        print('Fazendo merge dos DataFrames de Despesas e Orçamento')
        df = despesas.merge(
            orcamentos,
            on=[
                'ano_mes',
                'cod_orgao_superior', 'nome_orgao_superior',
                'cod_orgao_subordinado', 'nome_orgao_subordinado',
                'cod_uni_orc', 'nome_uni_orc',
                'cod_funcao', 'nome_funcao',
                'cod_subfuncao', 'nome_subfuncao',
                'cod_prog_orc', 'nome_prog_orc',
                'cod_acao', 'nome_acao'
            ],
            how='outer'
        )
        return df

    def inserir_tempo(self):
        print('Inserindo TEMPO')
        insert = """INSERT INTO tempo (ano_mes) VALUES (%s)"""
        ano_meses = self.fato_orcamento_df['ano_mes'].unique()
        for ano_mes in ano_meses:
            self.mysql_obj.execute_par_query(insert, (ano_mes,))

    def inserir_programa(self):
        print('Inserindo PROGRAMA')
        insert = """INSERT INTO programa (cod, nome) VALUES (%s, %s)"""
        programas = self.fato_orcamento_df[['cod_prog_orc', 'nome_prog_orc']]
        programas_unicos = programas.drop_duplicates(subset='cod_prog_orc', keep='first')
        for linha in programas_unicos.itertuples(index=None, name=None):
            self.mysql_obj.execute_par_query(insert, linha)

    def inserir_acao(self):
        print('Inserindo ACAO')
        insert = """INSERT INTO acao (cod, PROGRAMA_cod, nome) VALUES (%s, %s, %s)"""
        acoes = self.fato_orcamento_df[['cod_acao', 'cod_prog_orc', 'nome_acao']]
        acoes_unicas = acoes.drop_duplicates(subset='cod_acao', keep='first')
        for linha in acoes_unicas.itertuples(index=None, name=None):
            self.mysql_obj.execute_par_query(insert, linha)

    def inserir_orgao_superior(self):
        print('Inserindo ORGAO_SUPERIOR')
        insert = """INSERT INTO orgao_superior (cod, nome) VALUES (%s, %s)"""
        orgaos_superiores = self.fato_orcamento_df[['cod_orgao_superior', 'nome_orgao_superior']]
        orgaos_superiores_unicos = orgaos_superiores.drop_duplicates(subset='cod_orgao_superior', keep='first')
        for linha in orgaos_superiores_unicos.itertuples(index=None, name=None):
            self.mysql_obj.execute_par_query(insert, linha)

    def inserir_orgao_subordinado(self):
        print('Inserindo ORGAO_SUBORDINADO')
        insert = """
            INSERT INTO
                orgao_subordinado (cod, ORGAO_SUPERIOR_cod, nome)
            VALUES
                (%s, %s, %s)
        """
        orgaos_subordinados = self.fato_orcamento_df[['cod_orgao_subordinado',
                                                      'cod_orgao_superior',
                                                      'nome_orgao_subordinado']]
        orgaos_subordinados_unicos = orgaos_subordinados.drop_duplicates(subset='cod_orgao_subordinado', keep='first')

        for linha in orgaos_subordinados_unicos.itertuples(index=None, name=None):
            self.mysql_obj.execute_par_query(insert, linha)

    def inserir_unidade_orcamentaria(self):
        print('Inserindo UNIDADE_ORCAMENTARIA')
        insert = """
            INSERT INTO
                unidade_orcamentaria (cod, ORGAO_SUBORDINADO_cod, nome)
            VALUES
                (%s, %s, %s)
        """
        unidades_orcamentarias = self.fato_orcamento_df[['cod_uni_orc', 'cod_orgao_subordinado', 'nome_uni_orc']]
        unidades_orcamentarias_unicas = unidades_orcamentarias.drop_duplicates(subset='cod_uni_orc', keep='first')

        for linha in unidades_orcamentarias_unicas.itertuples(index=None, name=None):
            self.mysql_obj.execute_par_query(insert, linha)

    def inserir_funcao(self):
        print('Inserindo FUNCAO')
        insert = """INSERT INTO funcao (cod, nome) VALUES (%s, %s)"""
        funcoes = self.fato_orcamento_df[['cod_funcao', 'nome_funcao']].drop_duplicates(subset='cod_funcao',
                                                                                        keep='first')

        for linha in funcoes.itertuples(index=None, name=None):
            self.mysql_obj.execute_par_query(insert, linha)

    def inserir_subfuncao(self):
        print('Inserindo SUBFUNCAO')
        insert = """INSERT INTO subfuncao (cod, FUNCAO_cod, nome) VALUES (%s, %s, %s)"""
        subfuncoes = self.fato_orcamento_df[['cod_subfuncao', 'cod_funcao', 'nome_subfuncao']]
        subfuncoes_unicas = subfuncoes.drop_duplicates(subset='cod_subfuncao', keep='first')

        for linha in subfuncoes_unicas.itertuples(index=None, name=None):
            self.mysql_obj.execute_par_query(insert, linha)

    def get_tempo_id(self, ano_mes):
        query = """SELECT id FROM tempo where tempo.ano_mes = '%s'""" % ano_mes
        return self.mysql_obj.execute_read_query(query)[0][0]

    def inserir_fato_orcamento(self):
        print('Inserindo FATO_ORCAMENTO')
        insert = """
            INSERT INTO
                fato_orcamento (
                valor_orcado, valor_liquidado, TEMPO_id, ACAO_cod, SUBFUNCAO_cod, UNIDADE_ORCAMENTARIA_cod
                )
            VALUES
                (%s, %s, %s, %s, %s, %s)
        """
        fato_df = self.fato_orcamento_df

        ano_meses = fato_df['ano_mes'].unique()
        ano_meses_dict = {ano_mes: self.get_tempo_id(ano_mes) for ano_mes in ano_meses}

        fatos_orcamentos = fato_df.groupby(['ano_mes', 'cod_acao', 'cod_subfuncao', 'cod_uni_orc']).sum()
        fatos_orcamentos = fatos_orcamentos.reset_index()
        fatos_orcamentos = fatos_orcamentos.fillna(0.0)

        for fato in fatos_orcamentos.itertuples():
            self.mysql_obj.execute_par_query(insert, (fato.valor_orcado, fato.valor_liquidado,
                                                      ano_meses_dict[fato.ano_mes], fato.cod_acao,
                                                      fato.cod_subfuncao, fato.cod_uni_orc)
                                             )

    def inserir_ag_tempo(self):
        print('Inserindo AG_TEMPO')
        insert = """INSERT INTO ag_tempo (ano) VALUES (%s)"""
        ano = self.fato_orcamento_df['exercicio'][0]
        query = insert % ano
        self.mysql_obj.execute_query(query)

    def get_ag_tempo_id(self):
        ano_mes = self.fato_orcamento_df['exercicio'][0]
        query = """SELECT id FROM ag_tempo where ag_tempo.ano = '%s'""" % ano_mes
        return self.mysql_obj.execute_read_query(query)[0][0]

    def inserir_ag_orgao_subordinado_ano(self):
        print('Inserindo AG_ORGAO_SUBORDINADO_ANO')
        insert = """
            INSERT INTO
                ag_orgao_subordinado_ano (valor_orcado, valor_liquidado, TEMPO_id, ORGAO_SUBORDINADO_cod)
            VALUES
                (%s, %s, %s, %s)
        """
        ano_id = self.get_ag_tempo_id()

        ag_orgao_subordinado_ano = self.fato_orcamento_df.groupby(['cod_orgao_subordinado']).sum().reset_index()
        ag_orgao_subordinado_ano = ag_orgao_subordinado_ano.fillna(0.0)

        for ag in ag_orgao_subordinado_ano.itertuples():
            self.mysql_obj.execute_par_query(insert, (ag.valor_orcado, ag.valor_liquidado,
                                                      ano_id, ag.cod_orgao_subordinado)
                                             )

    def inserir_ag_orgao_superior_ano(self):
        print('Inserindo AG_ORGAO_SUPERIOR_ANO')
        insert = """
            INSERT INTO
                ag_orgao_superior_ano (valor_orcado, valor_liquidado, TEMPO_id, ORGAO_SUPERIOR_cod)
            VALUES
                (%s, %s, %s, %s)
        """
        ano_id = self.get_ag_tempo_id()

        ag_orgao_superior_ano = self.fato_orcamento_df.groupby(['cod_orgao_superior']).sum().reset_index()
        ag_orgao_superior_ano = ag_orgao_superior_ano.fillna(0.0)

        for ag in ag_orgao_superior_ano.itertuples():
            self.mysql_obj.execute_par_query(insert, (ag.valor_orcado, ag.valor_liquidado,
                                                      ano_id, ag.cod_orgao_superior)
                                             )

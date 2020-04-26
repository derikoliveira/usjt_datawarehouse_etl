import os

from conexao_mysql import MySQL
from importacao import Importacao


def main():
    trocar_diretorio()
    despesas_arqs = retorna_caminhos_arqs_despesas()
    orcamento = '../dados/2019_OrcamentoDespesa.zip.csv'
    mysql_obj = MySQL('localhost', 'alunos', 'alunos', 'atividade02')
    model_fato = Importacao(despesas_arqs, orcamento, mysql_obj)
    model_fato.importar()
    mysql_obj.connection.close()
    print('Importação realizada com sucesso')


def retorna_caminhos_arqs_despesas():
    return ['../dados/' + arq for arq in os.listdir('../dados') if arq.endswith('Despesas.csv')]


def trocar_diretorio():
    """Troca para o diretório desse arquivo, não importa de onde ele seja chamado"""
    # Retirado de https://stackoverflow.com/a/1432949/12032210
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    os.chdir(dname)


if __name__ == '__main__':
    main()

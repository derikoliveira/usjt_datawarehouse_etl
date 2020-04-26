from os import listdir

from conexao_mysql import MySQL
from importacao import Importacao


def main():
    despesas_arqs = retorna_caminhos_arqs_despesas()
    orcamento = '../dados/2019_OrcamentoDespesa.zip.csv'
    mysql_obj = MySQL('localhost', 'alunos', 'alunos', 'atividade02')
    model_fato = Importacao(despesas_arqs, orcamento, mysql_obj)
    model_fato.importar()
    mysql_obj.connection.close()
    print('Importação realizada com sucesso')


def retorna_caminhos_arqs_despesas():
    return ['../dados/' + arq for arq in listdir('../dados') if arq.endswith('Despesas.csv')]


if __name__ == '__main__':
    main()

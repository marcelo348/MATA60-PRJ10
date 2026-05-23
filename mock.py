import random
from faker import Faker
from datetime import timedelta, date

# Configura o Faker para gerar dados perfeitamente brasileiros
fake = Faker('pt_BR')

# Metas do Barema
QTD_PESQUISADORES = 5000
QTD_CONTRATOS = 6000

# Parâmetros de volume realista
QTD_PROJETOS = 1000
QTD_FINANCIADORES = 50
QTD_BOLSAS = 3000

print("Gerando arquivo DML...")

with open("02_dml_populacao.sql", "w", encoding="utf-8") as f:
    f.write("-- ==========================================\n")
    f.write("-- SCRIPT DE POPULAÇÃO - MATA60 (PRJ10)\n")
    f.write("-- Gerado via Python (Faker)\n")
    f.write("-- ==========================================\n\n")

    # 1. Financiadores
    print("Gerando Financiadores...")
    f.write("-- 1. FINANCIADORES\n")
    cnpjs_usados = set()
    for i in range(1, QTD_FINANCIADORES + 1):
        cnpj = fake.unique.cnpj().replace('.', '').replace('/', '').replace('-', '')
        nome = f"{fake.company()} Fomento à Pesquisa"
        tipo = random.choice(['Público', 'Privado'])
        contato = fake.phone_number()[:20]
        f.write(f"INSERT INTO financiador (id_financiador, cnpj_financiador, nome_financiador, tipo_financiador, contato_financiador) VALUES ({i}, '{cnpj}', '{nome}', '{tipo}', '{contato}');\n")

    # 2. Projetos
    print("Gerando Projetos...")
    f.write("\n-- 2. PROJETOS\n")
    for i in range(1, QTD_PROJETOS + 1):
        titulo = f"Pesquisa em {fake.catch_phrase().title()}"
        data_inicio = fake.date_between(start_date='-5y', end_date='-1y')
        data_termino = data_inicio + timedelta(days=random.randint(365, 1460))
        f.write(f"INSERT INTO projeto (id_projeto, titulo_projeto, data_inicio, data_termino) VALUES ({i}, '{titulo}', '{data_inicio}', '{data_termino}');\n")

    # 3. Pesquisadores (Meta >= 5000)
    print("Gerando Pesquisadores (Meta de volume)...")
    f.write("\n-- 3. PESQUISADORES\n")
    for i in range(1, QTD_PESQUISADORES + 1):
        cpf = fake.unique.cpf().replace('.', '').replace('-', '')
        titulacao = random.choice(['Graduando', 'Mestre', 'Doutor'])
        email = fake.unique.company_email()
        telefone = fake.phone_number()[:20]
        primeiro_nome = fake.first_name()
        sobrenome = fake.last_name()
        f.write(f"INSERT INTO pesquisador (id_pesquisador, cpf_pesquisador, titulacao, email, telefone, primeiro_nome, sobrenome) VALUES ({i}, '{cpf}', '{titulacao}', '{email}', '{telefone}', '{primeiro_nome}', '{sobrenome}');\n")

    # 4. Bolsas
    print("Gerando Bolsas...")
    f.write("\n-- 4. BOLSAS\n")
    for i in range(1, QTD_BOLSAS + 1):
        id_projeto = random.randint(1, QTD_PROJETOS)
        categoria = random.choice(['IC', 'Mestrado', 'Doutorado'])
        valor = 700.00 if categoria == 'IC' else (2100.00 if categoria == 'Mestrado' else 3100.00)
        processo = f"PROC-{fake.unique.random_number(digits=8)}"
        f.write(f"INSERT INTO bolsa (id_bolsa, id_projeto, valor_bolsa, categoria_bolsa, numero_processo) VALUES ({i}, {id_projeto}, {valor}, '{categoria}', '{processo}');\n")

    # 5. Contratos (Meta >= 5000)
    print("Gerando Contratos (Meta de volume)...")
    f.write("\n-- 5. CONTRATOS\n")
    bolsas_disponiveis = list(range(1, QTD_BOLSAS + 1))
    random.shuffle(bolsas_disponiveis)
    
    for i in range(1, QTD_CONTRATOS + 1):
        id_pesq = random.randint(1, QTD_PESQUISADORES)
        id_proj = random.randint(1, QTD_PROJETOS)
        tipo_vinculo = random.choice(['Bolsista', 'Voluntário'])
        
        # Garante que a bolsa é única por contrato (restrição UNIQUE)
        id_bolsa_str = 'NULL'
        if tipo_vinculo == 'Bolsista' and bolsas_disponiveis:
            id_bolsa_str = str(bolsas_disponiveis.pop())
            
        data_ass = fake.date_between(start_date='-3y', end_date='today')
        data_venc = data_ass + timedelta(days=random.randint(180, 730))
        f.write(f"INSERT INTO contrato (id_contrato, id_pesquisador, id_projeto, id_bolsa, data_assinatura, data_vencimento, tipo_vinculo) VALUES ({i}, {id_pesq}, {id_proj}, {id_bolsa_str}, '{data_ass}', '{data_venc}', '{tipo_vinculo}');\n")

    # 6. Financia (Tabela Associativa N:N)
    print("Gerando Financiamentos...")
    f.write("\n-- 6. FINANCIA\n")
    pares_financia = set()
    for _ in range(1500):
        id_finan = random.randint(1, QTD_FINANCIADORES)
        id_proj = random.randint(1, QTD_PROJETOS)
        if (id_finan, id_proj) not in pares_financia:
            pares_financia.add((id_finan, id_proj))
            valor = round(random.uniform(10000.0, 500000.0), 2)
            f.write(f"INSERT INTO financia (id_financiador, id_projeto, valor_aportado) VALUES ({id_finan}, {id_proj}, {valor});\n")

    # 7. Publicações
    print("Gerando Publicações...")
    f.write("\n-- 7. PUBLICAÇÕES\n")
    for i in range(1, 2000 + 1):
        id_proj = random.randint(1, QTD_PROJETOS)
        doi = f"10.1000/ufba.{fake.unique.random_number(digits=6)}"
        titulo = f"Análise sobre {fake.catch_phrase().lower()}"
        data_pub = fake.date_between(start_date='-2y', end_date='today')
        f.write(f"INSERT INTO publicacao (id_publicacao, id_projeto, doi, titulo_publicacao, data_publicacao) VALUES ({i}, {id_proj}, '{doi}', '{titulo}', '{data_pub}');\n")

    # 8. Relatórios
    print("Gerando Relatórios...")
    f.write("\n-- 8. RELATÓRIOS\n")
    relatorios_gerados = set()
    for _ in range(2000):
        id_proj = random.randint(1, QTD_PROJETOS)
        seq = random.randint(1, 5)
        if (id_proj, seq) not in relatorios_gerados:
            relatorios_gerados.add((id_proj, seq))
            data_sub = fake.date_between(start_date='-2y', end_date='today')
            texto = fake.text(max_nb_chars=200).replace("'", "''") # Escapa aspas pro SQL
            f.write(f"INSERT INTO relatorio (id_projeto, sequencial_relatorio, data_submissao, texto_conteudo) VALUES ({id_proj}, {seq}, '{data_sub}', '{texto}');\n")

print("Sucesso! Arquivo '02_dml_populacao.sql' criado.")
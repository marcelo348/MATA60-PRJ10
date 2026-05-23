/* Modelo_Logico: */

CREATE TABLE Projeto (
    id_projeto INTEGER PRIMARY KEY,
    titulo_projeto VARCHAR(50),
    data_inicio DATE,
    data_termino DATE
);

CREATE TABLE Publicacao (
    id_publicacao INTEGER PRIMARY KEY,
    fk_id_projeto INTEGER,
    doi VARCHAR(255) UNIQUE,
    titulo_publicacao VARCHAR(255),
    data_publicacao DATE
);

CREATE TABLE Pesquisador (
    id_pesquisador INTEGER PRIMARY KEY,
    cpf_pesquisador CHAR(11) UNIQUE,
    titulacao VARCHAR(50),
    email VARCHAR(150),
    telefone VARCHAR(20),
    primeiro_nome VARCHAR(50),
    sobrenome VARCHAR(50)
);

CREATE TABLE Financiador (
    id_financiador INTEGER PRIMARY KEY,
    cnpj_financiador CHAR(14) UNIQUE,
    nome_financiador VARCHAR(150),
    tipo_financiador VARCHAR(50),
    contato_financiador VARCHAR(100)
);

CREATE TABLE Contrato (
    id_contrato INTEGER PRIMARY KEY,
    fk_bolsa_id_bolsa INTEGER UNIQUE,
    fk_projeto_id_projeto INTEGER,
    fk_pesquisador_id_pesquisador INTEGER,
    data_assinatura DATE,
    data_vencimento DATE,
    tipo_vinculo VARCHAR(50)
);

CREATE TABLE Bolsa (
    id_bolsa INTEGER PRIMARY KEY,
    fk_projeto_id_projeto INTEGER,
    valor_bolsa DECIMAL,
    categoria_bolsa VARCHAR(50),
    numero_processo VARCHAR(100)
);

CREATE TABLE Relatorio (
    fk_projeto_id_projeto INTEGER,
    sequencial_relatorio INTEGER,
    data_submissao DATE,
    texto_conteudo TEXT,
    PRIMARY KEY (fk_projeto_id_projeto, sequencial_relatorio)
);

CREATE TABLE Financia (
    fk_Financiador_id_financiador INTEGER,
    fk_Projeto_id_projeto INTEGER,
    valor_aportado DECIMAL,
    PRIMARY KEY (fk_Financiador_id_financiador, fk_Projeto_id_projeto)
);
 
ALTER TABLE Publicacao ADD CONSTRAINT FK_Publicacao_2
    FOREIGN KEY (fk_id_projeto)
    REFERENCES Projeto (id_projeto);
 
ALTER TABLE Contrato ADD CONSTRAINT FK_Contrato_2
    FOREIGN KEY (fk_projeto_id_projeto)
    REFERENCES Projeto (id_projeto);
 
ALTER TABLE Contrato ADD CONSTRAINT FK_Contrato_3
    FOREIGN KEY (fk_bolsa_id_bolsa)
    REFERENCES Bolsa (id_bolsa);
 
ALTER TABLE Contrato ADD CONSTRAINT FK_Contrato_5
    FOREIGN KEY (fk_pesquisador_id_pesquisador)
    REFERENCES Pesquisador (id_pesquisador);
 
ALTER TABLE Bolsa ADD CONSTRAINT FK_Bolsa_2
    FOREIGN KEY (fk_projeto_id_projeto)
    REFERENCES Projeto (id_projeto);
 
ALTER TABLE Relatorio ADD CONSTRAINT FK_Relatorio_1
    FOREIGN KEY (fk_projeto_id_projeto)
    REFERENCES Projeto (id_projeto);
 
ALTER TABLE Financia ADD CONSTRAINT FK_Financia_1
    FOREIGN KEY (fk_Financiador_id_financiador)
    REFERENCES Financiador (id_financiador)
    ON DELETE RESTRICT;
 
ALTER TABLE Financia ADD CONSTRAINT FK_Financia_2
    FOREIGN KEY (fk_Projeto_id_projeto)
    REFERENCES Projeto (id_projeto)
    ON DELETE SET NULL;
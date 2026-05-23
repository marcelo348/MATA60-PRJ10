-- Remove os dados das tabelas dependentes primeiro

DELETE FROM financia;
DELETE FROM relatorio;
DELETE FROM publicacao;
DELETE FROM contrato;
DELETE FROM bolsa;

-- Remove os dados das tabelas principais depois

DELETE FROM pesquisador;
DELETE FROM financiador;
DELETE FROM projeto;


-- Reinicia os IDs automáticos (PostgreSQL)

ALTER SEQUENCE projeto_id_projeto_seq RESTART WITH 1;
ALTER SEQUENCE financiador_id_financiador_seq RESTART WITH 1;
ALTER SEQUENCE pesquisador_id_pesquisador_seq RESTART WITH 1;
ALTER SEQUENCE bolsa_id_bolsa_seq RESTART WITH 1;
ALTER SEQUENCE contrato_id_contrato_seq RESTART WITH 1;
ALTER SEQUENCE publicacao_id_publicacao_seq RESTART WITH 1;
ALTER SEQUENCE relatorio_id_relatorio_seq RESTART WITH 1;
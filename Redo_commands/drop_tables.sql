-- Limpa as estruturas anteriores (se existirem) antes de recriar
DROP TABLE IF EXISTS financia CASCADE;
DROP TABLE IF EXISTS relatorio CASCADE;
DROP TABLE IF EXISTS publicacao CASCADE;
DROP TABLE IF EXISTS contrato CASCADE;
DROP TABLE IF EXISTS bolsa CASCADE;
DROP TABLE IF EXISTS pesquisador CASCADE;
DROP TABLE IF EXISTS financiador CASCADE;
DROP TABLE IF EXISTS projeto CASCADE;

-- (Abaixo deste bloco, você mantém os seus CREATE TABLE normais)
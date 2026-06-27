CREATE MATERIALIZED VIEW mv_voluntarios_ativos AS
SELECT 
    c.id_contrato,
    c.id_pesquisador,
    c.id_projeto,
    p.primeiro_nome || ' ' || p.sobrenome AS nome_completo,
    c.data_vencimento
FROM contrato c
JOIN pesquisador p ON c.id_pesquisador = p.id_pesquisador
WHERE c.id_bolsa IS NULL 
  AND c.data_vencimento >= CURRENT_DATE;
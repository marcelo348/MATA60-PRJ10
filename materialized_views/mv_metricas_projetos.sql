CREATE MATERIALIZED VIEW mv_metricas_projetos AS
SELECT 
    p.id_projeto,
    p.titulo_projeto,
    COUNT(DISTINCT c.id_contrato) FILTER (WHERE c.data_vencimento > CURRENT_DATE) AS qtd_contratos_ativos,
    COUNT(DISTINCT r.sequencial_relatorio) AS qtd_relatorios_enviados
FROM projeto p
LEFT JOIN contrato c ON p.id_projeto = c.id_projeto
LEFT JOIN relatorio r ON p.id_projeto = r.id_projeto
GROUP BY p.id_projeto, p.titulo_projeto;
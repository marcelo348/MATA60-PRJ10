--------------------------------------------------------------------
SELECT DISTINCT
    nome_completo,
    FIRST_VALUE(titulo_projeto)  OVER w AS primeiro_projeto,
    FIRST_VALUE(data_assinatura)  OVER w AS inicio_carreira,
    LAST_VALUE(titulo_projeto)   OVER w AS ultimo_projeto,
    LAST_VALUE(data_vencimento)  OVER w AS fim_ultimo_contrato
FROM (
    SELECT
        p.primeiro_nome || ' ' || p.sobrenome AS nome_completo, pr.titulo_projeto,
        c.data_assinatura, c.data_vencimento
    FROM contrato c
    JOIN pesquisador p  ON p.id_pesquisador = c.id_pesquisador
    JOIN projeto    pr  ON pr.id_projeto    = c.id_projeto
) AS base
WINDOW w AS (
    PARTITION BY nome_completo ORDER BY data_assinatura
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
--------------------------------------------------------------------
SELECT
    p.primeiro_nome || ' ' || p.sobrenome AS nome_completo,
    COUNT(c.id_contrato)          AS total_contratos,
    COUNT(c.id_bolsa)            AS contratos_com_bolsa,
    COALESCE(SUM(b.valor_bolsa), 0) AS valor_total_bolsas
FROM pesquisador p
JOIN contrato   c ON c.id_pesquisador = p.id_pesquisador
LEFT JOIN bolsa  b ON b.id_bolsa      = c.id_bolsa
WHERE c.data_vencimento >= CURRENT_DATE
GROUP BY
    p.id_pesquisador, p.cpf_pesquisador,
    p.primeiro_nome, p.sobrenome
--------------------------------------------------------------------
SELECT
    f.nome_financiador,
    f.tipo_financiador,
    COUNT(DISTINCT fi.id_projeto) AS total_projetos,
    COUNT(DISTINCT b.id_bolsa)   AS total_bolsas,
    COUNT(DISTINCT pu.id_publicacao) AS total_publicacoes
FROM financiador f
JOIN financia fi         ON fi.id_financiador = f.id_financiador
LEFT JOIN bolsa b       ON b.id_projeto      = fi.id_projeto
LEFT JOIN publicacao pu ON pu.id_projeto     = fi.id_projeto
GROUP BY f.id_financiador, f.nome_financiador, f.tipo_financiador
--------------------------------------------------------------------
SELECT
    nome_completo,
    total_contratos,
    RANK() OVER (ORDER BY total_contratos DESC) AS ranking
FROM (
    SELECT
        p.primeiro_nome || ' ' || p.sobrenome AS nome_completo,
        COUNT(c.id_contrato) AS total_contratos
    FROM pesquisador p
    JOIN contrato c ON c.id_pesquisador = p.id_pesquisador
    GROUP BY p.id_pesquisador, p.primeiro_nome, p.sobrenome
) AS sub
ORDER BY ranking;
--------------------------------------------------------------------
SELECT
    pr.titulo_projeto,
    b.categoria_bolsa,
    COUNT(b.id_bolsa)  AS qtd_bolsas,
    SUM(b.valor_bolsa) AS total_categoria,
    ROUND(
        SUM(b.valor_bolsa) * 100.0
        / SUM(SUM(b.valor_bolsa)) OVER (PARTITION BY b.id_projeto)
    , 2) AS pct_no_projeto
FROM bolsa b
JOIN projeto pr ON pr.id_projeto = b.id_projeto
GROUP BY
    b.id_projeto, pr.titulo_projeto,
    b.categoria_bolsa
ORDER BY pr.titulo_projeto, total_categoria DESC;
--------------------------------------------------------------------
SELECT
    pr.id_projeto,
    pr.titulo_projeto,
    COUNT(DISTINCT r.sequencial_relatorio) AS total_relatorios,
    COUNT(DISTINCT c.id_pesquisador)       AS total_pesquisadores
FROM projeto pr
LEFT JOIN relatorio r ON r.id_projeto = pr.id_projeto
LEFT JOIN contrato c  ON c.id_projeto = pr.id_projeto
GROUP BY pr.id_projeto, pr.titulo_projeto
HAVING COUNT(DISTINCT r.sequencial_relatorio) > 0
ORDER BY total_relatorios DESC;
--------------------------------------------------------------------

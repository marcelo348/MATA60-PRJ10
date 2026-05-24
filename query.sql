-------------------------------
SELECT DISTINCT  
    nome\_completo,  
    FIRST\_VALUE(titulo\_projeto)  OVER w AS primeiro\_projeto,  
    FIRST\_VALUE(data\_assinatura)  OVER w AS inicio\_carreira,  
    LAST\_VALUE(titulo\_projeto)   OVER w AS ultimo\_projeto,  
    LAST\_VALUE(data\_vencimento)  OVER w AS fim\_ultimo\_contrato  
FROM (  
    SELECT  
        p.primeiro\_nome || ' ' || p.sobrenome AS nome\_completo, pr.titulo\_projeto,  
        c.data\_assinatura, c.data\_vencimento  
    FROM contrato c  
    JOIN pesquisador p  ON p.id\_pesquisador \= c.id\_pesquisador  
    JOIN projeto    pr  ON pr.id\_projeto    \= c.id\_projeto  
) AS base  
WINDOW w AS (  
    PARTITION BY nome\_completo ORDER BY data\_assinatura  
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
-------------------------------
SELECT  
    p.primeiro\_nome || ' ' || p.sobrenome AS nome\_completo,  
    COUNT(c.id\_contrato)          AS total\_contratos,  
    COUNT(c.id\_bolsa)            AS contratos\_com\_bolsa,  
    COALESCE(SUM(b.valor\_bolsa), 0\) AS valor\_total\_bolsas  
FROM pesquisador p  
JOIN contrato   c ON c.id\_pesquisador \= p.id\_pesquisador  
LEFT JOIN bolsa  b ON b.id\_bolsa      \= c.id\_bolsa  
WHERE c.data\_vencimento \>= CURRENT\_DATE  
GROUP BY  
    p.id\_pesquisador, p.cpf\_pesquisador,  
    p.primeiro\_nome, p.sobrenome

-------------------------------
SELECT  
    f.nome\_financiador,  
    f.tipo\_financiador,  
    COUNT(DISTINCT fi.id\_projeto) AS total\_projetos,  
    COUNT(DISTINCT b.id\_bolsa)   AS total\_bolsas,  
    COUNT(DISTINCT pu.id\_publicacao) AS total\_publicacoes  
FROM financiador f  
JOIN financia fi         ON fi.id\_financiador \= f.id\_financiador  
LEFT JOIN bolsa b       ON b.id\_projeto      \= fi.id\_projeto  
LEFT JOIN publicacao pu ON pu.id\_projeto     \= fi.id\_projeto  
GROUP BY f.id\_financiador, f.nome\_financiador, f.tipo\_financiador

-------------------------------

SELECT  
    nome\_completo,  
    total\_contratos,  
    RANK() OVER (ORDER BY total\_contratos DESC) AS ranking  
FROM (  
    SELECT  
        p.primeiro\_nome || ' ' || p.sobrenome AS nome\_completo,  
        COUNT(c.id\_contrato) AS total\_contratos  
    FROM pesquisador p  
    JOIN contrato c ON c.id\_pesquisador \= p.id\_pesquisador  
    GROUP BY p.id\_pesquisador, p.primeiro\_nome, p.sobrenome  
) AS sub  
ORDER BY ranking;
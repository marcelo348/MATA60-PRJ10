Q.1.1

Primeiro e último contrato de cada pesquisador   
Média 0,0204   
Desvio Padrão 0,00203

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

Q.1.2

Pesquisadores com Contratos ativos e suas bolsas (R3,R4)   
Média 0,00795  
Desvio Padrão 0,00131

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

Q.1.3

Financiadores com total de bolsas e publicação por projeto (R1,R2,R5)  
Média 0,0087  
Desvio Padrão 0,00152

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

Q.1.4  
Média 0,0527  
Desvio Padrão 0,00618

Ranking de pesquisadores pelo número de contratos (R4,R7)

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

 

Q.1.5

Valor acumulado de bolsas por categoria (R2,R8)  
Média 0,0091   
Desvio Padrão 0,00137

SELECT  
    pr.titulo\_projeto,  
    b.categoria\_bolsa,  
    COUNT(b.id\_bolsa)  AS qtd\_bolsas,  
    SUM(b.valor\_bolsa) AS total\_categoria,  
    ROUND(  
        SUM(b.valor\_bolsa) \* 100.0  
        / SUM(SUM(b.valor\_bolsa)) OVER (PARTITION BY b.id\_projeto)  
    , 2\) AS pct\_no\_projeto  
FROM bolsa b  
JOIN projeto pr ON pr.id\_projeto \= b.id\_projeto  
GROUP BY  
    b.id\_projeto, pr.titulo\_projeto,  
    b.categoria\_bolsa  
ORDER BY pr.titulo\_projeto, total\_categoria DESC;

Q.1.6  
Média 0,00875  
Desvio Padrão 0,00125

Projetos com número de relatórios e pesquisadores vinculados (R3,R4,R6)

SELECT  
    pr.id\_projeto,  
    pr.titulo\_projeto,  
    COUNT(DISTINCT r.sequencial\_relatorio) AS total\_relatorios,  
    COUNT(DISTINCT c.id\_pesquisador)       AS total\_pesquisadores  
FROM projeto pr  
LEFT JOIN relatorio r ON r.id\_projeto \= pr.id\_projeto  
LEFT JOIN contrato c  ON c.id\_projeto \= pr.id\_projeto  
GROUP BY pr.id\_projeto, pr.titulo\_projeto  
HAVING COUNT(DISTINCT r.sequencial\_relatorio) \> 0  
ORDER BY total\_relatorios DESC;

Q.1.7  
Média 0,00455  
Desvio Padrão 0,00105

Aporte financeiro público x privado (R1,R9)

SELECT  
    pr.titulo\_projeto,  
    COALESCE(SUM(fi.valor\_aportado)  
        FILTER (WHERE LOWER(f.tipo\_financiador) \= 'público'), 0\)  AS aporte\_publico,  
    COALESCE(SUM(fi.valor\_aportado)  
        FILTER (WHERE LOWER(f.tipo\_financiador) \= 'privado'), 0\)  AS aporte\_privado,  
    SUM(fi.valor\_aportado) AS aporte\_total,  
    COUNT(DISTINCT f.id\_financiador)                              AS total\_financiadores  
FROM projeto pr  
JOIN financia   fi ON fi.id\_projeto    \= pr.id\_projeto  
JOIN financiador f  ON f.id\_financiador \= fi.id\_financiador  
GROUP BY pr.id\_projeto, pr.titulo\_projeto  
ORDER BY aporte\_total DESC;

Q.1.8  
Média 0,00915  
Desvio Padrão 0,00087

Publicações com Pesquisadores ativos no lançamento (R3,R4,R5)

SELECT  
    pu.doi,  
    pu.titulo\_publicacao,  
    pu.data\_publicacao,  
    pr.titulo\_projeto,  
    COUNT(c.id\_pesquisador) AS coautores\_ativos  
FROM publicacao pu  
JOIN projeto  pr ON pr.id\_projeto    \= pu.id\_projeto  
JOIN contrato c  ON c.id\_projeto    \= pu.id\_projeto  
    AND c.data\_assinatura \<= pu.data\_publicacao  
    AND c.data\_vencimento  \>= pu.data\_publicacao  
GROUP BY  
    pu.id\_publicacao, pu.doi,  
    pu.titulo\_publicacao, pu.data\_publicacao,  
    pr.titulo\_projeto  
ORDER BY pu.data\_publicacao DESC;

Q.1.9  
Média 0,0249  
Desvio Padrão 0,00224  
Histórico de contratos por pesquisador, com acúmulo de tempo de contrato e dias de trabalho (R3,R4,R7)

SELECT  
    p.primeiro\_nome || ' ' || p.sobrenome     AS nome\_completo,  
    pr.titulo\_projeto,  
    c.tipo\_vinculo,  
    c.data\_assinatura,  
    c.data\_vencimento,  
    (c.data\_vencimento \- c.data\_assinatura)   AS duracao\_dias,  
    SUM(c.data\_vencimento \- c.data\_assinatura)  
        OVER (  
            PARTITION BY c.id\_pesquisador  
            ORDER BY    c.data\_assinatura  
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  
        )                                         AS dias\_acumulados  
FROM contrato c  
JOIN pesquisador p  ON p.id\_pesquisador \= c.id\_pesquisador  
JOIN projeto    pr ON pr.id\_projeto    \= c.id\_projeto  
ORDER BY nome\_completo, c.data\_assinatura;

Q.1.10  
Média 0,0032  
Desvio Padrão 0,00095

Bolsas com pesquisadores vinculados e média do valor (R2,R3,R8)

SELECT  
    b.categoria\_bolsa,  
    COUNT(c.id\_contrato)    AS contratos\_com\_esta\_categoria,  
    ROUND(AVG(b.valor\_bolsa), 2\) AS media\_categoria,  
    ROUND(  
        AVG(AVG(b.valor\_bolsa)) OVER ()  
    , 2\)                       AS media\_global\_categorias,  
    ROUND(  
        AVG(b.valor\_bolsa)  
        \- AVG(AVG(b.valor\_bolsa)) OVER ()  
    , 2\)                       AS desvio\_da\_media\_global  
FROM bolsa b  
JOIN contrato c ON c.id\_bolsa \= b.id\_bolsa  
JOIN projeto  p ON p.id\_projeto \= b.id\_projeto  
GROUP BY b.categoria\_bolsa  
ORDER BY media\_categoria DESC;

Q.1.11  
Média 0,0489  
Desvio Padrão 0,00347

Painel de produtividade por projeto

SELECT  
    pr.titulo\_projeto,  
    pr.data\_inicio,  
    pr.data\_termino,  
    COUNT(DISTINCT fi.id\_financiador)       AS financiadores,  
    COUNT(DISTINCT b.id\_bolsa)              AS bolsas,  
    COUNT(DISTINCT c.id\_pesquisador)        AS pesquisadores,  
    COUNT(DISTINCT pu.id\_publicacao)        AS publicacoes,  
    COUNT(DISTINCT r.sequencial\_relatorio)  AS relatorios  
FROM projeto pr  
LEFT JOIN financia   fi  ON fi.id\_projeto    \= pr.id\_projeto  
LEFT JOIN bolsa      b   ON b.id\_projeto     \= pr.id\_projeto  
LEFT JOIN contrato   c   ON c.id\_projeto     \= pr.id\_projeto  
LEFT JOIN publicacao pu  ON pu.id\_projeto    \= pr.id\_projeto  
LEFT JOIN relatorio  r   ON r.id\_projeto     \= pr.id\_projeto  
GROUP BY  
    pr.id\_projeto, pr.titulo\_projeto,  
    pr.data\_inicio, pr.data\_termino  
ORDER BY publicacoes DESC, relatorios DESC;

Q.2.1

Média 0,00695  
Desvio Padrão 0,00131

Pesquisadores acima de sua média de contratos(R4,R7)

SELECT  
    p.primeiro\_nome || ' ' || p.sobrenome AS nome\_completo,  
    COUNT(c.id\_contrato) AS total\_contratos  
FROM pesquisador p  
JOIN contrato c  ON c.id\_pesquisador \= p.id\_pesquisador  
JOIN projeto  pr ON pr.id\_projeto   \= c.id\_projeto  
GROUP BY p.id\_pesquisador, p.primeiro\_nome, p.sobrenome  
HAVING COUNT(c.id\_contrato) \> (  
    SELECT AVG(cnt) FROM (  
        SELECT COUNT(id\_contrato) AS cnt  
        FROM contrato  
        GROUP BY id\_pesquisador  
    ) AS sub  
)

Q.2.2

Média   
Desvio Padrão

Pesquisadores em múltiplos projetos(R4,R7)

SELECT  
    p.primeiro\_nome || ' ' || p.sobrenome AS nome\_completo,  
    COUNT(DISTINCT c.id\_projeto) AS projetos\_distintos  
FROM pesquisador p  
JOIN contrato c ON c.id\_pesquisador \= p.id\_pesquisador  
WHERE p.id\_pesquisador IN (  
    SELECT id\_pesquisador FROM contrato  
    GROUP BY id\_pesquisador  
    HAVING COUNT(DISTINCT id\_projeto) \> 1  
)  
GROUP BY p.id\_pesquisador, p.primeiro\_nome, p.sobrenome

Q.2.3

Média   
Desvio Padrão

Bolsistas Jamais associados a um contrato (R2,R3)

SELECT  
    pr.titulo\_projeto,  
    b.categoria\_bolsa,  
    b.valor\_bolsa,  
    b.numero\_processo,  
    (  
        SELECT COUNT(\*) FROM bolsa b2  
        WHERE b2.id\_projeto \= pr.id\_projeto  
    ) AS total\_bolsas\_projeto  
FROM bolsa b  
JOIN projeto pr ON pr.id\_projeto \= b.id\_projeto  
WHERE b.id\_bolsa NOT IN (  
    SELECT id\_bolsa FROM contrato  
    WHERE id\_bolsa IS NOT NULL  
)  
ORDER BY pr.titulo\_projeto, b.categoria\_bolsa;

Q.2.4  
Média   
Desvio Padrão

Pesquisador que recebe a maior bolsa por projeto(R2,R3,R4)

SELECT titulo\_projeto, nome\_completo, titulacao, tipo\_vinculo, valor\_bolsa  
FROM (  
    SELECT  
        pr.titulo\_projeto,  
        p.primeiro\_nome || ' ' || p.sobrenome AS nome\_completo,  
        p.titulacao, c.tipo\_vinculo, b.valor\_bolsa,  
        ROW\_NUMBER() OVER (  
            PARTITION BY pr.id\_projeto  
            ORDER BY b.valor\_bolsa DESC  
        ) AS rn  
    FROM contrato c  
    JOIN pesquisador p  ON p.id\_pesquisador \= c.id\_pesquisador  
    JOIN projeto    pr  ON pr.id\_projeto    \= c.id\_projeto  
    JOIN bolsa       b  ON b.id\_bolsa       \= c.id\_bolsa  
) AS ranked  
WHERE rn \= 1  
ORDER BY titulo\_projeto;

Q.2.5  
Média   
Desvio Padrão

Financiadores financiando projetos sem relatório(1,6,9)

SELECT  
    f.nome\_financiador, f.tipo\_financiador,  
    COUNT(DISTINCT fi.id\_projeto) AS projetos\_sem\_relatorio,  
    SUM(fi.valor\_aportado)        AS total\_aportado  
FROM financiador f  
JOIN financia fi ON fi.id\_financiador \= f.id\_financiador  
JOIN projeto  pr ON pr.id\_projeto     \= fi.id\_projeto  
WHERE NOT EXISTS (  
    SELECT 1 FROM relatorio r  
    WHERE r.id\_projeto \= fi.id\_projeto  
)  
GROUP BY f.id\_financiador, f.nome\_financiador, f.tipo\_financiador  
ORDER BY total\_aportado DESC;

Q.2.6  
Média   
Desvio Padrão

Pesquisadores sem bolsa ou projeto

SELECT  
    p.primeiro\_nome || ' ' || p.sobrenome AS nome\_completo,  
    p.titulacao,  
    COUNT(c.id\_contrato)         AS total\_contratos,  
    COUNT(DISTINCT c.id\_projeto) AS projetos\_distintos  
FROM pesquisador p  
JOIN contrato c  ON c.id\_pesquisador \= p.id\_pesquisador  
JOIN projeto  pr ON pr.id\_projeto   \= c.id\_projeto  
WHERE NOT EXISTS (  
    SELECT 1 FROM contrato c2  
    WHERE c2.id\_pesquisador \= p.id\_pesquisador  
      AND c2.id\_bolsa IS NOT NULL  
)  
GROUP BY p.id\_pesquisador, p.primeiro\_nome, p.sobrenome, p.titulacao  
ORDER BY total\_contratos DESC;

Q.2.7  
Média   
Desvio Padrão

Projetos financiados só por capital privado(1,9)

SELECT  
    pr.titulo\_projeto,  
    COUNT(DISTINCT fi.id\_financiador) AS total\_financiadores,  
    SUM(fi.valor\_aportado) AS total\_aportado  
FROM projeto pr  
JOIN financia    fi ON fi.id\_projeto    \= pr.id\_projeto  
JOIN financiador f  ON f.id\_financiador \= fi.id\_financiador  
WHERE pr.id\_projeto IN (  
    SELECT fi2.id\_projeto  
    FROM financia fi2  
    JOIN financiador f2 ON f2.id\_financiador \= fi2.id\_financiador  
    GROUP BY fi2.id\_projeto  
    HAVING COUNT(\*) FILTER (WHERE LOWER(f2.tipo\_financiador) \= 'público') \= 0  
)  
GROUP BY pr.id\_projeto, pr.titulo\_projeto  
ORDER BY total\_aportado DESC;

Q.2.8

Média   
Desvio Padrão

Pesquisadores com projetos com múltiplos financiadores(1,3,4)

SELECT  
    p.primeiro\_nome || ' ' || p.sobrenome AS nome\_completo,  
    p.titulacao,  
    COUNT(DISTINCT c.id\_projeto) AS projetos\_multi\_financiados,  
    COUNT(c.id\_contrato)          AS total\_contratos  
FROM pesquisador p  
JOIN contrato c ON c.id\_pesquisador \= p.id\_pesquisador  
WHERE c.id\_projeto IN (  
    SELECT id\_projeto FROM financia  
    GROUP BY id\_projeto  
    HAVING COUNT(DISTINCT id\_financiador) \> 1  
)  
GROUP BY p.id\_pesquisador, p.primeiro\_nome, p.sobrenome, p.titulacao  
ORDER BY projetos\_multi\_financiados DESC;

Q.2.9

Média   
Desvio Padrão

Concentração de bolsas de doutorado por projeto

SELECT  
    pr.titulo\_projeto,  
    total\_bolsas, bolsas\_doutorado,  
    ROUND(100.0 \* bolsas\_doutorado / NULLIF(total\_bolsas, 0), 2\) AS pct\_doutorado  
FROM projeto pr  
JOIN (  
    SELECT  
        id\_projeto,  
        COUNT(\*) AS total\_bolsas,  
        COUNT(\*) FILTER (WHERE LOWER(categoria\_bolsa) \= 'doutorado') AS bolsas\_doutorado  
    FROM bolsa GROUP BY id\_projeto  
) AS resumo ON resumo.id\_projeto \= pr.id\_projeto  
JOIN financia fi ON fi.id\_projeto \= pr.id\_projeto  
WHERE bolsas\_doutorado \> 0  
GROUP BY pr.id\_projeto, pr.titulo\_projeto, total\_bolsas, bolsas\_doutorado  
ORDER BY pct\_doutorado DESC;

Q.2.10

Média   
Desvio Padrão

Quantidade de publicações por milhão investido

SELECT  
    f.nome\_financiador, f.tipo\_financiador,  
    total\_aportado, total\_publicacoes,  
    ROUND(total\_publicacoes::NUMERIC / NULLIF(total\_aportado, 0\) \* 1000000, 4\)  
        AS publicacoes\_por\_milhao\_reais  
FROM financiador f  
JOIN (  
    SELECT  
        fi.id\_financiador,  
        SUM(fi.valor\_aportado) AS total\_aportado,  
        COUNT(DISTINCT pu.id\_publicacao) AS total\_publicacoes  
    FROM financia fi  
    JOIN projeto    pr ON pr.id\_projeto  \= fi.id\_projeto  
    LEFT JOIN publicacao pu ON pu.id\_projeto \= fi.id\_projeto  
    GROUP BY fi.id\_financiador  
) AS desempenho ON desempenho.id\_financiador \= f.id\_financiador


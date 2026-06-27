CREATE OR REPLACE PROCEDURE sp_promover_voluntario(
    p_id_pesquisador INTEGER,
    p_id_projeto INTEGER,
    p_valor_bolsa DECIMAL,
    p_categoria_bolsa VARCHAR,
    p_numero_processo VARCHAR,
    p_nova_titulacao VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_contrato_antigo INTEGER;
    v_nova_bolsa INTEGER;
BEGIN
    SELECT id_contrato INTO v_contrato_antigo
    FROM Contrato 
    WHERE fk_pesquisador_id_pesquisador = p_id_pesquisador 
      AND fk_projeto_id_projeto = p_id_projeto
      AND fk_bolsa_id_bolsa IS NULL 
      AND data_vencimento >= CURRENT_DATE
    LIMIT 1;

    IF v_contrato_antigo IS NOT NULL THEN
        UPDATE Contrato 
        SET data_vencimento = CURRENT_DATE, 
            tipo_vinculo = 'Encerrado - Promovido'
        WHERE id_contrato = v_contrato_antigo;

        UPDATE Pesquisador 
        SET titulacao = p_nova_titulacao 
        WHERE id_pesquisador = p_id_pesquisador;

        INSERT INTO Bolsa (fk_projeto_id_projeto, valor_bolsa, categoria_bolsa, numero_processo)
        VALUES (p_id_projeto, p_valor_bolsa, p_categoria_bolsa, p_numero_processo)
        RETURNING id_bolsa INTO v_nova_bolsa;

        INSERT INTO Contrato (fk_bolsa_id_bolsa, fk_projeto_id_projeto, fk_pesquisador_id_pesquisador, data_assinatura, data_vencimento, tipo_vinculo)
        VALUES (v_nova_bolsa, p_id_projeto, CURRENT_DATE, CURRENT_DATE + INTERVAL '1 year', 'Bolsista');
        
        RAISE NOTICE 'Pesquisador promovido com sucesso!';
    ELSE
        RAISE EXCEPTION 'Nenhum contrato de voluntário ativo encontrado para este pesquisador no projeto.';
    END IF;
END;
$$;
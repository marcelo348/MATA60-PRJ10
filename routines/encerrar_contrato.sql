CREATE OR REPLACE PROCEDURE sp_encerramento_emergencial(
    p_id_projeto INTEGER,
    p_motivo VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_contratos INTEGER;
    v_titulo_projeto VARCHAR;
BEGIN
    SELECT COUNT(*) INTO v_total_contratos
    FROM contrato 
    WHERE id_projeto = p_id_projeto AND data_vencimento > CURRENT_DATE;

    SELECT titulo_projeto INTO v_titulo_projeto
    FROM projeto 
    WHERE id_projeto = p_id_projeto;

    DELETE FROM relatorio 
    WHERE id_projeto = p_id_projeto AND LENGTH(texto_conteudo) < 10;

    UPDATE projeto 
    SET data_termino = CURRENT_DATE, 
        titulo_projeto = titulo_projeto || ' (ENCERRADO)'
    WHERE id_projeto = p_id_projeto;

    UPDATE contrato 
    SET data_vencimento = CURRENT_DATE, 
        tipo_vinculo = 'Cancelado'
    WHERE id_projeto = p_id_projeto AND data_vencimento > CURRENT_DATE;

    INSERT INTO relatorio (id_projeto, sequencial_relatorio, data_submissao, texto_conteudo)
    VALUES (
        p_id_projeto, 
        COALESCE((SELECT MAX(sequencial_relatorio) FROM relatorio WHERE id_projeto = p_id_projeto), 0) + 1, 
        CURRENT_DATE, 
        'Encerramento emergencial. Motivo: ' || p_motivo || '. Contratos afetados: ' || v_total_contratos
    );

    RAISE NOTICE 'Projeto encerrado e transação concluída com sucesso.';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Erro detectado. Transação cancelada (Rollback). Erro: %', SQLERRM;
        ROLLBACK;
END;
$$;
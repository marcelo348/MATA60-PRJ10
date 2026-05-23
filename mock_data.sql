INSERT INTO projeto (titulo_projeto, data_inicio, data_termino) VALUES
(4, 4, 4, '2025-01-20', '2025-12-20', 'Pesquisador'),
(5, 5, 5, '2025-04-12', '2026-04-12', 'Bolsista'),
(6, 6, 6, '2025-05-01', '2026-05-01', 'Coordenador'),
(7, 7, 7, '2025-06-01', '2026-06-01', 'Pesquisador'),
(8, 8, 8, '2025-02-01', '2027-02-01', 'Pesquisador Principal'),
(9, 9, 9, '2025-03-18', '2026-03-18', 'Bolsista'),
(10, 10, 10, '2025-07-01', '2027-07-01', 'Coordenador'),
(11, 11, 11, '2025-08-10', '2026-08-10', 'Pesquisador'),
(12, 12, 12, '2025-04-05', '2026-04-05', 'Bolsista'),
(13, 13, 13, '2025-03-03', '2026-03-03', 'Pesquisador'),
(14, 14, 14, '2025-05-20', '2026-05-20', 'Coordenador'),
(15, 15, 15, '2025-06-11', '2026-06-11', 'Pesquisador Principal');

-- =========================
-- PUBLICAÇÕES (10)
-- =========================
INSERT INTO publicacao (id_projeto, doi, titulo_publicacao, data_publicacao) VALUES
(1, '10.1000/001', 'Aplicações de IA Médica', '2025-06-01'),
(2, '10.1000/002', 'Robótica em Escolas Públicas', '2025-06-02'),
(3, '10.1000/003', 'Mudanças Climáticas no Brasil', '2025-06-03'),
(4, '10.1000/004', 'Blockchain Universitário', '2025-06-04'),
(5, '10.1000/005', 'Genética Computacional Moderna', '2025-06-05'),
(6, '10.1000/006', 'IoT em Grandes Cidades', '2025-06-06'),
(7, '10.1000/007', 'Defesa Digital Avançada', '2025-06-07'),
(8, '10.1000/008', 'Introdução à Computação Quântica', '2025-06-08'),
(9, '10.1000/009', 'Big Data e Agricultura', '2025-06-09'),
(10, '10.1000/010', 'Fontes Renováveis Inteligentes', '2025-06-10');

-- =========================
-- RELATÓRIOS (10)
-- =========================
INSERT INTO relatorio (id_projeto, sequencial_relatorio, data_submissao, texto_conteudo) VALUES
(1, 1, '2025-07-01', 'Relatório parcial do projeto 1'),
(2, 1, '2025-07-02', 'Relatório parcial do projeto 2'),
(3, 1, '2025-07-03', 'Relatório parcial do projeto 3'),
(4, 1, '2025-07-04', 'Relatório parcial do projeto 4'),
(5, 1, '2025-07-05', 'Relatório parcial do projeto 5'),
(6, 1, '2025-07-06', 'Relatório parcial do projeto 6'),
(7, 1, '2025-07-07', 'Relatório parcial do projeto 7'),
(8, 1, '2025-07-08', 'Relatório parcial do projeto 8'),
(9, 1, '2025-07-09', 'Relatório parcial do projeto 9'),
(10, 1, '2025-07-10', 'Relatório parcial do projeto 10');

-- =========================
-- FINANCIA (10)
-- =========================
INSERT INTO financia (id_financiador, id_projeto, valor_aportado) VALUES
(1, 1, 100000.00),
(2, 2, 120000.00),
(3, 3, 90000.00),
(4, 4, 150000.00),
(5, 5, 200000.00),
(6, 6, 110000.00),
(7, 7, 175000.00),
(8, 8, 98000.00),
(9, 9, 143000.00),
(10, 10, 210000.00);

-- Total de registros inseridos: 105
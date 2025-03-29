-- Database: meudb

-- DROP DATABASE IF EXISTS meudb;

CREATE DATABASE meudb
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Criando as tabelas demonstracoes_contabeis e relatorio_cadop
-- Os colunas VL_SALDO_INICIAL E VL_SALDO_FINAL serão criadas incialmente com o tipo TEXT
-- motivo: Quando formatada para o tipo NUMERIC, espera-se que as casas decimais sejam 
-- separadas por '.' e não ',' como está nos arquivos CSV, ao carregar toda a base de dados
-- faremos a conversão necessária.
CREATE TABLE demonstracoes_contabeis(
	DATA DATE NOT NULL,
	REG_ANS VARCHAR(8) NOT NULL,
	CD_CONTA_CONTABIL VARCHAR(9) NOT NULL,
	DESCRICAO VARCHAR(150) NOT NULL,
	VL_SALDO_INICIAL TEXT NOT NULL,
	VL_SALDO_FINAL TEXT NOT NULL
);

CREATE TABLE relatorio_cadop(
	REGISTRO_ANS VARCHAR(6) NOT NULL,
	CNPJ VARCHAR(14) NOT NULL,
	RAZAO_SOCIAL VARCHAR(140) NOT NULL,
	NOME_FANTASIA VARCHAR(140),
	MODALIDADE VARCHAR(50) NOT NULL,
	LOGRADOURO VARCHAR(40) NOT NULL,
	NUMERO VARCHAR(20),
	COMPLEMENTO VARCHAR(40),
	BAIRRO VARCHAR(30) NOT NULL,
	CIDADE VARCHAR(30) NOT NULL,
	UF VARCHAR(2) NOT NULL,
	CEP VARCHAR(8) NOT NULL,
	DDD VARCHAR(2),
	TELEFONE VARCHAR(20),
	FAX VARCHAR(20),
	ENDERECO_ELETRONICO VARCHAR(255),
	REPRESENTANTE VARCHAR(50) NOT NULL,
	CARGO_REPRESENTANTE VARCHAR(40) NOT NULL,
	REGIAO_DE_COMERCIALIZACAO VARCHAR(1),
	DATA_REGISTRO_ANS DATE NOT NULL
);

-- Populando as tabelas com os arquivos csv preparados anteriormente.
-- Por questão de permissões, todos os arquivos serão movidos para a pasta '/tmp/', pois o postgres
-- possui permissão para manipular arquivos nessa pasta.
COPY demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/1T2023.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');

COPY demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/2T2023.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');

COPY demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/3T2023.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');

COPY demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/4T2023.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');

COPY demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/1T2024.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');

COPY demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/2T2024.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');

COPY demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/3T2024.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');

COPY demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/4T2024.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');

-- Populando a tabela relatorio_cadop com o arquivo csv preparado anteriormente
COPY relatorio_cadop(registro_ans, cnpj, razao_social, nome_fantasia, modalidade, logradouro, numero, complemento, bairro, cidade, uf, cep, ddd, telefone, fax, endereco_eletronico, representante, cargo_representante, regiao_de_comercializacao, data_registro_ans)
FROM '/tmp/Relatorio_cadop.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');

-- Fazendo a conversão necessária nas colunas VL_SALDO_INICIAL e VL_SALDO_FINAL para posteriormente
-- criar query analítica
ALTER TABLE demonstracoes_contabeis 
ALTER COLUMN VL_SALDO_INICIAL TYPE NUMERIC USING REPLACE(VL_SALDO_INICIAL, ',', '.')::NUMERIC,
ALTER COLUMN VL_SALDO_FINAL TYPE NUMERIC USING REPLACE(VL_SALDO_FINAL, ',', '.')::NUMERIC;

-- Quais as 10 operadoras com maiores despesas em "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR"
-- no último trimestre?
SELECT REG_ANS, 
       DESCRICAO, 
       VL_SALDO_INICIAL, 
       VL_SALDO_FINAL,
       (VL_SALDO_INICIAL - VL_SALDO_FINAL) AS DESPESA
FROM demonstracoes_contabeis
WHERE DATA = '2024-10-01'
  AND DESCRICAO = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
ORDER BY DESPESA DESC
LIMIT 10;

-- Quais as 10 operadoras com maiores despesas nessa categoria no último ano?
SELECT REG_ANS, 
       DESCRICAO, 
       VL_SALDO_INICIAL, 
       VL_SALDO_FINAL,
       (VL_SALDO_INICIAL - VL_SALDO_FINAL) AS DESPESA
FROM demonstracoes_contabeis
WHERE EXTRACT(YEAR FROM DATA) = 2024
  AND DESCRICAO = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
ORDER BY DESPESA DESC
LIMIT 10;

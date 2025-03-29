# Menu de Testes

- [🛠️ Teste 1 - Web Scraping](https://github.com/xMarkhus/testest-de-nivelamento#teste-1---web-scraping)
- [🔄 Teste 2 - Transformação de Dados](https://github.com/xMarkhus/testest-de-nivelamento#teste-2---transformacao-de-dados)
- [🗄️ Teste 3 - Banco de Dados](https://github.com/xMarkhus/testest-de-nivelamento#teste-3---banco-de-dados)
- [🌐 Teste 4 - API](https://github.com/xMarkhus/testest-de-nivelamento#teste-4---api)



# 🕵️‍♂️ Teste 1 - Web Scraping

## 📌 Descrição
Este teste tem como objetivo a extração automática de documentos em PDF do site da **Agência Nacional de Saúde Suplementar (ANS)**, salvando e compactando os arquivos.

## 📜 Requisitos

✅ Acessar a página oficial da ANS:
[Atualização do Rol de Procedimentos](https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos)

✅ Fazer o download dos arquivos **Anexo I** e **Anexo II** em formato PDF.

✅ Compactar os arquivos baixados em um único arquivo ZIP.

## 📂 Estrutura do Repositório

```
📦 test1_web_scraping
 ┣ 📜 web_scraping.py  # Script principal para extração e compactação dos PDFs
 ┗ 📂 outputs          # Pasta onde os PDFs baixados e o ZIP final serão armazenados
```

## 🚀 Como Executar

1️⃣ **Clone o repositório**
```bash
git clone https://github.com/seu-usuario/nome-do-repositorio.git
cd nome-do-repositorio/test1_web_scraping
```

2️⃣ **Instale as dependências**
```bash
pip install -r requirements.txt  # Caso tenha um arquivo de dependências
```

3️⃣ **Execute o script**
```bash
python web_scraping.py
```

## 🛠️ Tecnologias Utilizadas
- **Python** 🐍
- **Requests** 📡
- **BeautifulSoup** 🌐
- **Zipfile** 📦




# 🔄 Teste 2 - Transformação de Dados

## 📌 Descrição
Este teste tem como objetivo a extração, transformação e armazenamento de dados do **Anexo I** do teste de Web Scraping, organizando as informações em um formato estruturado.

## 📜 Requisitos

✅ Extrair os dados da tabela **Rol de Procedimentos e Eventos em Saúde** do **Anexo I** baixado no teste 1.

✅ Salvar os dados extraídos em um arquivo CSV.

✅ Compactar o arquivo CSV em um ZIP denominado **Teste_Marcos_Rogerio.zip**.

✅ Substituir as abreviações das colunas **OD** e **AMB** por **Seg. Odontológica** e **Seg. Ambulatorial**, respectivamente.

## 📂 Estrutura do Repositório

```
📦 teste2_transform_dados
 ┣ 📜 transformacao_dados.py  # Script principal para extração e transformação dos dados
 ┗ 📂 outputs                 # Pasta onde será salvo o CSV e o arquivo ZIP final
```

## 🚀 Como Executar

1️⃣ **Clone o repositório**
```bash
git clone https://github.com/seu-usuario/nome-do-repositorio.git
cd nome-do-repositorio/teste2_transform_dados
```

2️⃣ **Instale as dependências**
```bash
pip install -r requirements.txt  # Caso tenha um arquivo de dependências
```

3️⃣ **Execute o script**
```bash
python transformacao_dados.py
```

## 🛠️ Tecnologias Utilizadas
- **Python** 🐍
- **Pandas** 📊
- **Tabula** 📄
- **Zipfile** 📦




# 🗃️ Teste 3: Banco de Dados

## Objetivo
Este teste tem como objetivo criar um banco de dados PostgreSQL, carregar dados a partir de arquivos CSV e realizar consultas analíticas.

## Pré-requisitos
- PostgreSQL instalado (recomenda-se versão 12 ou superior).
- Acesso ao terminal psql ou ao PgAdmin para execução dos scripts.
- Arquivos CSV armazenados na pasta `/tmp/` (Linux) ou `c:/tmp/` (Windows), garantindo que o PostgreSQL tenha permissão para acessá-los.

## Estrutura do Banco de Dados

### Criação do Banco de Dados
```sql
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
```

### Tabelas Criadas

#### demonstracoes_contabeis
```sql
CREATE TABLE demonstracoes_contabeis(
    DATA DATE NOT NULL,
    REG_ANS VARCHAR(8) NOT NULL,
    CD_CONTA_CONTABIL VARCHAR(9) NOT NULL,
    DESCRICAO VARCHAR(150) NOT NULL,
    VL_SALDO_INICIAL TEXT NOT NULL,
    VL_SALDO_FINAL TEXT NOT NULL
);
```

#### relatorio_cadop
```sql
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
```

## Carga de Dados

Os arquivos CSV são carregados diretamente para as tabelas usando o comando `COPY`.

### Carga para demonstracoes_contabeis
```sql
COPY demonstracoes_contabeis(data, reg_ans, cd_conta_contabil, descricao, vl_saldo_inicial, vl_saldo_final)
FROM '/tmp/1T2023.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');

-- Repetir para os demais trimestres e anos.
```

### Carga para relatorio_cadop
```sql
COPY relatorio_cadop(registro_ans, cnpj, razao_social, nome_fantasia, modalidade, logradouro, numero, complemento, bairro, cidade, uf, cep, ddd, telefone, fax, endereco_eletronico, representante, cargo_representante, regiao_de_comercializacao, data_registro_ans)
FROM '/tmp/Relatorio_cadop.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ';');
```

## Conversão de Dados
Após a carga, os valores das colunas `VL_SALDO_INICIAL` e `VL_SALDO_FINAL` são convertidos para `NUMERIC`, substituindo `,` por `.` para manter a formatação correta.

```sql
ALTER TABLE demonstracoes_contabeis
ALTER COLUMN VL_SALDO_INICIAL TYPE NUMERIC USING REPLACE(VL_SALDO_INICIAL, ',', '.')::NUMERIC,
ALTER COLUMN VL_SALDO_FINAL TYPE NUMERIC USING REPLACE(VL_SALDO_FINAL, ',', '.')::NUMERIC;
```

## Consultas Analíticas

### Top 10 operadoras com maiores despesas no último trimestre
```sql
SELECT REG_ANS,
       DESCRICAO,
       VL_SALDO_INICIAL,
       VL_SALDO_FINAL,
       (VL_SALDO_INICIAL - VL_SALDO_FINAL) AS DESPESA
FROM demonstracoes_contabeis
WHERE DATA = '2024-10-01'
  AND DESCRICAO = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
ORDER BY DESPESA DESC
LIMIT 10;
```

### Top 10 operadoras com maiores despesas no último ano
```sql
SELECT REG_ANS,
       DESCRICAO,
       VL_SALDO_INICIAL,
       VL_SALDO_FINAL,
       (VL_SALDO_INICIAL - VL_SALDO_FINAL) AS DESPESA
FROM demonstracoes_contabeis
WHERE EXTRACT(YEAR FROM DATA) = 2024
  AND DESCRICAO = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
ORDER BY DESPESA DESC
LIMIT 10;
```

## Considerações
- No Windows, alterar os caminhos dos arquivos para `c:/tmp/arquivo.csv` antes de rodar os scripts no PgAdmin.
- Certifique-se de que a pasta `/tmp/` (Linux) ou `c:/tmp/` (Windows) contém os arquivos necessários.
- Se houver erros de permissão ao carregar os arquivos, verificar as configurações de permissões no PostgreSQL.

## Ferramentas Utilizadas
- PostgreSQL
- psql / PgAdmin
- SQL para manipulação e análise de dados.

# 🔍 Teste 4 - API

Este projeto consiste em uma aplicação web que permite a busca de operadoras de saúde em um relatório CSV. O backend foi desenvolvido com **FastAPI** e o frontend com **Vue.js** e **Tailwind CSS**.

## 🛠️ Tecnologias Utilizadas

- **Backend:** FastAPI, Pandas, Unidecode
- **Frontend:** Vue.js, Tailwind CSS
- **API de Busca:** FastAPI com suporte para busca textual no CSV

## ⚙️ Pré-requisitos

Antes de começar, verifique se você tem as seguintes ferramentas instaladas:

- Python 3.8 ou superior 🐍
- Node.js e npm 📦
- Vue CLI ⚙️
- Postman (para testes de API) 🚶‍♂️

## 🏁 Instalação

### Backend (FastAPI)

1. Clone o repositório:
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd <PASTA_DO_REPOSITORIO>/backend
   ```

2. Crie e ative um ambiente virtual:
   ```bash
   python -m venv venv
   source venv/bin/activate  # Para Linux/MacOS
   venv\Scripts\activate     # Para Windows
   ```

3. Instale as dependências do backend:
   ```bash
   pip install -r requirements.txt
   ```

4. Inicie o servidor FastAPI:
   ```bash
   uvicorn server:app --reload
   ```

   O servidor estará rodando em `http://localhost:8000`.

### Frontend (Vue.js)

1. Navegue até a pasta do frontend:
   ```bash
   cd <PASTA_DO_REPOSITORIO>/frontend
   ```

2. Instale as dependências do frontend:
   ```bash
   npm install
   ```

3. Inicie o servidor de desenvolvimento:
   ```bash
   npm run dev
   ```

   O frontend estará disponível em `http://localhost:5173`.

## 🔍 Funcionalidade

A aplicação permite realizar uma busca textual no relatório de operadoras. O backend irá processar a consulta e retornar os registros mais relevantes, que serão exibidos no frontend.

### Backend

O backend utiliza **FastAPI** para processar a busca no arquivo CSV. A rota de busca é acessada por meio de:

```
GET http://localhost:8000/buscar?q=<query>
```

Onde `<query>` é o termo de busca. A API irá retornar os registros mais relevantes baseados no termo buscado.

### Frontend

No frontend, o usuário pode digitar o termo desejado na barra de pesquisa. O resultado da busca será exibido com as informações da operadora, como:

- 📜 Registro ANS
- 📅 Data de Registro ANS
- 🏢 Razão Social
- 🏢 CNPJ
- 👤 Representante
- 💼 Cargo do Representante
- 🏠 CEP
- 🗺️ UF
- 🏙️ Cidade
- 💼 Modalidade

## 🧪 Testando a API no Postman

1. Abra o Postman.
2. Crie uma nova requisição GET:
   ```
   GET http://localhost:8000/buscar?q=<query>
   ```
3. Substitua `<query>` pelo termo que deseja buscar, por exemplo: `Saúde`.
4. Clique em "Send" e veja a resposta da API.

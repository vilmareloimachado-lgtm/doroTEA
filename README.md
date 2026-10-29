# doroTEA

Plataforma web para apoiar a organização de rotinas e atividades educacionais de pessoas com Transtorno do Espectro Autista (TEA), conectando cuidadores e sua rede de apoio.

Projeto desenvolvido no curso **Jovem Programador — Senac Palhoça**.

## Problema, público-alvo e solução

Atividades com muitas etapas podem ser difíceis de organizar e acompanhar. O doroTEA permite dividir tarefas em passos curtos, acompanhar sua conclusão e compartilhar materiais de apoio.

O público-alvo inclui pessoas com TEA, familiares, cuidadores e profissionais de apoio. Cada perfil pode ter um cuidador principal e outros cuidadores vinculados, formando uma rede de acompanhamento.

## Funcionalidades

- Cadastro e autenticação de cuidadores com e-mail e senha.
- Perfis TEA com PIN opcional.
- Vínculos entre cuidadores e perfis, com transferência de cuidador principal.
- Tarefas diárias e educacionais com prioridade, prazo e acompanhamento de conclusão.
- Criação e acompanhamento de passos, manualmente ou com sugestões do Gemini.
- Chat com IA e dashboard de acompanhamento.
- Materiais de apoio por links, com descrição, imagem por URL, aprovação e registro de visualização.
- Interface responsiva, leitura de textos em voz alta, FAQ e manual.

A leitura em voz alta depende dos recursos e vozes disponíveis no navegador. As funções de IA exigem internet e uma chave válida do Gemini.

## Tecnologias e arquitetura

| Camada | Tecnologias / responsabilidade |
| --- | --- |
| Interface | HTML, CSS e JavaScript |
| API | Python, FastAPI e Uvicorn |
| Persistência | MySQL, SQLAlchemy e mysql-connector-python |
| Autenticação | JWT (PyJWT) e bcrypt |
| Inteligência artificial | Google Gemini, via google-genai |
| Configuração | Variáveis de ambiente e python-dotenv |

Fluxo do backend: rotas da API → controllers → services (regras de negócio) → repositories → MySQL.

## Pré-requisitos

- Python 3.10 ou superior.
- MySQL em execução e um usuário com permissão para criar o banco e suas tabelas.
- Git para clonar o repositório.
- Navegador atualizado.
- Chave do Gemini para utilizar chat e geração de passos.

As dependências Python estão em [requirements.txt](requirements.txt). O MySQL deve ser instalado separadamente. Os comandos abaixo são destinados ao Windows/PowerShell.

## Instalação

### 1. Obter o código

```powershell
git clone https://github.com/vilmareloimachado-lgtm/doroTEA.git
cd doroTEA
```

A branch `main` contém a versão de entrega. A branch `Vilmar` é utilizada no desenvolvimento.

### 2. Criar um ambiente virtual e instalar dependências

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

Os comandos usam diretamente o Python do ambiente virtual, sem exigir a ativação de scripts no PowerShell.

### 3. Configurar o ambiente

Crie um arquivo chamado `.env` na raiz do projeto:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=sua_senha_do_mysql
DB_NAME=tea_db
SECRET_KEY=substitua_por_uma_chave_aleatoria
GEMINI_API_KEY=sua_chave_do_gemini
```

Gere um valor para `SECRET_KEY` com:

```powershell
.\.venv\Scripts\python.exe -c "import secrets; print(secrets.token_hex(32))"
```

Use suas próprias credenciais. Não publique senhas ou chaves no GitHub. Sem `GEMINI_API_KEY`, as funções de IA ficam indisponíveis.

### 4. Criar um banco novo

No MySQL Workbench, conectado ao servidor, execute:

```sql
CREATE DATABASE IF NOT EXISTS tea_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

Se escolher outro nome, ajuste também `DB_NAME` no `.env`.

Para um banco vazio, crie todas as tabelas usando os modelos atuais. Execute na raiz do projeto:

```powershell
.\.venv\Scripts\python.exe -c "from config.database import Base, engine; import models.usuario, models.vinculo, models.tarefa, models.passo, models.material; Base.metadata.create_all(engine); print('Tabelas criadas.')"
```

**Banco já existente:** `create_all` cria tabelas ausentes, mas não atualiza colunas de tabelas existentes. O modelo atual exige, entre outros campos, `vinculos.pode_enviar_materiais_sem_aprovacao`. Um banco antigo precisa de migração antes de usar a versão atual.

**Atenção ao `database.sql`:** é um script antigo que apaga e recria tabelas; não contempla toda a estrutura atual de materiais. Para uma instalação nova, utilize o procedimento acima. Não execute esse script sobre dados que deseja preservar.

## Execução

### 1. Iniciar a API

Na raiz do projeto:

```powershell
.\.venv\Scripts\python.exe -m uvicorn api_app:app --reload
```

Com o ambiente Python já configurado, o comando equivalente é:

```powershell
python -m uvicorn api_app:app --reload
```

- API: http://127.0.0.1:8000/
- Documentação interativa (Swagger): http://127.0.0.1:8000/docs

A rota inicial deve retornar o nome do sistema e `"api": "funcionando"`.

### 2. Abrir a interface

Mantenha o terminal da API aberto. Em um segundo terminal, na raiz do projeto, execute:

```powershell
.\.venv\Scripts\python.exe -m http.server 5500 --bind 127.0.0.1
```

Abra http://127.0.0.1:5500/index.html no navegador. O servidor da interface e a API são processos separados: ambos devem permanecer ativos.

A interface deve apontar para a API local na porta `8000`. Se a configuração de endereço da API no HTML tiver sido alterada em sua cópia, ajuste-a para `http://127.0.0.1:8000`.

O repositório disponibiliza o código; o link do GitHub sozinho não executa a aplicação. Estes passos são para uso local no computador.

## Roteiro de demonstração e verificação

Em um banco novo, crie suas contas pela interface; não há credenciais de demonstração fornecidas neste README.

1. Abra a API e confira a documentação Swagger.
2. Crie uma conta de cuidador e faça login.
3. Cadastre um perfil TEA e configure o PIN, se desejado.
4. Crie uma tarefa diária ou educacional.
5. Adicione passos manualmente e acompanhe a conclusão.
6. Com a chave do Gemini configurada, gere uma sugestão de passos e teste o chat.
7. Confira o dashboard.
8. Com outro cuidador cadastrado e vinculado, demonstre a rede de apoio e os materiais.

Esse roteiro é uma orientação para validação local; sua inclusão não significa que todos os fluxos foram executados automaticamente em um ambiente novo.

## Estrutura do repositório

| Caminho | Conteúdo |
| --- | --- |
| `api_app.py` | Inicialização da API |
| `api/` | Rotas HTTP e permissões |
| `controllers/` | Coordenação das chamadas aos serviços |
| `services/` | Regras de negócio e integração com IA |
| `repositories/` | Acesso ao banco |
| `models/` | Modelos SQLAlchemy |
| `config/` | Configuração do banco e autenticação |
| `index.html` | Interface web |
| `index_teste_celular.html` | Prévia para avaliação visual em formato celular |
| `manual_doroTEA.pdf` | Manual do sistema |
| `requirements.txt` | Dependências Python |
| `tests/` e `test_*.py` | Arquivos de testes |
| `database.sql` | Script SQL antigo; observar as limitações descritas acima |

## Problemas comuns

- **Falha ao conectar ao banco:** confira se o MySQL está ativo, o banco existe e as variáveis `DB_*` estão corretas.
- **Tabela ou coluna ausente:** confira o procedimento de criação e a observação sobre bancos antigos.
- **SECRET_KEY não encontrada:** confira o arquivo `.env` na raiz e reinicie a API.
- **IA indisponível:** confira a chave, o acesso à internet e a disponibilidade/cota do serviço Gemini.
- **Interface sem comunicação com a API:** confira o terminal do Uvicorn, a porta `8000` e o endereço configurado no HTML.
- **Porta ocupada:** encerre a instância anterior ou ajuste a porta e os endereços correspondentes.

## Entrega acadêmica

- Repositório: https://github.com/vilmareloimachado-lgtm/doroTEA
- Vídeo de apresentação: link a inserir após a gravação, com acesso liberado aos professores.
- Duração máxima do vídeo: **15 minutos**.
- Conteúdo recomendado: problemática, público-alvo, solução, arquitetura, funcionalidades e demonstração prática.

Antes da entrega, confira o acesso ao vídeo e ao repositório.

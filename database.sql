-- doroTEA: estrutura para instalacao em banco novo.
-- Alinhado aos modelos em models/ (usuarios, vinculos, tarefas,
-- passos, materiais e materiais_destinatarios).
-- Nao apaga dados. IF NOT EXISTS nao migra tabelas antigas:
-- colunas/tipos de um banco existente precisam de migracao separada.
-- Defaults definidos apenas no Python continuam sendo aplicados pelo ORM.
-- Execute o arquivo completo no MySQL Workbench.

CREATE DATABASE IF NOT EXISTS tea_db
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tea_db;

CREATE TABLE IF NOT EXISTS usuarios (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    estilo_instrucao VARCHAR(20) NOT NULL,
    nivel_suporte VARCHAR(20) NOT NULL,
    data_nascimento DATETIME NULL,
    senha_login VARCHAR(255) NULL,
    email VARCHAR(150) NULL,
    pin_hash VARCHAR(255) NULL,
    tipo_usuario VARCHAR(20) NOT NULL,
    criado_em DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_usuarios_email (email)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS vinculos (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cuidador_id INT NOT NULL,
    usuario_id INT NOT NULL,
    principal BOOLEAN NOT NULL,
    pode_enviar_materiais_sem_aprovacao BOOLEAN NOT NULL DEFAULT 0,
    criado_em TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_vinculos_cuidador_usuario UNIQUE (cuidador_id, usuario_id),
    CONSTRAINT fk_vinculos_cuidador FOREIGN KEY (cuidador_id)
        REFERENCES usuarios(id) ON DELETE CASCADE,
    CONSTRAINT fk_vinculos_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tarefas (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tipo ENUM('tarefas_diarias', 'tarefas_educacionais') NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT NULL,
    prioridade ENUM('baixa', 'media', 'alta') NOT NULL,
    prazo DATE NULL,
    concluida BOOLEAN NOT NULL,
    criado_em TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tarefas_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS passos (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tarefa_id INT NOT NULL,
    texto TEXT NOT NULL,
    concluido BOOLEAN NOT NULL,
    ordem INT NOT NULL,
    CONSTRAINT fk_passos_tarefa FOREIGN KEY (tarefa_id)
        REFERENCES tarefas(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS materiais (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    link VARCHAR(2048) NOT NULL,
    imagem_url VARCHAR(2048) NULL,
    autor_id INT NULL,
    autor_nome VARCHAR(100) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_materiais_autor FOREIGN KEY (autor_id)
        REFERENCES usuarios(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS materiais_destinatarios (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    material_id INT NOT NULL,
    usuario_id INT NOT NULL,
    situacao VARCHAR(20) NOT NULL,
    aprovado_por INT NULL,
    aprovado_em DATETIME NULL,
    aberto_em DATETIME NULL,
    visto_em DATETIME NULL,
    removido_em DATETIME NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_material_destinatario UNIQUE (material_id, usuario_id),
    KEY ix_materiais_destinatarios_usuario_id (usuario_id),
    CONSTRAINT fk_destinatarios_material FOREIGN KEY (material_id)
        REFERENCES materiais(id) ON DELETE CASCADE,
    CONSTRAINT fk_destinatarios_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id) ON DELETE CASCADE,
    CONSTRAINT fk_destinatarios_aprovador FOREIGN KEY (aprovado_por)
        REFERENCES usuarios(id) ON DELETE SET NULL
) ENGINE=InnoDB;

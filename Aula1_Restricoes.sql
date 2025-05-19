-- EXEMPLOS:

CREATE TABLE EMPRESTIMO(
	nome_age_emp VARCHAR(15) NOT NULL,
	numero_emp VARCHAR(10) NOT NULL,
	valor_emp NUMERIC(10,2),
	CONSTRAINT pk_emprestimo PRIMARY KEY (numero_emp),
	CONSTRAINT ck_emprestimo_valor CHECK (valor_emp > 100)
	);


CREATE TABLE CLIENTE(
	codigo INTEGER,
	nome VARCHAR(40),
	estado CHAR(2),
	CONSTRAINT ck_cliente)estado CHECK (estado IN (‘SP’ , ‘MG’))
	);

-- EXERCÍCIOS:

CREATE TABLE EMPREGADO
	(
	idEmp INTEGER,
	pNome CHARACTER (20),
	sNome CHARACTER (20),
	dtaNasc DATE,
	dtaContr DATE,
	salario REAL,
	CONSTRAINT pk_empregado PRIMARY KEY (idEmp),
	CONSTRAINT ck_empregado_salario CHECK (salario > 400),
	CONSTRAINT ck_empregado_dtaNasc CHECK (dtaNasc > '01/01/2001'),
	CONSTRAINT ck_empregado_dataContr CHECK (((dtaContr - dtaNasc)/365) >= 18)
	);

INSERT INTO EMPREGADO VALUES (1, 'Leonardo', 'Sanga', '10/10/2001', '03/01/2025', 500);
INSERT INTO EMPREGADO VALUES (2, 'Gabriel', 'Sanga', '10/10/2005', '03/01/2025', 1000);

CREATE TABLE ALUNO
	(
	prontuario VARCHAR (15),
	nome VARCHAR (50),
	cpf VARCHAR (12),
	CONSTRAINT pk_aluno PRIMARY KEY (prontuario),
	CONSTRAINT un_aluno_cpf UNIQUE (prontuario, cpf)
	);

INSERT INTO aluno VALUES ('la', 'Rafael', '123-456');
INSERT INTO aluno VALUES ('lb', 'Rafael', '123-456');

CREATE TABLE PESSOA
	(
	idPes INTEGER,
	pNome VARCHAR (30),
	sNome VARCHAR (30),
	email VARCHAR (50),
	CONSTRAINT pk_pessoa PRIMARY KEY (idPes),
	CONSTRAINT un_pessoas_email UNIQUE (email)
	);

INSERT INTO PESSOA VALUES (1, 'Leonardo', 'Sanga', 'leo@gmail.com');
INSERT INTO PESSOA VALUES (2, 'Leonardo', 'Sanga', 'leo@gmail.com');

CREATE TABLE CORRENTISTA 
	(
	cpfCor VARCHAR (12),
	nome VARCHAR (50),
	dtaNasc DATE,
	cidade VARCHAR (40),
	uf VARCHAR (2),
	CONSTRAINT pk_correntista PRIMARY KEY (cpfCor),
	CONSTRAINT ck_correntista_dtaNasc CHECK ((CURRENT_DATE - dtaNasc)/365>=18)
	)

CREATE TABLE CONTA_CORRENTE
	(
	num_conta INTEGER,
	cpf_correntista VARCHAR (12),
	saldo REAL,
	CONSTRAINT pk_contacorrente PRIMARY KEY (num_conta),
	CONSTRAINT fk_contacorrente_cpfcor FOREIGN KEY (cpf_correntista) REFERENCES CORRENTISTA,
	CONSTRAINT ck_contacorrente_saldo CHECK (saldo >= 500)
	);

INSERT INTO CORRENTISTA VALUES ('23423423444', 'Leonardo Minguini', '12/12/2018', 'São Francisco', 'SP');
INSERT INTO CORRENTISTA VALUES ('23423423444', 'Leonardo Minguini', '12/12/2003', 'São Francisco', 'SP');
INSERT INTO CONTA_CORRENTE VALUES (1, '23423423444', 300);
INSERT INTO CONTA_CORRENTE VALUES (1, '23423423444', 600);


CREATE TABLE LIVRO
	(
	id_livro INTEGER,
	titulo VARCHAR (50),
	ISBN VARCHAR (20),
	dtaPublic DATE,
	CONSTRAINT pk_livro PRIMARY KEY (id_livro),
	CONSTRAINT un_livro_isbn UNIQUE (ISBN)
	);

INSERT INTO LIVRO VALUES (1, 'A Game of Thrones', '1234123', '01/04/2000');
INSERT INTO LIVRO VALUES (2, 'A Crash of Kings', '1234123', '01/09/2004');

CREATE TABLE CARRO
	(
	idCarro INTEGER,
	modelo VARCHAR (30),
	marca VARCHAR (30),
	ano INTEGER,
	preco REAL,
	chassi VARCHAR (20),
	renavam VARCHAR (10),
	CONSTRAINT pk_carro PRIMARY KEY (idCarro),
	CONSTRAINT un_carro_chassi UNIQUE (chassi),
	CONSTRAINT un_carro_renavam UNIQUE (renavam),
	CONSTRAINT ck_carro_preco CHECK (preco > 2000)
	);

INSERT INTO CARRO VALUES (1, 'Onix', 'Chevrolet', 2012, 1800, '13123123', '12313213');
INSERT INTO CARRO VALUES (2, 'Onix', 'Chevrolet', 2012, 3000, '13123123', '12313213');
INSERT INTO CARRO VALUES (3, 'Onix', 'Chevrolet', 2012, 3000, '41312313', '12313213');
INSERT INTO CARRO VALUES (4, 'Onix', 'Chevrolet', 2012, 3000, '13123123', '73127313');
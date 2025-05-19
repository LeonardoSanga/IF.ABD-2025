CREATE TABLE DEPARTAMENTO
	(
	idDep INTEGER,
	nomeDep VARCHAR (30),
	CONSTRAINT pk_departamento PRIMARY KEY (idDep)
	);

CREATE TABLE FUNCIONARIO 
	(
	idFunc INTEGER,
	cpf VARCHAR (13),
	nome VARCHAR (15),
	cidade VARCHAR (50),
	salario REAL,
	idDep INTEGER,
	CONSTRAINT pk_funcionario PRIMARY KEY (idFunc),
	CONSTRAINT fk_func_dep FOREIGN KEY (idDep) REFERENCES DEPARTAMENTO
	)

CREATE SEQUENCE sid_departamento;
CREATE SEQUENCE sid_funcionario;

INSERT INTO departamento
	VALUES (nextval('sid_departamento'), 'RH');

SELECT * FROM DEPARTAMENTO;
SELECT currval('sid_departamento');
SELECT nextval('sid_departamento');

INSERT INTO departamento
	VALUES (nextval('sid_departamento'), 'TI');

INSERT INTO FUNCIONARIO
	VALUES (nextval('sid_funcionario'), '123123-5', 'Leonardo Sanga', 'São Francisco', 5000, (SELECT idDep FROM DEPARTAMENTO
																									WHERE nomeDep = 'RH'));

SELECT * FROM  FUNCIONARIO;

ALTER SEQUENCE sid_departamento INCREMENT BY 2;

ALTER SEQUENCE sid_departamento MINVALUE 0 MAXVALUE 12 RESTART 0;

INSERT INTO DEPARTAMENTO 
	VALUES (nextval('sid_departamento'), 'RQ');

INSERT INTO DEPARTAMENTO 
	VALUES (nextval('sid_departamento'), 'Vendas');


SELECT * FROM DEPARTAMENTO;


-- EXERCÍCIOS SEQUENCIAS

-- 1
CREATE TABLE OBRA 
	(
	id_obra INTEGER,
	descricao VARCHAR (70),
	CONSTRAINT pk_obra PRIMARY KEY (id_obra)
	);

CREATE TABLE MAQUINA 
	(
	id_maquina INTEGER,
	marca VARCHAR (15),
	CONSTRAINT pk_maquina PRIMARY KEY (id_maquina)
	);

CREATE TABLE USA 
	(
	id_usa INTEGER,
	id_obra INTEGER,
	id_maquina INTEGER,
	data_do_uso DATE,
	CONSTRAINT pk_usa PRIMARY KEY (id_usa),
	CONSTRAINT fk_usa_obra FOREIGN KEY (id_obra) REFERENCES OBRA,
	CONSTRAINT fk_usa_maquina FOREIGN KEY (id_maquina) REFERENCES MAQUINA
	);

-- 2 
CREATE SEQUENCE sid_obra;
CREATE SEQUENCE sid_maquina START WITH 100;
CREATE SEQUENCE sid_usa START WITH 1000;

-- 3
INSERT INTO OBRA
	VALUES (nextval('sid_obra'), 'Reforma da prefeitura');
INSERT INTO OBRA
	VALUES (nextval('sid_obra'), 'Reforma da centro urbano');

INSERT INTO MAQUINA 
	VALUES (nextval('sid_maquina'), 'Mercedes');
INSERT INTO MAQUINA 
	VALUES (nextval('sid_maquina'), 'Volkswagen');

-- 4
INSERT INTO USA
	VALUES (nextval('sid_usa'), 1, 100, '01/12/2024');
INSERT INTO USA
	VALUES (nextval('sid_usa'), 1, 101, '12/12/2024');

INSERT INTO USA
	VALUES (nextval('sid_usa'), 2 , 100, '12/01/2021');
INSERT INTO USA
	VALUES (nextval('sid_usa'), 2 , 101, '01/02/2021');

SELECT * FROM OBRA;
SELECT * FROM MAQUINA;
SELECT * FROM USA;

-- 5
SELECT o.descricao, m.marca FROM OBRA o
	INNER JOIN USA u
	ON o.id_obra = u.id_obra
	INNER JOIN MAQUINA m
	ON u.id_maquina = m.id_maquina;

-- 6 
ALTER SEQUENCE sid_obra INCREMENT BY 2;

-- 7
INSERT INTO OBRA
	VALUES (nextval('sid_obra'), 'Construção do estádio da cidade');
INSERT INTO OBRA
	VALUES (nextval('sid_obra'), 'Construção do parque municipal');

-- 8
ALTER SEQUENCE sid_maquina INCREMENT BY 3;

-- 9
INSERT INTO MAQUINA 
	VALUES (nextval('sid_maquina'), 'BMW');
INSERT INTO MAQUINA 
	VALUES (nextval('sid_maquina'), 'Chevrolet');


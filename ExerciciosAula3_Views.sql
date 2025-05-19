-- Exercícios Aula 3 - VIEWs

-- 1
CREATE VIEW v_generoFilmes
	AS SELECT nome, genero FROM FILME;

SELECT * FROM v_generoFilmes;

-- 2
CREATE VIEW v_quantidadeGeneros
	AS SELECT genero, count(nome) FROM FILME
		GROUP BY genero;

SELECT * FROM v_quantidadeGeneros;

-- 3
CREATE VIEW v_atoresComedia
	AS SELECT f.nome AS "Filme", a.nome AS "Ator", f.genero FROM FILME f  
		INNER JOIN atorEstrelaFilme aef
		ON f.codFilme = aef.codFilme
		INNER JOIN ATOR a
		ON aef.idAtor = a.idAtor
		WHERE f.genero = 'Comédia';

SELECT * FROM v_atoresComedia;

-- 4
CREATE VIEW v_clientesDoAno
	AS SELECT nome, dtaRet FROM CLIENTE c
		INNER JOIN clienteAlugaExemplarFilme caef
		ON c.codCliente = caef.codCliente
		WHERE dtaRet BETWEEN '01/01/2011' AND '31/12/2011';

SELECT * FROM v_clientesDoAno;

-- 5
CREATE TABLE CARRO
	(
	chassi VARCHAR (12),
	modelo VARCHAR (30),
	marca VARCHAR (20),
	ano INTEGER,
	preco REAL,
	CONSTRAINT pk_carro PRIMARY KEY (chassi)
	);

-- 6
INSERT INTO CARRO VALUES ('ld12di23', 'Onix Ret', 'Chevrolet', 2012, 40000.00),
							('gd12di21', 'Corsa Classic', 'Chevrolet', 2003, 20000.00),
							('td12di22', 'Onix Sedan', 'Chevrolet', 2022, 100000.00),
							('yd12di27', 'Civic', 'Honda', 2012, 70000.00);

-- 7
CREATE MATERIALIZED VIEW mv_especCarros
	AS SELECT modelo, ano, preco FROM CARRO;

-- 8
SELECT * FROM mv_especCarros;

-- 9
INSERT INTO CARRO VALUES ('ad12di29', 'Corolla', 'Toyota', 2016, 120000.00),
							('bd12di28', 'Fiesta', 'Ford', 2014, 30000.00);

SELECT * FROM mv_especCarros;

-- 10
REFRESH MATERIALIZED VIEW mv_especCarros;

SELECT * FROM mv_especCarros;
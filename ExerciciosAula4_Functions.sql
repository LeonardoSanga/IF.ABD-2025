-- EXERCÍCIOS AULA 04 - LEONARDO MINGUINI SANGA

-- 1

CREATE OR REPLACE FUNCTION f_maiorSalario() RETURNS VARCHAR
AS
$$
DECLARE
	nomeEmp empregado.pnome%type;
	salarioEmp empregado.salario%type;
BEGIN
	SELECT pnome, salario INTO nomeEmp, salarioEmp FROM EMPREGADO
		WHERE salario = (
			SELECT max(salario) FROM EMPREGADO);

	RETURN 'O funcionário ' || nomeEmp || ' tem o maior salário: ' || salarioEmp;
END;
$$
LANGUAGE plpgsql;

SELECT f_maiorSalario();

-- 2

CREATE OR REPLACE FUNCTION  f_filmesAtor(id INTEGER) RETURNS VARCHAR
AS 
$$
DECLARE 
	nomeAtor ator.nome%type;
	quantidadeFilmes REAL;
BEGIN
	SELECT a.nome, count(*) INTO nomeAtor, quantidadeFilmes FROM ATOR a
		INNER JOIN atorEstrelaFilme aef
		ON a.idAtor = aef.idAtor
		WHERE a.idAtor = id
		GROUP BY a.nome;

	RETURN 'O ator ' || nomeAtor || ' estrelou ' || quantidadeFilmes || ' filmes';

END;
$$
LANGUAGE plpgsql;

SELECT f_filmesAtor(11);

-- 3

CREATE OR REPLACE FUNCTION f_insereEmpr2(id integer, pNomeEmp VARCHAR, sNomeEmp VARCHAR, idadeEmp INTEGER, salarioEmp REAL,
	cargoEmp VARCHAR) RETURNS VARCHAR
AS
$$
DECLARE
	idEmpr empregado.idEmp%type;
	pnomeEmpr empregado.pnome%type;
	snomeEmpr empregado.snome%type;
	idadeEmpr empregado.idade%type;
	salarioEmpr empregado.salario%type;
	cargoEmpr empregado.cargo%type;
	checkId INTEGER;
BEGIN
	SELECT idEmp INTO checkId FROM empregado
		WHERE idEmp = id;

	IF(checkId IS NOT NULL) THEN RAISE 'Chave duplicada %', id USING ERRCODE = 'unique_violation';
		END IF;
	
	INSERT INTO EMPREGADO(idEmp, pnome, snome, idade, salario, cargo)
		VALUES (id, pNomeEmp, sNomeEmp, idadeEmp, salarioEmp, cargoEmp)
			RETURNING idEmp, pnome, snome, idade, salario, cargo INTO idEmpr, pnomeEmpr, snomeEmpr, idadeEmpr, salarioEmpr, cargoEmpr;

	RETURN 'ID: ' || idEmpr || ' nome: ' || pnomeEmpr  || ' sobrenome: ' || snomeEmpr || ' idade: ' || idadeEmpr || ' salário: ' || salarioEmpr || ' cargo: ' || cargoEmpr;  
END;
$$
LANGUAGE plpgsql;	

SELECT f_insereEmpr2(24, 'Otair', 'sanga', 56, 7900, 'Gerente');

-- 4

CREATE OR REPLACE FUNCTION f_atualizaSalario(id INTEGER, novoSalario REAL) RETURNS VARCHAR
AS
$$
DECLARE
	antSalario empregado.salario%type;
	nomeEmp empregado.pnome%type;
BEGIN
	SELECT pnome, salario INTO nomeEmp, antSalario FROM EMPREGADO
		WHERE idEmp = id;

	INSERT INTO histSalario(idHisSal, idEmp, salario) VALUES (nextval('sid_histSal'), id, antSalario);

	UPDATE EMPREGADO SET salario = novoSalario
		WHERE idEmp = id;

	if(novoSalario > antSalario) THEN
		RETURN 'Funcionário ' || nomeEmp || ' tinha salário ' || antSalario || ' que foi AUMENTADO para ' || novoSalario;
	ELSE 
		RETURN 'Funcionário ' || nomeEmp || ' tinha salário ' || antSalario || ' que foi REDUZIDO para ' || novoSalario;
	END IF;
	
END;
$$
LANGUAGE plpgsql;

SELECT f_atualizaSalario(22, 3100);

-- 5

CREATE OR REPLACE FUNCTION f_atualizaSalario(id INTEGER, novoSalario REAL) RETURNS VARCHAR
AS
$$
DECLARE
	idEmpr empregado.idEmp%type;
	antSalario empregado.salario%type;
	nomeEmp empregado.pnome%type;
BEGIN
	SELECT idEmp, pnome, salario INTO idEmpr, nomeEmp, antSalario FROM EMPREGADO
		WHERE idEmp = id;

	if(idEmpr IS NULL) THEN RAISE 'ID inválido %', id USING ERRCODE = 'ERR01';
		END IF;
		

	INSERT INTO histSalario(idHisSal, idEmp, salario) VALUES (nextval('sid_histSal'), id, antSalario);

	UPDATE EMPREGADO SET salario = novoSalario
		WHERE idEmp = id;

	if(novoSalario > antSalario) THEN
		RETURN 'Funcionário ' || nomeEmp || ' tinha salário ' || antSalario || ' que foi AUMENTADO para ' || novoSalario;
	ELSE 
		RETURN 'Funcionário ' || nomeEmp || ' tinha salário ' || antSalario || ' que foi REDUZIDO para ' || novoSalario;
	END IF;
	
END;
$$
LANGUAGE plpgsql;

SELECT f_atualizaSalario(22, 3300);

-- 5

-- Função 1

CREATE OR REPLACE FUNCTION f_insereFilme(codigo INTEGER, nomeFil VARCHAR, generoFil VARCHAR, dtaLancFil DATE) RETURNS INTEGER
AS
$$
DECLARE
	result filme.codFilme%type;
	checkCod filme.codFilme%type;
BEGIN
	SELECT codFilme INTO checkCod FROM FILME
		WHERE codFilme = codigo;

	IF (checkCod IS NOT NULL) THEN RAISE 'Chave duplicada %', codigo USING ERRCODE = 'unique_violation';
	END IF;

	INSERT INTO FILME (codFilme, nome, genero, dtaLanc) VALUES (codigo, nomeFil, generoFil, dtaLancFil)
			RETURNING codFilme INTO result;

	RETURN result;

END;
$$
LANGUAGE plpgsql;

SELECT f_insereFilme(29, 'Enders Game', 'Ficção Científica', '19/11/2012');

SELECT * FROM FILME WHERE codFilme = 29;

-- Função 2

CREATE OR REPLACE FUNCTION f_insereAtor(id INTEGER, nomeAt VARCHAR, dtaNascAt DATE) RETURNS INTEGER
AS
$$
DECLARE
	result ator.idAtor%type;
	checkId ator.idAtor%type; 
BEGIN
	SELECT idAtor INTO checkId FROM Ator
		WHERE idAtor = id;

	IF (checkId IS NOT NULL) THEN RAISE 'Chave duplicada %', id USING ERRCODE = 'unique_violation';
	END IF;

	INSERT INTO Ator (idAtor, nome, dtaNasc) VALUES (id, nomeAt, dtaNascAt)
			RETURNING idAtor INTO result;

	RETURN result;

END;
$$
LANGUAGE plpgsql;

SELECT f_insereAtor(47, 'Tom Holland', '19/02/1996');

SELECT * FROM ATOR WHERE idAtor = 47;
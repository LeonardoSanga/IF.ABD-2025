-- Exercícios Aula 5 LOOPs - Leonardo Minguini Sanga

-- 1
CREATE OR REPLACE FUNCTION f_verificaPagamentoIR()
RETURNS void
AS
$$
DECLARE
	regEmp empregado%rowtype;
BEGIN
	for regEmp in SELECT * FROM empregado WHERE salario > 2259.2
	LOOP
		raise notice '% paga imposto de renda', regEmp.pnome;
	END LOOP;
END;
$$
LANGUAGE plpgsql;

SELECT f_verificaPagamentoIR();

-- 2
CREATE OR REPLACE FUNCTION f_filmesAtor(id integer)
RETURNS SETOF RECORD
AS
$$
DECLARE
	regAtorFilme record;
BEGIN
	for regAtorFilme in SELECT a.nome, f.nome FROM ATOR a
							INNER JOIN atorEstrelaFilme aef
							ON a.idAtor = aef.idAtor
							INNER JOIN FILME f
							ON aef.codFilme = f.codFilme
							WHERE a.idAtor = id
	LOOP
		return next regAtorFilme;
	END LOOP;
							
END;
$$
LANGUAGE plpgsql;

SELECT * FROM f_filmesAtor(6) AS ("nome ator" VARCHAR, "Filme" VARCHAR);

-- 3
CREATE OR REPLACE FUNCTION f_filmesAno(ano numeric)
RETURNS SETOF RECORD
AS
$$
DECLARE
	regAnoFilme record;
BEGIN
	for regAnoFilme in SELECT nome, extract(year from dtaLanc) FROM FILME
							WHERE extract (year from dtaLanc) = ano
	LOOP
		return next regAnoFilme;
	END LOOP;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM f_filmesAno(2002) AS ("Nome Filme" VARCHAR, "Ano" NUMERIC);
create table curso (idCurso integer PRIMARY KEY, nomeCurso character varying (30) NOT NULL, nroSemestres integer NOt NULL, dtaFundacao date);
-- drop table curso
--SELECT * FROM curso;

create table aluno(prontuario character varying (20) Primary key, pnome character varying (15) NOT NULL, snome character varying(30) not null, dtaNasc date, sexo char (1));
--DROP TABLE aluno
-- Adicionando chave estrangeira
ALTER TABLE aluno ADD column idCurso integer references curso (idCurso)ON DELETE CASCADE ON UPDATE CASCADE;

--SELECT * FROM aluno;


-- populando a tabela curso

INSERT INTO curso values (1, 'Ciência da Computação', 8, '01/03/1986');
INSERT INTO curso values (2, 'Direito', 8, '14/12/1975');
INSERT INTO curso values (3, 'Medicina', 12, '05/07/2000');
INSERT INTO curso values (4, 'Engenharia Elétrica', 10, '10/12/1996');
INSERT INTO curso values (5, 'Biologia', 8, '06/06/1993');
INSERT INTO curso values (6, 'Matemática', 8, '01/07/1968');

-- populando a tabela aluno

INSERT INTO aluno values ('11aa', 'Paulo', 'Henrique', '01/07/1986','M',1);
INSERT INTO aluno values ('11bb', 'Ana', 'Paula Siqueira', '08/07/1990','F',5);
INSERT INTO aluno values ('11cc', 'Júlio', 'Cesar', '08/05/1980','M',3);
INSERT INTO aluno values ('11dd', 'Carlos', 'Augusto', '10/11/1983','M',2);
INSERT INTO aluno values ('11ee', 'Gabriele', 'Antunes', '08/05/1990','F',3);
INSERT INTO aluno values ('11ff', 'Antônio', 'Fagundes', '15/06/1955','M',4);
INSERT INTO aluno values ('11gg', 'Ana', 'Paula Arósio', '08/12/1975','F',5);
INSERT INTO aluno values ('11hh', 'Mara', 'Maravilha', '07/07/1970','F',1);
INSERT INTO aluno values ('11ii', 'Roberto', 'Carlos', '01/07/1956','M',3);
INSERT INTO aluno values ('11jj', 'Carmen', 'Miranda', '03/02/1950','F',2);
INSERT INTO aluno values ('11kk', 'Rubens', 'Cardoso', '09/11/1974','M',4);
INSERT INTO aluno values ('11ll', 'Joana', 'de Assis', '07/04/1982','F',1);
INSERT INTO aluno values ('11mm', 'Paola', 'de Oliveira', '06/03/1985','F',6);
INSERT INTO aluno values ('11nn', 'Joaquim', 'Silva', '25/10/1968','M',6);
INSERT INTO aluno values ('11oo', 'Padre', 'Irlandês', '30/10/1960','M',5);
INSERT INTO aluno values ('11pp', 'Angelina', 'Jolie', '20/03/1978','F',4);
INSERT INTO aluno values ('11qq', 'Derci', 'Golçalves', '02/04/1920','F',3);
INSERT INTO aluno values ('11rr', 'Túlio', 'Maravilha', '30/08/1972','M',3);
INSERT INTO aluno values ('11ss', 'Carla', 'Ribeiro', '08/03/1988','F',2);
INSERT INTO aluno values ('11tt', 'Olivia', 'Palito', '18/09/1977','F',1);
INSERT INTO aluno values ('11uu', 'Marinheiro', 'Popeye', '21/02/1968','M',2);
INSERT INTO aluno values ('11vv', 'Alberto', 'Roberto', '15/03/1955','M',4);
INSERT INTO aluno values ('11ww', 'Julia', 'Roberts', '07/05/1972','F',5);
INSERT INTO aluno values ('11xx', 'Thais', 'Ferçosa', '16/04/1983','F',6);
INSERT INTO aluno values ('11yy', 'Barack', 'Obama', '18/09/1956','M',1);
INSERT INTO aluno values ('11zz', 'Osama', 'Bin Laden', '13/12/1960','M',1);
INSERT INTO aluno values ('22aa', 'Paula', 'Fernandes', '03/03/1983','F',2);
INSERT INTO aluno values ('22bb', 'Lara', 'Rodrigues', '10/10/1991','F',2);
INSERT INTO aluno values ('22cc', 'Mariana', 'Ximenes', '07/08/1982','F',3);
INSERT INTO aluno values ('22dd', 'Marcos', 'Paulo', '18/06/1975','M',4);
INSERT INTO aluno values ('22ee', 'Beatriz', 'Seagal', '15/12/1965','F',4);
INSERT INTO aluno values ('22ff', 'Luciano', 'Huck', '04/06/1978','M',5);
INSERT INTO aluno values ('22gg', 'Marcelo', 'Taz', '06/04/1972','M',6);
INSERT INTO aluno values ('22hh', 'Sabrina', 'Sato', '08/11/1982','F',6);
INSERT INTO aluno values ('22ii', 'Vovó', 'Mafalda', '04/11/1950','F',5);
INSERT INTO aluno values ('22jj', 'Joana', 'Darc', '07/07/1955','F',3);
INSERT INTO aluno values ('22ll', 'Henrique', 'VIII', '15/03/1942','M',1);
INSERT INTO aluno values ('22kk', 'Charles', 'Chapilin', '03/11/1926','M',2);
INSERT INTO aluno values ('22mm', 'Frodo', 'Baggins', '08/12/1975','M',3);
INSERT INTO aluno values ('22nn', 'Lady', 'Gaga', '23/07/1985','F',4);
INSERT INTO aluno values ('22oo', 'Katherina', 'Zeta Jones', '07/12/1977','F',5);
INSERT INTO aluno values ('22pp', 'Katherina', 'Zeta Jones', '07/12/1977','F',4);


-- tabela professor
CREATE table professor(prontuario integer primary key, pnome character varying(20) NOT NULL, snome character varying(30) NOT NULL, dtaNasc date);
--DROP TABLE professor


-- populando tabela professor
INSERT INTO professor values (1,'Rafael','Miani','11/01/1984');
INSERT INTO professor values (2,'Pedro','Antonio','15/07/1980');
INSERT INTO professor values (3,'Natal','Henrique','22/12/1981');
INSERT INTO professor values (4,'Carla','Joana','30/10/1972');
INSERT INTO professor values (5,'Raquel','Silva','03/04/1980');
INSERT INTO professor values (6,'Ana','Carla','07/08/1978');
INSERT INTO professor values (7,'Roberto','Silva','13/07/1960');
INSERT INTO professor values (8,'Mariana','Cunha','18/05/1982');
INSERT INTO professor values (9,'Sebastião','Roberto','15/03/1980');
INSERT INTO professor values (10,'Mauro','Augusto','21/03/1978');


-- tabela professorLecionaAluno
create table professorLecionaAluno (prontuarioAluno character varying(20) NOT NULL references aluno (prontuario) ON DELETE CASCADE ON UPDATE CASCADE,
		prontuarioProfessor integer NOT NULL references professor (prontuario) ON DELETE CASCADE ON UPDATE CASCADE,
		 ano integer not null, semestre integer not null, nota real, PRIMARY KEY (prontuarioAluno,prontuarioProfessor,ano,semestre));
		 
-- drop table professorLecionaAluno
--ALTER TABLE professorLecionaAluno ADD column nota real;

-- populando tabela professorLecionaAluno
INSERT INTO professorLecionaAluno VALUES ('11aa',1,2009,2,8.5);
INSERT INTO professorLecionaAluno VALUES ('11aa',3,2011,1,7);
INSERT INTO professorLecionaAluno VALUES ('11bb',4,2008,2,6.5);
INSERT INTO professorLecionaAluno VALUES ('11cc',1,2010,1,9);
INSERT INTO professorLecionaAluno VALUES ('11dd',5,2009,1,4.5);
INSERT INTO professorLecionaAluno VALUES ('11ee',4,2008,2,7.5);
INSERT INTO professorLecionaAluno VALUES ('11ff',3,2011,2,9.5);
INSERT INTO professorLecionaAluno VALUES ('11bb',6,2010,1,5.5);
INSERT INTO professorLecionaAluno VALUES ('11cc',9,2009,1,6);
INSERT INTO professorLecionaAluno VALUES ('11gg',7,2009,2,8);
INSERT INTO professorLecionaAluno VALUES ('11bb',5,2010,1,7.5);

-- VIEWS 
CREATE OR REPLACE VIEW v_sexoAlunoF
	AS SELECT * FROM ALUNO
		WHERE sexo = 'F' AND dtanasc > '01/01/1990';

-- chamar a view
SELECT * FROM v_sexoAlunoF;

SELECT * FROM professorLecionaAluno
	WHERE nota < 7;

SELECT pnome, count(*) FROM professorLecionaAluno
	INNER JOIN aluno
	ON prontuarioAluno = prontuario
	WHERE nota < 7
	GROUP BY pnome;

CREATE OR REPLACE VIEW v_qtdNotasVermelhas
	AS SELECT pnome, count(*) FROM professorLecionaAluno
	INNER JOIN aluno
	ON prontuarioAluno = prontuario
	WHERE nota < 7
	GROUP BY pnome, prontuario;

SELECT * FROM v_qtdNotasVermelhas ORDER BY count DESC;

INSERT INTO ALUNO VALUES ('33aa', 'Ana', 'Júlia', '01/01/2000', 'F', 3);

INSERT INTO professorLecionaAluno VALUES ('33aa', 4, 2023, 1, 5);

SELECT nomeCurso, count(*) FROM CURSO c
	INNER JOIN ALUNO a
	ON c.idCurso = a.idCurso
	GROUP BY nomeCurso
	ORDER BY count(*) DESC;

CREATE VIEW v_qtdAlunoCurso 
	AS SELECT nomeCurso, count(*) FROM CURSO c
	INNER JOIN ALUNO a
	ON c.idCurso = a.idCurso
	GROUP BY nomeCurso
	ORDER BY count(*) DESC;

SELECT * FROM v_qtdAlunoCurso;

CREATE OR REPLACE VIEW alunos_F
	AS SELECT * FROM aluno
	WHERE sexo = 'F' AND dtanasc > '01/01/1980';

SELECT * FROM alunos_F;
SELECT pnome, dtaNasc, sexo FROM alunos_F;
INSERT INTO aluno VALUES ('33ff', 'Maria', 'Clara', '01/01/2000', 'F', 4);

-- Materialized view
CREATE TABLE PESSOA
	(
	cpf INTEGER,
	nome VARCHAR (50),
	idade INTEGER,
	cidade VARCHAR (50),
	CONSTRAINT pk_pessoa PRIMARY KEY (cpf)
	);

INSERT INTO pessoa VALUES (1, 'Rafael', 35, 'Votuporanga'),
							(2, 'Leonardo', 21 , 'São Francisco'),
							(3, 'Gabriel', 24, 'Fernandópolis'),
							(4, 'Ariane', 20 , 'Araraquara');

CREATE MATERIALIZED VIEW mv_dadosPessoa
	AS SELECT * FROM pessoa;

SELECT * FROM mv_dadosPessoa;

INSERT INTO pessoa VALUES (5, 'Silveria', 56, 'Jales');

REFRESH MATERIALIZED VIEW mv_dadosPessoa;
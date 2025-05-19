-- TRIGGERs

-- exemplo 1

CREATE TABLE CONTA
	(
	idConta INTEGER,
	nroConta VARCHAR (10) NOT NULL,
	saldo NUMERIC (10, 2),
	CONSTRAINT pk_conta PRIMARY KEY (idConta)
	);


-- Função trigger

CREATE OR REPLACE FUNCTION f_verificaHorario ()
RETURNS TRIGGER
AS
$$
BEGIN
	if extract (hour FROM current_time) NOT BETWEEN 7 AND 11 then
		raise 'Operação fora do horário bancário ' using ERRCODE = 'EHO01';
	end if;
	return new;
END;
$$
LANGUAGE plpgsql;


select current_time;
select current_date;
select current_timestamp;

-- trigger

CREATE TRIGGER trig_verificaHorario BEFORE INSERT OR UPDATE ON CONTA
FOR EACH ROW
	execute procedure f_verificaHorario();

INSERT INTO CONTA VALUES (1, 'cta-001', 1000);

SELECT * FROM CONTA;

-- exemplo 2

CREATE TABLE ex_empregados
	(
	idEmp INTEGER,
	pnome VARCHAR (50),
	snome VARCHAR (50),
	cargo VARCHAR (50),
	dataDemissao DATE
	);

-- Criar a função trigger que vai inserir o empregado excluido na tabela ex_empregados
CREATE OR REPLACE FUNCTION f_exEmpregados ()
RETURNS TRIGGER
AS
$$
BEGIN
	INSERT INTO ex_empregados VALUES (OLD.idEmp, OLD.pnome, OLD.snome, OLD.cargo, current_date);
	RETURN OLD;
END;
$$
LANGUAGE plpgsql;

-- criar a trigger que irá acionar a função f_exEmpregados()

CREATE TRIGGER trig_exEmpregados BEFORE DELETE ON EMPREGADO
FOR EACH ROW
	execute procedure f_exEmpregados();

DELETE FROM empregado WHERE idEmp = 5;
SELECT * FROM empregado ORDER BY cargo;
SELECT * FROM EMPREGADO;
SELECT * FROM ex_empregados;

DELETE FROM EMPREGADO WHERE cargo = 'Técnico em Segurança';

SELECT * FROM INFORMATION_SCHEMA.triggers;

-- exemplo 3

CREATE TABLE log_op_emp
	(
	idLog SERIAL,
	idEmp INTEGER,
	op VARCHAR (200),
	dtaHora TIMESTAMP,
	CONSTRAINT pk_logOpEmp PRIMARY KEY (idLog)
	);


-- Função trigger

CREATE OR REPLACE FUNCTION f_operacoesEmp ()
RETURNS TRIGGER
AS
$$
BEGIN
	if (TG_OP = 'INSERT') then 
		INSERT INTO log_op_emp (idEmp, op, dtaHora) VALUES (NEW.idEmp, 'Foi INSERIDO o empregado ' || NEW.pnome, 
								current_timestamp);
		return new;
	end if;

	if (TG_OP = 'UPDATE') then 
		INSERT INTO log_op_emp (idEmp, op, dtaHora) VALUES (OLD.idEmp, 'O empregado teve seus dados ATUALIZADOS de ' || OLD.* || 
								' para ' || NEW.*, current_timestamp);
		return new;
	end if;

	if (TG_OP = 'DELETE') then 
		INSERT INTO log_op_emp (idEmp, op, dtaHora) VALUES (OLD.idEmp, 'O empregado ' || OLD.pnome || ' foi EXCLUÍDO',
								current_timestamp);
		return old;
	end if;

	return null;
END;
$$
LANGUAGE plpgsql;

-- TRIGGER

CREATE TRIGGER trig_operacoesEmp BEFORE INSERT OR UPDATE OR DELETE ON EMPREGADO
FOR EACH ROW
	execute procedure f_operacoesEmp();

-- testes

INSERT INTO EMPREGADO VALUES (22, 'Fabiana', 'Maria', 37, 5000, 'Analista de Sistemas');
UPDATE EMPREGADO SET salario = 5000
	WHERE idEmp = 22;
UPDATE EMPREGADO SET idade = 25, salario = 3000
	WHERE idEmp = 1;
DELETE FROM EMPREGADO WHERE cargo = 'Vendedor';

SELECT * FROM EMPREGADO;
SELECT * FROM log_op_emp;


CREATE USER leominguini WITH PASSWORD 'postdba';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO leominguini;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO leominguini;

CREATE TABLE log_op_emp_user
	(
	idLog SERIAL,
	idEmp INTEGER,
	op VARCHAR (200),
	dtaHora TIMESTAMP,
	usuario VARCHAR (100),
	CONSTRAINT pk_logOpEmpUser PRIMARY KEY (idLog)
	);

CREATE OR REPLACE FUNCTION f_operacoesEmpUser ()
RETURNS TRIGGER
AS
$$
BEGIN
	if (TG_OP = 'INSERT') then 
		INSERT INTO log_op_emp_user (idEmp, op, dtaHora, usuario) VALUES (NEW.idEmp, 'Foi INSERIDO o empregado ' || NEW.pnome, 
								current_timestamp, current_user);
		return new;
	end if;

	if (TG_OP = 'UPDATE') then 
		INSERT INTO log_op_emp_user (idEmp, op, dtaHora, usuario) VALUES (OLD.idEmp, 'O empregado teve seus dados ATUALIZADOS de ' || OLD.* || 
								' para ' || NEW.*, current_timestamp, current_user);
		return new;
	end if;

	if (TG_OP = 'DELETE') then 
		INSERT INTO log_op_emp_user (idEmp, op, dtaHora, usuario) VALUES (OLD.idEmp, 'O empregado ' || OLD.pnome || ' foi EXCLUÍDO',
								current_timestamp, current_user);
		return old;
	end if;

	return null;
END;
$$
LANGUAGE plpgsql;

-- TRIGGER

CREATE TRIGGER trig_operacoesEmpUser BEFORE INSERT OR UPDATE OR DELETE ON EMPREGADO
FOR EACH ROW
	execute procedure f_operacoesEmpUser();

INSERT INTO EMPREGADO VALUES (23, 'Danilo', 'Roberto', 45, 8000, 'Gerente');

SELECT * FROM EMPREGADO;
SELECT * FROM log_op_emp_user;

-- Exercícios

CREATE TABLE aluno 
		(prontuario VARCHAR (20),
		 nome VARCHAR (50),
		 ira real default 0,
		 constraint pk_aluno PRIMARY KEY (prontuario)
		);
		
INSERT INTO ALUNO VALUES ('VP10', 'Carlos Augusto'),
						 ('VP11', 'Bruna dos Santos'),
						 ('VP12', 'Fernando Carlos'),
						 ('VP13', 'Tatiane Mantovani'),
						 ('VP14', 'Silvia Camargo'),
						 ('VP15', 'Rubens Cardoso'),
						 ('VP16', 'Danilo Sousa'),
						 ('VP17', 'Ana Mara'),
						 ('VP18', 'José Augusto'),
						 ('VP19', 'Maria de Fátima');
						 
CREATE table disciplina (codDisc VARCHAR (5), nomeDisc VARCHAR (100),
						CONSTRAINT pk_disciplina PRIMARY KEY (codDisc));
						
INSERT INTO disciplina values ('BD1', 'Banco de dados I'),
						      ('BD2', 'Banco de dados II'),
							  ('PESA', 'Programação Estruturada'),
							  ('ED1', 'Estrutura de dados I'),
							  ('LP1', 'Linguagem de Programação I'),
							  ('MAT1', 'Matemática I');
							  
CREATE TABLE notasAluDisc 
		(prontuario VARCHAR (20),
		 codDisc VARCHAR (5),
		 nota REAL,
		 CONSTRAINT pk_notasAluDisc PRIMARY KEY (prontuario, codDisc),
		 CONSTRAINT fk_notasDisc FOREIGN KEY (codDisc) REFERENCES disciplina,
		 CONSTRAINT fk_notasAlu FOREIGN KEY (prontuario) REFERENCES aluno
		);
		


-- 1
CREATE TABLE log_salariosFunc
	(
	idEmp INTEGER,
	salarioAntigo REAL,
	salarioNovo REAL,
	dataAlteracao date,
	CONSTRAINT fk_logSalariosFunc FOREIGN KEY (idEmp) REFERENCES EMPREGADO (idEmp)
	);

CREATE OR REPLACE FUNCTION f_insereLogSalarios()
RETURNS TRIGGER
AS
$$
BEGIN
	INSERT INTO log_salariosFunc VALUES (OLD.idEmp, OLD.salario, NEW.salario, current_date);

	return new;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trig_salariosAlterados BEFORE UPDATE ON EMPREGADO
FOR EACH ROW
WHEN (OLD.salario IS DISTINCT FROM NEW.salario)
	execute procedure f_insereLogSalarios();

UPDATE EMPREGADO SET salario = 1500 WHERE idEmp = 3;
UPDATE EMPREGADO SET salario = 8200 WHERE idEmp = 6;
UPDATE EMPREGADO SET salario = 1400 WHERE idEmp = 13;
UPDATE EMPREGADO SET idade = 33 WHERE idEmp = 2;

SELECT * FROM EMPREGADO;
SELECT * FROM log_salariosFunc;

-- 2
CREATE OR REPLACE FUNCTION f_insereItemPedido()
RETURNS TRIGGER
AS
$$
DECLARE 
	qtdEstoque NUMERIC;
BEGIN
	SELECT qtde - qtde_minima INTO qtdEstoque FROM produto WHERE codigo_produto = NEW.codigo_produto;

	if(NEW.quantidade > qtdEstoque) then
		raise 'Quantidade do produto em estoque é insuficiente para o pedido';
		RETURN NULL;
	end if;

	UPDATE PRODUTO SET qtde = qtde - NEW.quantidade WHERE codigo_produto = NEW.codigo_produto;

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trig_insereItemPedido BEFORE INSERT ON item_pedido
FOR EACH ROW
	execute procedure f_insereItemPedido();

INSERT INTO ITEM_PEDIDO VALUES (143, 25, 4);
INSERT INTO ITEM_PEDIDO VALUES (104, 22, 5);
INSERT INTO ITEM_PEDIDO VALUES (104, 25, 2);

SELECT * FROM PRODUTO;
SELECT * FROM item_pedido;
SELECT * FROM PEDIDO;


-- SCRIPTs utilizados: 

CREATE TABLE aluno 
		(prontuario VARCHAR (20),
		 nome VARCHAR (50),
		 ira real default 0,
		 constraint pk_aluno PRIMARY KEY (prontuario)
		);
		
INSERT INTO ALUNO VALUES ('VP10', 'Carlos Augusto'),
						 ('VP11', 'Bruna dos Santos'),
						 ('VP12', 'Fernando Carlos'),
						 ('VP13', 'Tatiane Mantovani'),
						 ('VP14', 'Silvia Camargo'),
						 ('VP15', 'Rubens Cardoso'),
						 ('VP16', 'Danilo Sousa'),
						 ('VP17', 'Ana Mara'),
						 ('VP18', 'José Augusto'),
						 ('VP19', 'Maria de Fátima');
						 
CREATE table disciplina (codDisc VARCHAR (5), nomeDisc VARCHAR (100),
						CONSTRAINT pk_disciplina PRIMARY KEY (codDisc));
						
INSERT INTO disciplina values ('BD1', 'Banco de dados I'),
						      ('BD2', 'Banco de dados II'),
							  ('PESA', 'Programação Estruturada'),
							  ('ED1', 'Estrutura de dados I'),
							  ('LP1', 'Linguagem de Programação I'),
							  ('MAT1', 'Matemática I');
							  
CREATE TABLE notasAluDisc 
		(prontuario VARCHAR (20),
		 codDisc VARCHAR (5),
		 nota REAL,
		 CONSTRAINT pk_notasAluDisc PRIMARY KEY (prontuario, codDisc),
		 CONSTRAINT fk_notasDisc FOREIGN KEY (codDisc) REFERENCES disciplina,
		 CONSTRAINT fk_notasAlu FOREIGN KEY (prontuario) REFERENCES aluno
		);
        

CREATE TABLE EMPREGADO(idEmp integer PRIMARY KEY, pNome character varying (20) NOT NULL, sNome character varying(20) NOT NULL, idade integer, salario real NOT NULL, cargo character varying(30) NOT NULL);

--drop table empregado

INSERT INTO empregado VALUES (1,'Carlos','Alberto',24,2500,'Técnico em Segurança');
INSERT INTO empregado VALUES (2,'Pedro','Augusto',32,3500,'Analista de Sistemas');
INSERT INTO empregado VALUES (3,'Mara','Antonia',27,1200,'Secretária');
INSERT INTO empregado VALUES (4,'Derci','Gonçalves',56,6500,'Gerente');
INSERT INTO empregado VALUES (5,'Pedro','Bueno',28,1500,'Estagiário');
INSERT INTO empregado VALUES (6,'Edson','Arantes',60,7500,'Gerente');
INSERT INTO empregado VALUES (7,'Odete','Roitman',54,2000,'Técnico em Segurança');
INSERT INTO empregado VALUES (8,'Antonio','Da Lua',38,2500,'Analista de Sistemas');
INSERT INTO empregado VALUES (9,'Sassa','Mutema',55,3000,'Vendedor');
INSERT INTO empregado VALUES (10,'José','Silvério',42,2800,'Vendedor');
INSERT INTO empregado VALUES (11,'Gabriel','Oliveira',24,2500,'Técnico em Segurança');
INSERT INTO empregado VALUES (12,'Flávia','Camargo',29,4200,'Analista de Sistemas');
INSERT INTO empregado VALUES (13,'Marina','Delbonis',20,1000,'Secretária');
INSERT INTO empregado VALUES (14,'Paulo','Roberto',33,1500,'Vendedor');
INSERT INTO empregado VALUES (15,'José','Carlos da Silva',27,2900,'Analista de Sistemas');
INSERT INTO empregado VALUES (16,'Rúbia','Miranda',29,3500,'Administrador');
INSERT INTO empregado VALUES (17,'Roberto','Andrade Silva',35,3300,'Vendedor');
INSERT INTO empregado VALUES (18,'Ana','Julia',31,2900,'Secretária');
INSERT INTO empregado VALUES (19,'Pedro','Antonio',41,3500,'Administrador');
INSERT INTO empregado VALUES (20,'Ana','Mara',22,2200,'Psicóloga');
INSERT INTO empregado VALUES (21,'João','Augusto',44,5500,'Gerente');

select * from empregado;

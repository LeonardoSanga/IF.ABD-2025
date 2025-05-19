-- Exercícios Aula06 TRIGGERs - Leonardo Minguini Sanga

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



-- Trabalho 1

-- 1
CREATE TABLE CARRO
	(
	chassi VARCHAR (17),
	renavam VARCHAR (9),
	preco REAL,
	modelo VARCHAR (30),
	ano INTEGER ,
	CONSTRAINT pk_carro PRIMARY KEY (chassi),
	CONSTRAINT un_carro_renavam UNIQUE (renavam),
	CONSTRAINT ck_carro_ano CHECK (ano >= (extract(year FROM current_date) - 15))
	);

INSERT INTO CARRO VALUES('GEW2123IJODP1PLD2', '123412321', 35000, 'Onix', 2010);
INSERT INTO CARRO VALUES('GTD2123IJODP1TGL5', '312534123', 55000, 'Civic', 2009); -- Falha: viola restrição
INSERT INTO CARRO VALUES('GJO5123IJODP1YUI9', '983123098', 85000, 'Civic', 2021);
INSERT INTO CARRO VALUES('GJO51dsIJODP1YUI9', '983123098', 85000, 'Civic', 2021);

-- 2
CREATE SEQUENCE sid_carro START WITH 1 MINVALUE 1 MAXVALUE 10000;

-- 3
CREATE OR REPLACE VIEW v_clientesSemPedido
	AS SELECT nomeCli FROM CLIENTE c
		LEFT JOIN PEDIDO p
		ON c.idCli = p.idCli
		WHERE p.idCli IS NULL;

SELECT * FROM v_clientesSemPedido;

-- 4
CREATE OR REPLACE FUNCTION f_aniversariantes(mes numeric)
RETURNS SETOF RECORD
AS
$$
DECLARE
	regAniversariante record;
BEGIN
	for regAniversariante in SELECT nomeCli FROM CLIENTE
								WHERE extract(month FROM dtaNasc) = mes
	LOOP
		return next regAniversariante;
	END LOOP;

	if not found then
		RAISE EXCEPTION 'Nenhum cliente faz aniversário nesse mês.';
	end if;
	return;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM f_aniversariantes(8) AS ("Aniversariantes do Mês" VARCHAR);

-- 5
CREATE OR REPLACE FUNCTION f_insereAvaliacao()
RETURNS TRIGGER
AS
$$
DECLARE 
	statusPed pedido.status%type;
BEGIN
	SELECT status into statusPed FROM PEDIDO WHERE idPed = NEW.idPed;

	if (statusPed != 'Entregue') then
		RAISE EXCEPTION 'Não devem ser avaliados pedidos não entregues';
		RETURN NULL;
	end if;

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trig_insereAvaliacao BEFORE INSERT ON avaliaPedidoProduto
FOR EACH ROW
	execute procedure f_insereAvaliacao();

SELECT * FROM PEDIDO;
SELECT * FROM PRODUTO;
SELECT * FROM PEDIDOPRODUTO;
SELECT * FROM avaliaPedidoProduto;

INSERT INTO avaliaPedidoProduto VALUES (2, 2, 2, 4);  -- não é inserido
INSERT INTO avaliaPedidoProduto VALUES (3, 3, 3, 4);
INSERT INTO avaliaPedidoProduto VALUES (1, 4, 4, 3);
INSERT INTO avaliaPedidoProduto VALUES (6, 8, 1, 2);
INSERT INTO avaliaPedidoProduto VALUES (8, 12, 1, 4);
INSERT INTO avaliaPedidoProduto VALUES (9, 13, 5, 5);
INSERT INTO avaliaPedidoProduto VALUES (6, 5, 2, 3);  -- não é inserido

-- 6
CREATE OR REPLACE FUNCTION f_atualizaAvaliacao()
RETURNS TRIGGER
AS
$$
DECLARE
	idProduto INTEGER;
	somaNotas NUMERIC;
	qtdNotas INTEGER;
	notaRow RECORD;
	avgNotas NUMERIC;
	statusPed VARCHAR (30);
BEGIN	
	SELECT status into statusPed FROM PEDIDO WHERE idPed = NEW.idPed;

	if (statusPed = 'Entregue') then
		
		SELECT idProd INTO idProduto FROM PedidoProduto WHERE idPed = NEW.idPed;

		qtdNotas = 0;

		for notaRow in SELECT nota FROM avaliaPedidoProduto
									WHERE idProd = idProduto
		LOOP
			qtdNotas = qtdNotas + 1;
			somaNotas = somaNotas + notaRow.nota;
		END LOOP;
	
		avgNotas = somaNotas/qtdNotas;
	
		UPDATE PRODUTO SET avaliacao = avgNotas WHERE idProd = idProduto;

		RETURN NEW;
	end if;

	RAISE EXCEPTION 'Não há avaliações do produto';
	RETURN NULL;
	
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trig_atualizaAvaliacao AFTER INSERT ON PEDIDO
FOR EACH ROW
	execute procedure f_atualizaAvaliacao();

DROP TRIGGER trig_atualizaAvaliacao ON PEDIDO;

-- 6 CORRIGIDA
CREATE OR REPLACE FUNCTION f_atualizaAvaliacao2()
RETURNS TRIGGER
AS
$$
DECLARE
	somaNotas NUMERIC := 0;
	qtdNotas INTEGER := 0;
	avgNotas produto.avaliacao%type;
	notaRow avaliaPedidoProduto.nota%type;
	statusPed pedido.status%type;
BEGIN	
	SELECT status into statusPed FROM PEDIDO WHERE idPed = NEW.idPed;

	if (statusPed = 'Entregue') then

		qtdNotas = 0;

		for notaRow in SELECT nota FROM avaliaPedidoProduto
									WHERE idProd = NEW.idProd
		LOOP
			qtdNotas = qtdNotas + 1;
			somaNotas = somaNotas + notaRow;
		END LOOP;
	
		IF qtdNotas > 0 THEN
            avgNotas := somaNotas / qtdNotas;
            UPDATE PRODUTO SET avaliacao = avgNotas WHERE idProd = NEW.idProd;
        ELSE
            RAISE EXCEPTION 'Não há avaliações suficientes para calcular a média';
        END IF;

		RETURN NEW;
	end if;

	RAISE EXCEPTION 'Não há avaliações do produto';
	RETURN NULL;
	
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trig_atualizaAvaliacao2 AFTER INSERT ON avaliaPedidoProduto
FOR EACH ROW
	execute procedure f_atualizaAvaliacao2();

INSERT INTO PEDIDO VALUES (18, current_date, 300, 'Entregue', 3);
INSERT INTO PEDIDOPRODUTO VALUES (18, 5, 2);
INSERT INTO avaliaPedidoProduto VALUES (3, 18, 5, 3);

INSERT INTO PEDIDO VALUES (24, current_date, 300, 'Em rota de entrega', 7);
INSERT INTO PEDIDOPRODUTO VALUES (24, 4, 1);
INSERT INTO avaliaPedidoProduto VALUES (7, 24, 4, 5); -- não executa

INSERT INTO PEDIDO VALUES (19, current_date, 300, 'Entregue', 7);
INSERT INTO PEDIDOPRODUTO VALUES (19, 4, 1);
INSERT INTO avaliaPedidoProduto VALUES (7, 19, 4, 5);

INSERT INTO PEDIDO VALUES (20, current_date, 300, 'Entregue', 7);
INSERT INTO PEDIDOPRODUTO VALUES (20, 3, 3);
INSERT INTO avaliaPedidoProduto VALUES (7, 20, 3, 1);

INSERT INTO PEDIDO VALUES (21, current_date, 300, 'Entregue', 8);
INSERT INTO PEDIDOPRODUTO VALUES (21, 1, 3);
INSERT INTO avaliaPedidoProduto VALUES (8, 21, 1, 3);

INSERT INTO PEDIDO VALUES (22, current_date, 500, 'Entregue', 3);
INSERT INTO PEDIDOPRODUTO VALUES (22, 2, 5);
INSERT INTO avaliaPedidoProduto VALUES (3, 22, 2, 2);

INSERT INTO PEDIDO VALUES (23, current_date, 1000, 'Entregue', 10);
INSERT INTO PEDIDOPRODUTO VALUES (23, 4, 1);
INSERT INTO avaliaPedidoProduto VALUES (10, 23, 4, 3);

INSERT INTO PEDIDO VALUES (24, current_date, 1000, 'Entregue', 10);
INSERT INTO PEDIDOPRODUTO VALUES (24, 4, 1);
INSERT INTO avaliaPedidoProduto VALUES (10, 24, 4, 2);

DELETE FROM PEDIDO WHERE idPed = 19;
DELETE FROM PEDIDOPRODUTO WHERE idped = 19;
DELETE FROM AVALIAPEDIDOPRODUTO WHERE idPed = 19;

SELECT * FROM PEDIDO;
SELECT * FROM PRODUTO;
SELECT * FROM PEDIDOPRODUTO;
SELECT * FROM avaliaPedidoProduto;

-- SCRIPTs utilizados:

--DROP TABLE CLIENTE
CREATE TABLE CLIENTE
	(idCli INTEGER,
	 nomeCli VARCHAR(50) NOT NULL,
	 rua VARCHAR(50),
	 nro INTEGER,
	 cidade VARCHAR (50),
	 CEP VARCHAR (15),
	 dtaNasc DATE,
	 CONSTRAINT pk_cliente PRIMARY KEY (idCli)
	);
	
INSERT INTO CLIENTE VALUES 
	(1, 'Pedro Augusto', 'Rua 15', 2050, 'Santa Fé do Sul', '15500-000', '10/10/2000'),
	(2, 'Maria Antonia', 'Rua Silva Jardim', 3450, 'São José do Rio Preto', '15025-065', '18/08/1998'),
	(3, 'Carlos Roberto', 'Rua Rio Preto', 2500, 'São José do Rio Preto', '15015-760', '07/11/2002'),
	(4, 'Ana Paula', 'Rua Espanha', 700, 'São José do Rio Preto', '15084-080', '22/10/2000'),
	(5, 'Silvia Arantes', 'Av. Campo Grande', 4400, 'Votuporanga', '15500-306', '25/03/1995'),
	(6, 'Carla Silva', 'Rua Oiapoc', 4000, 'Votuporanga', '15500-478', '10/02/2002'),
	(7, 'Manuela Antunes', 'Rua das Bandeiras', 4250, 'Votuporanga', '15500-117', '18/12/2000'),
	(8, 'Ricardo dos Santos', 'Rua Leonardo Commar', 2650, 'Votuporanga', '15503-023', '03/07/1996'),
	(9, 'Antônio Galhardo', 'Rua Sergipe', 1140, 'Fernandópolis', '15600-000', '13/08/2004'),
	(10, 'Daniela Agustine', 'Rua Paraíba', 1245, 'Fernandópolis', '15600-000', '01/10/2002');
INSERT INTO CLIENTE VALUES 
	(11, 'José Antônio', 'Rua Amazonas', 3050, 'Votuporanga', '15500-478', '07/10/1998'),
	(12, 'Márcia Amadeu', 'Rua Paraíba', 1450, 'Fernandópolis', '15600-000', '07/08/2004');
	
--DROP TABLE PEDIDO
CREATE TABLE PEDIDO
	(idPed INTEGER,
	 dtaPed DATE,
	 totalPed REAL,
	 status VARCHAR (30),
	 idCli INTEGER,
	 CONSTRAINT pk_pedido PRIMARY KEY (idPed),
	 CONSTRAINT fk_cli_ped FOREIGN KEY (idCli) REFERENCES CLIENTE
	);
	
INSERT INTO PEDIDO VALUES
	(1, '25/01/2025', 500, 'Pagamento Aprovado', 1),
	(2, '25/01/2025', 300, 'Em rota de entrega', 2),
	(3, '22/12/2024', 1800, 'Entregue', 3),
	(4, '18/01/2025', 4800, 'Entregue', 1),
	(5, '23/01/2025', 200, 'Em rota de entrega', 4),
	(6, '26/01/2025', 300, 'Pagamento Aprovado', 5),
	(7, '28/01/2025', 1000, 'Aguardando pagamento', 5),
	(8, '04/01/2025', 900, 'Entregue', 6),
	(9, '26/01/2025', 1000, 'Pagamento Aprovado', 7),
	(10, '28/01/2025', 2000, 'Aguardando pagamento', 8),
	(11, '27/01/2025', 600, 'Pagamento Aprovado', 8),
	(12, '10/01/2025', 1000, 'Entregue', 8),
	(13, '11/01/2025', 400, 'Entregue', 9),
	(14, '23/01/2025', 200, 'Pagamento Aprovado', 10),
	(15, '22/01/2025', 300, 'Em rota de entrega', 10);
	
--DROP TABLE PRODUTO
CREATE TABLE PRODUTO
	(idProd INTEGER,
	 nomeProd VARCHAR (60),
	 marcaProd VARCHAR (40),
	 preco REAL,
	 avaliacao REAL default 0,
	 CONSTRAINT pk_produto PRIMARY KEY (idProd)
	);
	
INSERT INTO PRODUTO VALUES
	(1, 'Air Fryer', 'Mondial', 500),
	(2, 'Echo dot 5º', 'Amazon', 300),
	(3, 'Celular 64Gb', 'Samsung', 900),
	(4, 'Notebook', 'Lenovo', 4800),
	(5, 'Liquidificador', 'Mondial', 200);

--DROP TABLE pedidoProduto
CREATE TABLE PEDIDOPRODUTO
	(idPed INTEGER,
	 idProd INTEGER,
	 qtade INTEGER,
	 CONSTRAINT pk_pedprod PRIMARY KEY (idPed, idProd),
	 CONSTRAINT fk_pedPP FOREIGN KEY (idPed) REFERENCES pedido,
	 CONSTRAINT fk_proPP FOREIGN KEY (idProd) REFERENCES produto
	);
INSERT INTO PEDIDOPRODUTO VALUES
	(1, 1, 1), (2, 2, 1), (3, 3, 1), (4, 4, 1),
	(5, 5, 1), (6, 2, 1), (7, 1, 2), (8, 1, 1),
	(8, 5, 2), (9, 1, 2), (10, 3, 2), (10, 5, 1),
	(11, 2, 2), (12, 1, 2), (13, 5, 2), (14, 5, 1), (15, 2, 1);
	
CREATE TABLE avaliaPedidoProduto
	(idCli INTEGER,
	 idPed INTEGER,
	 idProd INTEGER,
	 nota REAL,
	 dtaAvaliacao DATE DEFAULT current_date,
	 CONSTRAINT pk_avaliaPedidoProduto PRIMARY KEY (idCli, idPed, idProd),
	 CONSTRAINT fk_avaPedProd FOREIGN KEY (idPed, idProd) REFERENCES PedidoProduto,
	 CONSTRAINT fk_avaCliente FOREIGN KEY (idCli) REFERENCES CLIENTE
	);
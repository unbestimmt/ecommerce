-- criando database de ecommerce


-- -----------------------------------------------------
-- Database ecommerce
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS `ecommerce`;
USE `ecommerce` ;

-- -----------------------------------------------------
-- Table `ecommerce`.`ThirdPartySeller`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`ThirdPartySeller` (
  `idThirdPartySeller` INT NOT NULL AUTO_INCREMENT,
  `CompanyName` VARCHAR(45) NULL,
  `Address` VARCHAR(45) NOT NULL,
  `TradingName` VARCHAR(45) NOT NULL,
  `CNPJ` CHAR(14) NULL,
  `CPF` CHAR(11) NULL,
  PRIMARY KEY (`idThirdPartySeller`),
  CONSTRAINT `Seller_CompanyName_UNIQUE` UNIQUE (`CompanyName`),
  CONSTRAINT `Seller_CNPJ_UNIQUE` UNIQUE (`CNPJ`),
  CONSTRAINT `Seller_CPF_UNIQUE` UNIQUE (`CPF`)
  );


-- -----------------------------------------------------
-- Table `ecommerce`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Product` (
  `idProduct` INT NOT NULL AUTO_INCREMENT,
  `Pname` VARCHAR(15) NOT NULL,
  `Category` VARCHAR(45) NOT NULL,
  `Price` DECIMAL(6,2) UNSIGNED NOT NULL,
  `Description` VARCHAR(45) NULL,
  `Rating` DECIMAL(2,1) UNSIGNED NULL,
  `Size` VARCHAR(20) NULL,
  PRIMARY KEY (`idProduct`)
  );


-- -----------------------------------------------------
-- Table `ecommerce`.`Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Supplier` (
  `idSupplier` INT NOT NULL AUTO_INCREMENT,
  `CompanyName` VARCHAR(45) NOT NULL,
  `CNPJ` CHAR(14) NOT NULL,
  `ContactInfo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idSupplier`),
  CONSTRAINT `Supplier_CompanyName_UNIQUE` UNIQUE (`CompanyName`),
  CONSTRAINT `Supplier_CNPJ_UNIQUE` UNIQUE (`CNPJ`) 
  );


-- -----------------------------------------------------
-- Table `ecommerce`.`Stock`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Stock` (
  `idStock` INT NOT NULL AUTO_INCREMENT,
  `Location` VARCHAR(45) NOT NULL,
  `Quantity` INT UNSIGNED DEFAULT 0,
  PRIMARY KEY (`idStock`)
  );


-- -----------------------------------------------------
-- Table `ecommerce`.`Client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Client` (
  `idClient` INT NOT NULL AUTO_INCREMENT,
  `Fname` VARCHAR(15) NOT NULL,
  `Minit` VARCHAR(3) NULL,
  `Lname` VARCHAR(20) NOT NULL,
  `CPF` CHAR(11) NOT NULL,
  `Address` VARCHAR(45) NULL,
  `Birthdate` DATE NOT NULL,
  PRIMARY KEY (`idClient`),
  CONSTRAINT `CPF_UNIQUE` UNIQUE (`CPF`)
  );


-- -----------------------------------------------------
-- Table `ecommerce`.`Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Payment` (
  `idPayment` INT NOT NULL AUTO_INCREMENT,
  `Client_idClient` INT NOT NULL,
  `PaymentType` ENUM('Boleto', 'Débito', 'Crédito', 'PIX') NOT NULL,
  PRIMARY KEY (`idPayment`, `Client_idClient`),
  CONSTRAINT `fk_Payment_Client1`
    FOREIGN KEY (`Client_idClient`)
    REFERENCES `ecommerce`.`Client` (`idClient`)
    );


-- -----------------------------------------------------
-- Table `ecommerce`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Order` (
  `idOrder` INT NOT NULL AUTO_INCREMENT,
  `OrderStatus` ENUM('Em andamento', 'Processando', 'Enviado', 'Entregue') DEFAULT 'Processando',
  `Description` VARCHAR(45) NULL,
  `Shipping` DECIMAL(6,2) NULL,
  `Payment_idPayment` INT NOT NULL,
  `Client_idClient` INT NOT NULL,
  PRIMARY KEY (`idOrder`),
  CONSTRAINT `fk_Order_Payment1`
    FOREIGN KEY (`Payment_idPayment`)
    REFERENCES `ecommerce`.`Payment` (`idPayment`),
  CONSTRAINT `fk_Order_Client1`
    FOREIGN KEY (`Client_idClient`)
    REFERENCES `ecommerce`.`Client` (`idClient`)
    );


-- -----------------------------------------------------
-- Table `ecommerce`.`Produto_has_Estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produto_has_Estoque` (
  `Product_idProduct` INT NOT NULL,
  `Stock_idStock` INT NOT NULL,
  PRIMARY KEY (`Product_idProduct`, `Stock_idStock`),
  CONSTRAINT `fk_Produto_has_Estoque_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `ecommerce`.`Product` (`idProduct`),
  CONSTRAINT `fk_Produto_has_Estoque_Stock1`
    FOREIGN KEY (`Stock_idStock`)
    REFERENCES `ecommerce`.`Stock` (`idStock`)
    );


-- -----------------------------------------------------
-- Table `ecommerce`.`MakingProductAvailable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`MakingProductAvailable` (
  `Supplier_idSupplier` INT NOT NULL,
  `Product_idProduct` INT NOT NULL,
  `Quantity` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Supplier_idSupplier`, `Product_idProduct`),
  CONSTRAINT `fk_MakingProductAvailable_Supplier1`
    FOREIGN KEY (`Supplier_idSupplier`)
    REFERENCES `ecommerce`.`Supplier` (`idSupplier`),
  CONSTRAINT `fk_MakingProductAvailable_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `ecommerce`.`Product` (`idProduct`)
    );


-- -----------------------------------------------------
-- Table `ecommerce`.`ProductsPerSeller`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`ProductsPerSeller` (
  `ThirdPartySeller_idThirdPartySeller` INT NOT NULL,
  `Product_idProduct` INT NOT NULL,
  `Quantity` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`ThirdPartySeller_idThirdPartySeller`, `Product_idProduct`),
  CONSTRAINT `fk_ProductsPerSeller_ThirdPartySeller1`
    FOREIGN KEY (`ThirdPartySeller_idThirdPartySeller`)
    REFERENCES `ecommerce`.`ThirdPartySeller` (`idThirdPartySeller`),
  CONSTRAINT `fk_ProductsPerSeller_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `ecommerce`.`Product` (`idProduct`)
    );


-- -----------------------------------------------------
-- Table `ecommerce`.`ProductOrderRelationship`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`ProductOrderRelationship` (
  `Product_idProduct` INT NOT NULL,
  `Order_idOrder` INT NOT NULL,
  `Quantity` INT NOT NULL,
  PRIMARY KEY (`Product_idProduct`, `Order_idOrder`),
  CONSTRAINT `fk_ProductOrderRelationship_Product1`
    FOREIGN KEY (`Product_idProduct`)
    REFERENCES `ecommerce`.`Product` (`idProduct`),
  CONSTRAINT `fk_ProductOrderRelationship_Order1`
    FOREIGN KEY (`Order_idOrder`)
    REFERENCES `ecommerce`.`Order` (`idOrder`)
    );


-- -----------------------------------------------------

SHOW TABLES;

SHOW DATABASES;
USE information_schema;
DESC REFERENTIAL_CONSTRAINTS;
SELECT * FROM REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'ecommerce';


-- -----------------------------------------------------
-- Inserindo dados:
-- -----------------------------------------------------
-- ThirdPartySeller
-- Product
-- Supplier
-- Stock
-- Client
-- Payment
-- Order
-- Produto_has_Estoque
-- MakingProductAvailable
-- ProductsPerSeller
-- ProductOrderRelationship
-- -----------------------------------------------------

insert into ThirdPartySeller (CompanyName, Address, TradingName, CNPJ, CPF) values
	('BUD COMÉRCIO DE ELETRODOMÉSTICOS LTDA.', 'Rua Olympia Semeraro, 675, São Paulo', 'Compra Certa', '62058318000776', null),
    ('CENTRO ATACADISTA BARAO LTDA', ' Av. Papa João Paulo I, 5627, Guarulhos', 'Toymania', '49329873000565', null),
    (null, 'Av República Argentina, 123', 'Lanchonete da Maria', null, '11122233300');

insert into Product (Pname, Category, Price, `Description`, Rating, Size) values 
	('iPhone 12', 'smartphone', 5000.00, null, 8.7, null),
    ('iMac M2', 'computador', 9500.00, 'notebook com chip ARM M2', 9.2, '13 polegadas'),
    ('Kindle', 'eletrônico', 565.00, 'kindle de última geração', 8.0, null),
    ('Office 365', 'software', 450, null, 8.9, null);

insert into Supplier (CompanyName, CNPJ, ContactInfo) values
	('Apple Inc.', '11111111111111', 'www.apple.com/br/support'),
    ('Microsoft Corp', '22222222222222', '+1. (800) 642 7676'),
    ('Amazon.com Inc.', '33333333333333', '0800 038 0541');

insert into Stock (Location, Quantity) values
	('São Paulo', 200),
    ('Rio de Janeiro', 150),
    ('São Paulo', 115),
    ('Curitiba', 57),
    ('Porto Alegre', 320);

insert into `Client` (Fname, Minit, Lname, CPF, Address, Birthdate) values
	('Luis', null, 'Silva', '11111111111', 'Rua da Paz, 12', 19900301),
    ('Marina', 'F', 'Nogueira', '22222222222', 'Rua XV de Novembro, 113', 19681015),
    ('Renato', null, 'Prado', '33333333333', 'Rua Rocha Pombo, 35', 19871211),
    ('Pedro', null, 'Pires', '44444444444', 'Av Brasil, 1165', 19820623);

insert into Payment (Client_idClient, PaymentType) values
	(1, 'PIX'),
    (1, 'Boleto'),
    (2, 'Boleto'),
    (3, 'Crédito'),
    (3, 'Crédito'),
    (3, 'Débito');

insert into `Order` (OrderStatus, `Description`, Shipping, Payment_idPayment, Client_idClient) values
	(default, null, 15.50, 1, 1),
    ('Em andamento', null, 12.35, 2, 1),
    ('Em andamento', 'Entregar de manhã', 9.90, 3, 2),
    ('Entregue', null, 10.12, 4, 3),
    ('Entregue', null, 11.50, 5, 3),
    ('Enviado', null, 9.70, 6, 3);

insert into Produto_has_Estoque (Product_idProduct, Stock_idStock) values
	(1, 1),
    (2, 3),
    (3, 2),
    (4, 4),
    (4, 5);

insert into MakingProductAvailable (Supplier_idSupplier, Product_idProduct, Quantity) values
	(1, 1, 250),
    (1, 2, 100),
    (2, 4, 1000),
    (3, 3, 320);

insert into ProductsPerSeller (ThirdPartySeller_idThirdPartySeller, Product_idProduct, Quantity) values 
	(1, 1, 25),
    (1, 2, 10),
    (2, 3, 15);

insert into ProductOrderRelationship (Product_idProduct, Order_idOrder, Quantity) values
	(1, 1, 1),
    (1, 3, 1),
    (2, 2, 1),
    (3, 4, 2),
    (4, 5, 1),
    (1, 6, 1);


-- -----------------------------------------------------
-- Queries
-- -----------------------------------------------------

-- Quais os pedidos e os tipos de pagamentos
select * from `Order` left outer join Payment on Payment_idPayment = idPayment;

-- Quais os clientes e seus pedidos
select * from `Client` c, `Order` o where c.idClient = o.Client_idClient;

-- Quais os nomes dos clientes, número do pedido e status do pedido
select concat(Fname, ' ', Lname) as `Client`, idOrder as `Order`, OrderStatus as `Status` 
	from `Client` c, `Order` o 
    where c.idClient = o.Client_idClient
    order by OrderStatus;

-- Quantidade de pedidos da relação cliente x pedido
select count(*)
	from `Client` c, `Order` o 
    where c.idClient = o.Client_idClient;
    
-- Quantidade de pedidos por cliente e nome do cliente
select count(*) as Quantidade_de_pedidos, concat(Fname, ' ', Lname) as `Name`
	from `Client` c, `Order` o 
    where c.idClient = o.Client_idClient
    group by idClient;

-- Nome dos clientes, incluindo clientes que não fizeram pedidos, número do pedido e status do pedido, ordenado pelo status
select concat(Fname, ' ', Lname) as `Client`, idOrder as `Order`, OrderStatus as `Status` 
	from `Client` c left outer join `Order` o 
    on c.idClient = o.Client_idClient
    order by OrderStatus;

-- Nome de clientes que não fizeram pedidos
select concat(Fname, ' ', Lname) as `Client`, idOrder as `Order`, OrderStatus as `Status` 
	from `Client` c left outer join `Order` o 
    on c.idClient = o.Client_idClient
    where idOrder is null;

-- Nome dos clientes, número do pedido, status, nome do produto e quantidade comprada
select concat(Fname, ' ', Lname) as `Client`, idOrder as `Order`, OrderStatus as `Status`, Pname, por.Quantity 
	from `Client` c inner join `Order` o 
		on c.idClient = o.Client_idClient
    inner join ProductOrderRelationship por 
		on Order_idOrder = idOrder
	inner join Product p
		on Product_idProduct = idProduct
    order by OrderStatus;
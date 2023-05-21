/*
Practice:


Необхідно спроектувати БД поставки товарів
В БД має зберігатися наступна інформація:

ТОВАРИ:
- код товара, назва, ціна

ЗАМОВЛЕННЯ на поставку:
- код замовлення
- наименування постачальника, 
- адреса постачальника,
- телефон 
- номер договору
- дата заключення договору
- наіменування товару
- план поставки (кількість в шт.)

Фактичні відгрузки товару:
- код відгрузки
- код замовлення
- дата відгрузки
- відгружено товару (шт)

При проектуванні БД необхідно врахувати:
- товар має декілька замовлень на постачання.
- Замовлення відповідає одному товару
- товару можуть відповідати декілька відгрузок
- у одній вігрузці може бути декілька товарів

- товар не обов'язково має замовлення. Кожне замовлення відповідає товару
- товар не обов'язково відгружається замовнику, але кожна вігрузка обов'язково відповідає певному товару.


--окремо постачальники
--окремо укладені договори
--окремо відгрузки
--ціна товару залежить від замовлення
*/

/* товари+*/
CREATE TABLE goods (
    id serial PRIMARY KEY,
    name varchar(200) CHECK (name != '') NOT NULL
);

/* постачальники+*/

CREATE TABLE providers (
    id serial PRIMARY KEY,
    name varchar(160) not null,
    adress text NOT NULL,
    phone varchar(18) NOT NULL
);

/*відгрузки+*/
CREATE TABLE shipments (
    id serial PRIMARY KEY,
    id_orders int REFERENCES orders_to_delivery(id),
    shipments_date date NOT NULL,
    PRIMARY KEY (id, id_orders)
);

/*товари до відгрузок таблиця з двох*/

CREATE TABLE goods_to_shipments (
    id_goods int REFERENCES goods(id),
    id_shipment int REFERENCES shipments(id),
    goods_quantity int NOT NULL,
)

/*замовлення +*/
CREATE TABLE orders_to_delivery (
    id serial PRIMARY KEY,
    id_goods int REFERENCES goods(id),
    quantity_plan int NOT NULL,
    supply_contract_number NOT NULL,
    supply_contract_date NOT NULL,
    provider_id int REFERENCES providers(id),
    price_of_goods decimal(10,2)
);


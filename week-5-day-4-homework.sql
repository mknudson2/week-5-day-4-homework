

--write a function: Update the city and the country of the new customer in the respective tables

--> updates the country
CREATE OR REPLACE FUNCTION updateCountry (_country_id INTEGER, _country VARCHAR)
RETURNS void
LANGUAGE plpgsql AS $$
	BEGIN 
		UPDATE country 
		SET country = _country
		WHERE country_id = _country_id;
	END
$$

SELECT updateCountry(112, 'Yggdrasil');
SELECT * FROM country WHERE country = 'Yggdrasil';


--> update the city
CREATE OR REPLACE FUNCTION updateCity (_city_id INTEGER, _city VARCHAR)
RETURNS void
LANGUAGE plpgsql AS $$
	BEGIN 
		UPDATE city 
		SET city = _city
		WHERE city_id = _city_id;
	END
$$

SELECT updateCity(601, 'Niflheim');
SELECT * FROM city WHERE city = 'Niflheim';


------------------------------------------------

--write a procedure: Add a new customer (which subsequently required adding a new address, city, and country)

-->create new country
CREATE OR REPLACE PROCEDURE addCountry( _country VARCHAR)
LANGUAGE plpgsql AS $$
DECLARE
    _country_id INTEGER;
BEGIN
    INSERT INTO country
    VALUES (_country)
    RETURNING country_id INTO _country_id;
    
    PERFORM  _country_id; --since I am NOT assigning a variable TO this, AS it IS serially genereated, we use 
    							--PERFORM to execute the select statement without utilizing the result, allowing the 
    							--procedure to work without interfering with the serial numbering (if I understand 	
    							--correctly!). 
   COMMIT;
END
$$

CALL addCountry('Niflheim');



--> create new city
CREATE OR REPLACE PROCEDURE addCity(_city varchar, _country_id integer)
LANGUAGE plpgsql AS $$
	BEGIN
		INSERT INTO city (
			city,
			country_id
		) VALUES (
			_city,
			_country_id	
		);

		COMMIT;
	END
	
$$;

CALL addCity('Hel', 112);



--> create new address
CREATE OR REPLACE PROCEDURE addAddress(_address VARCHAR, _district VARCHAR, _city_id INTEGER, _postal_code INTEGER, _phone INTEGER)
LANGUAGE plpgsql AS $$
	BEGIN
		INSERT INTO address (
			address,
			district,
			city_id,
			postal_code ,
			phone 
		) VALUES (
			_address,
			_district,
			_city_id,
			_postal_code ,
			_phone	
		);
		COMMIT;
	END
$$

CALL addAddress ('Eljúðnir', 'Hel', 601, 60306, 271802112)


-->Add a new customer (Baldr Óðinsson)
CREATE OR REPLACE PROCEDURE addCustomer(
	_first_name VARCHAR, 
	_last_name VARCHAR, 
	_email VARCHAR, 
	_store_id INTEGER,
	_address_id INTEGER
	) 
LANGUAGE plpgsql AS $$
	BEGIN
		INSERT INTO customer (
		first_name,
		last_name,
		email,
		store_id,
		address_id
		) VALUES (
			_first_name,
			_last_name,
			_email,
			_store_id,
			_address_id
		);
		COMMIT;
	END
$$

CALL addcustomer ('Baldr', 'Óðinsson', 'hinnhviti@asgard.no', 1, 606);
SELECT * FROM customer c WHERE first_name = 'Baldr';
	
	
CREATE TABLE Location (
location_id DECIMAL(12) NOT NULL PRIMARY KEY,
location_name VARCHAR(64) NOT NULL);

CREATE TABLE Dig_Site(
dig_site_id DECIMAL(12) NOT NULL PRIMARY KEY,
location_id DECIMAL(12) NOT NULL,
dig_name VARCHAR(32) NOT NULL,
dig_cost DECIMAL(8,2),
FOREIGN KEY (location_id) REFERENCES Location(location_id));

CREATE TABLE Paleontologist(
paleontologist_id DECIMAL(12) NOT NULL PRIMARY KEY,
first_name VARCHAR(32) NOT NULL,
last_name VARCHAR(32) NOT NULL);

CREATE TABLE Dinosaur_discovery(
dinosaur_discovery_id DECIMAL(12) PRIMARY KEY,
dig_site_id DECIMAL(12) NOT NULL,
paleontologist_id DECIMAL(12) NOT NULL,
common_name VARCHAR(64) NOT NULL,
fossil_weight DECIMAL(6) NOT NULL,
FOREIGN KEY (dig_site_id) REFERENCES Dig_site(dig_site_id),
FOREIGN KEY (paleontologist_id) REFERENCES Paleontologist(paleontologist_id));

--Location Table
INSERT INTO Location (location_id, location_name)
VALUES(1, 'Stonesfield');
INSERT INTO Location (location_id, location_name)
VALUES(2, 'Utah');
INSERT INTO Location (location_id, location_name)
VALUES(3, 'Arizona');

--Dig_Site Table
INSERT INTO Dig_Site (dig_site_id, location_id, dig_name, dig_cost)
VALUES (1, 1, 'Great British Dig', 8000.00);
INSERT INTO Dig_Site (dig_site_id, location_id, dig_name, dig_cost)
VALUES (2, 2, 'Parowan Dinosaur Tracks', 10000.00);
INSERT INTO Dig_Site (dig_site_id, location_id, dig_name, dig_cost)
VALUES (3, 3, 'Dynamic Desert Dig', 3500.00);
INSERT INTO Dig_Site (dig_site_id, location_id, dig_name)
VALUES (4, 1, 'Mission Jurassic Dig');
INSERT INTO Dig_Site (dig_site_id, location_id, dig_name, dig_cost)
VALUES (5, 1, 'Ancient Site Dig', 5500.00);

--Paleontologist Table
INSERT INTO Paleontologist (paleontologist_id, first_name, last_name)
VALUES (1, 'William', 'Buckland');
INSERT INTO Paleontologist (paleontologist_id, first_name, last_name)
VALUES (2, 'John', 'Ostrom');
INSERT INTO Paleontologist (paleontologist_id, first_name, last_name)
VALUES (3, 'Henry', 'Osborn');

--Dinosaur Discovery Table
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (1, 1, 1, 'Megalosaurus', 3000);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (2, 1, 1, 'Apatosaurus', 4000);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (3, 1, 1, 'Triceratops', 4500);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (4, 1, 1, 'Stegosaurus', 3500);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (5, 2, 2, 'Parasaurolophus', 6000);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (6, 2, 2, 'Tyrannosaurus Rex', 5000);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (7, 2, 2, 'Velociraptor', 7000);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (8, 3, 2, 'Tyrannosaurus Rex', 7000);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (9, 4, 3, 'Spinosaurus', 8000);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (10, 4, 3, 'Diplodocus', 9000);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (11, 5, 3, 'Tyrannosaurus Rex', 7500);
INSERT INTO Dinosaur_Discovery (dinosaur_discovery_id, dig_site_id, paleontologist_id,
							 	common_name, fossil_weight)
VALUES (12, 5, 2, 'Brachiosaurus', 12000);

--Count the number of dinosaur discoveries that weigh at last 4200 pounds
SELECT COUNT (fossil_weight) AS Number_of_Heavy_Fossils
FROM Dinosaur_Discovery
WHERE fossil_weight >= 4200;


--Obtain the most expensive and least expensive dinosaur digs
SELECT CAST(MIN (dig_cost) AS money) AS least_expensive_dig, 
CAST(MAX(dig_cost) AS money) AS most_expensive_dig
FROM Dig_site;

--Obtain dig site name and cost, and number of dinosaur discoveries at each site
SELECT dig_name, CAST(dig_cost AS MONEY), COUNT(dinosaur_discovery_id) AS Number_of_discoveries
FROM Dinosaur_Discovery
JOIN Dig_site ON Dig_site.dig_site_id = Dinosaur_Discovery.dig_site_id
GROUP BY dig_name, Dig_cost;

--Obtain locations with at least 6 dinosaur discoveries
SELECT location_name, COUNT (dinosaur_discovery_id) AS Number_of_Discoveries
FROM Dig_Site
JOIN Location ON Location.location_id = Dig_site.location_id
JOIN Dinosaur_Discovery ON Dinosaur_Discovery.dig_site_id = Dig_site.dig_site_id 
GROUP BY Location.location_name
HAVING COUNT (dinosaur_discovery_id) >= 6;

--Obtain the dig sites that had at least 15,000 pounds of discovered fossils.
SELECT dig_name, SUM(fossil_weight) AS total_pounds_of_dinosaur_remains
FROM Dinosaur_Discovery
JOIN Dig_site ON Dig_site.dig_site_id = Dinosaur_Discovery.dig_site_id
GROUP BY dig_name
HAVING SUM(fossil_weight) >= 15000;

--Obtain the names of all paleontologists, number of digs they participated in
--at the stonesfield location. Order from most to least number of digs
SELECT first_name || ' ' || last_name AS paleontologist_name,  
COUNT(Dinosaur_Discovery.dig_site_id) AS Number_of_digs_at_Stonesfield
FROM Dinosaur_Discovery
JOIN Dig_site ON Dig_site.dig_site_id = Dinosaur_Discovery.dig_site_id 
RIGHT JOIN Location ON Location.location_id = Dig_site.location_id 
AND Location.location_name = 'Stonesfield'
RIGHT JOIN Paleontologist ON Paleontologist.paleontologist_id = Dinosaur_Discovery.paleontologist_id
GROUP BY Paleontologist.paleontologist_id
ORDER BY  Number_of_digs_at_Stonesfield DESC;

--WHERE Location_name = 'Stonesfield'
--HAVING COUNT(Dinosaur_Discovery.dig_site_id) >= 0
--DROP TABLE Location, Paleontologist, dinosaur_discovery, dig_site;

UPDATE dinosaur_discovery 
SET paleontologist_id = 2
WHERE common_name = 'Brachiosaurus';

SELECT Dig_name, CAST(Dig_cost AS MONEY)
FROM Dig_site;

SELECT dig_name, COUNT (dinosaur_discovery_id), CAST (Dig_cost AS MONEY)
FROM Dinosaur_Discovery
JOIN Dig_site ON Dig_site.dig_site_id = Dinosaur_Discovery.dig_site_id
GROUP BY dig_name, Dig_cost;

SELECT dig_name, CAST(dig_cost AS MONEY), SUM(fossil_weight) AS total_pounds_of_dinosaur_remains
FROM Dinosaur_Discovery
JOIN Dig_site ON Dig_site.dig_site_id = Dinosaur_Discovery.dig_site_id
GROUP BY dig_name, dig_cost;

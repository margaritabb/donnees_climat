CREATE DATABASE entite;
go

USE entite;

--ALTER TABLE Position DROP CONSTRAINT fkclimat;

DROP TABLE if exists Adoption;
DROP TABLE if exists EntiteMobile;
DROP TABLE if exists Client;
DROP TABLE if exists Climat;
DROP TABLE if exists Position;

CREATE TABLE Climat (
	TypeClimat VARCHAR(30),
	Précipitations NUMERIC(10),
	Température NUMERIC(10),
	Vent NUMERIC(10),
	Courant_Jet NUMERIC(10),
	Houle NUMERIC(10),
	CONSTRAINT pkclimat PRIMARY KEY (TypeClimat)
);

INSERT INTO Climat VALUES ('Froid', 200, -25, 30, 300, 7);
INSERT INTO Climat VALUES ('Tempéré', 2000, 5, 10, 200, 4);
INSERT INTO Climat VALUES ('Continental', 500, 5, 15, 250, 4);
INSERT INTO Climat VALUES ('Tropical', 2500, 25, 15, 100, 5);
INSERT INTO Climat VALUES ('Désertique', 100, 40, 25, 75, 3);

CREATE TABLE Position (
	Latitude DECIMAL(8,6),
	Longitude DECIMAL(9,6),
	DatePosition DATETIME,
	Ref_Climat VARCHAR(30),
	FOREIGN KEY (Ref_Climat) REFERENCES Climat (TypeClimat) ON DELETE CASCADE,
	CONSTRAINT pkposition PRIMARY KEY (Latitude, Longitude, DatePosition)
);

--Montréal à Toronto
INSERT INTO Position VALUES (45.5017, 73.5673, '2020-08-08 13:30:40', 'Continental');
INSERT INTO Position VALUES (45.3518, 75.6847, '2020-08-08 13:59:51', 'Continental');
INSERT INTO Position VALUES (45.2793, 77.7290, '2020-08-08 14:20:30', 'Continental');
INSERT INTO Position VALUES (44.9635, 79.7712, '2020-08-08 14:40:21', 'Continental');
INSERT INTO Position VALUES (43.6532, 79.3832, '2020-08-08 15:02:39', 'Continental');
--Shanghai à Vancouver
INSERT INTO Position VALUES (31.2304, 121.4737, '2021-04-12 05:30:59', 'Tropical');
INSERT INTO Position VALUES (38.0485, 132.0353, '2021-04-20 08:44:31', 'Tropical');
INSERT INTO Position VALUES (43.6308, 141.7547, '2021-04-28 10:20:13', 'Tropical');
INSERT INTO Position VALUES (50.4045, 147.6037, '2021-05-06 06:41:39', 'Tempéré');
INSERT INTO Position VALUES (49.2812, 123.1208, '2021-05-11 14:01:00', 'Tempéré');
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();
--INSERT INTO Position VALUES ();

CREATE TABLE Client (
	IdClient NUMERIC(10),
	Nom VARCHAR(30),
	DateAdoption DATE,
	CONSTRAINT pkclient PRIMARY KEY (IdClient)
);

INSERT INTO Client VALUES (1, 'Air Canada', '2020-08-09');
INSERT INTO Client VALUES (2, 'Gouvernement du Canada', '2021-05-12');

CREATE TABLE EntiteMobile (
	IdEntiteMobile NUMERIC(10),
	Nom VARCHAR(10),
	TypeEntite VARCHAR(30),
	Ref_Lat DECIMAL(8,6),
	Ref_Long DECIMAL(9,6),
	Ref_Date DATETIME,
	FOREIGN KEY (Ref_Lat, Ref_Long, Ref_Date) REFERENCES Position (Latitude, Longitude, DatePosition) ON DELETE CASCADE,
	CONSTRAINT pkentite PRIMARY KEY (IdEntiteMobile)
);

INSERT INTO EntiteMobile VALUES (1, 'Boeing', 'Avion', 45.5017, 73.5673, '2020-08-08 13:30:40');
INSERT INTO EntiteMobile VALUES (2, 'Boeing', 'Avion', 45.3518, 75.6847, '2020-08-08 13:59:51');
INSERT INTO EntiteMobile VALUES (3, 'Boeing', 'Avion', 45.2793, 77.7290, '2020-08-08 14:20:30');
INSERT INTO EntiteMobile VALUES (4, 'Boeing', 'Avion', 44.9635, 79.7712, '2020-08-08 14:40:21');
INSERT INTO EntiteMobile VALUES (5, 'Boeing', 'Avion', 43.6532, 79.3832, '2020-08-08 15:02:39');
INSERT INTO EntiteMobile VALUES (6, 'Boatz', 'Bateau', 31.2304, 121.4737, '2021-04-12 05:30:59');
INSERT INTO EntiteMobile VALUES (7, 'Boatz', 'Bateau', 38.0485, 132.0353, '2021-04-20 08:44:31');
INSERT INTO EntiteMobile VALUES (8, 'Boatz', 'Bateau', 43.6308, 141.7547, '2021-04-28 10:20:13');
INSERT INTO EntiteMobile VALUES (9, 'Boatz', 'Bateau', 50.4045, 147.6037, '2021-05-06 06:41:39');
INSERT INTO EntiteMobile VALUES (10, 'Boatz', 'Bateau', 49.2812, 123.1208, '2021-05-11 14:01:00');


CREATE TABLE Adoption (
	IdAdoption NUMERIC(10),
	IdClient NUMERIC(10),
	FOREIGN KEY (IdClient) REFERENCES Client (IdClient) ON DELETE CASCADE,
	IdEntiteMobile NUMERIC(10),
	FOREIGN KEY (IdEntiteMobile) REFERENCES EntiteMobile (IdEntiteMobile) ON DELETE CASCADE,
	CONSTRAINT pkadoption PRIMARY KEY (IdAdoption)
);

INSERT INTO Adoption VALUES (1,1,1);
INSERT INTO Adoption VALUES (2,1,2);
INSERT INTO Adoption VALUES (3,1,3);
INSERT INTO Adoption VALUES (4,1,3);
INSERT INTO Adoption VALUES (5,1,5);
INSERT INTO Adoption VALUES (6,2,6);
INSERT INTO Adoption VALUES (7,2,7);
INSERT INTO Adoption VALUES (8,2,8);
INSERT INTO Adoption VALUES (9,2,9);
INSERT INTO Adoption VALUES (10,2,10);



SELECT DISTINCT Client.IdClient, Client.Nom, EntiteMobile.Nom As Nom_Entite
FROM EntiteMobile
INNER JOIN Adoption ON Adoption.IdEntiteMobile = EntiteMobile.IdEntiteMobile
INNER JOIN Client ON Client.IdClient = Adoption.IdClient;

SELECT DISTINCT EntiteMobile.Nom, STRING_AGG(TypeClimat, ', ') 
FROM Position
INNER JOIN Climat ON Position.Ref_Climat = Climat.TypeClimat
INNER JOIN EntiteMobile ON EntiteMobile.Ref_Lat = Position.Latitude
GROUP BY EntiteMobile.Nom;

SELECT EntiteMobile.Nom, STRING_AGG(CONVERT(varchar,Ref_Lat) + '; ' + CONVERT(varchar,Ref_Long), '---->') As Positions
FROM EntiteMobile
GROUP BY EntiteMobile.Nom;

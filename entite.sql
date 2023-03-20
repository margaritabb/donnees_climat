-- CREATE DATABASE entite;
-- drop database entite;

USE entite;

DROP TABLE if exists Adoption;
DROP TABLE if exists EntiteMobile;
DROP TABLE if exists Client;
DROP TABLE if exists Climat;
DROP TABLE if exists Position;

CREATE TABLE Client (
	IdClient NUMERIC(10),
	Nom VARCHAR(30),
	DateAdoption DATE,
	CONSTRAINT pkclient PRIMARY KEY (IdClient)
);

CREATE TABLE Climat (
	request_datetime INT,
    latitude NUMERIC(30),	
    longidude NUMERIC(30),
    date_meteo DATETIME,	
    humidity NUMERIC(10),
    precip NUMERIC(10),
	windgust NUMERIC(10),
    windspeed NUMERIC(10),
    winddir NUMERIC(10), 
    cloudcover NUMERIC(10),
    visibility NUMERIC(10),
    CONSTRAINT pkclimat PRIMARY KEY (request_datetime, latitude, longidude)
);


CREATE TABLE Position (
    IdEntiteMobile VARCHAR(10),
    request_datetime INT,
    latitude NUMERIC(30),	
    longidude NUMERIC(30),
	CONSTRAINT pkposition PRIMARY KEY (IdEntiteMobile, request_datetime, latitude, longidude),
    FOREIGN KEY (request_datetime, latitude, longidude) REFERENCES Climat (request_datetime, latitude, longidude) ON DELETE CASCADE
);


CREATE TABLE EntiteMobile (
	IdEntiteMobile VARCHAR(10),
	TypeEntite VARCHAR(30),
	CONSTRAINT pkentite PRIMARY KEY (IdEntiteMobile)
);

CREATE TABLE Adoption (
	IdClient NUMERIC(10),
	FOREIGN KEY (IdClient) REFERENCES Client (IdClient) ON DELETE CASCADE,
	IdEntiteMobile VARCHAR(10),
	CONSTRAINT pkadoption PRIMARY KEY (IdClient, IdEntiteMobile),
    FOREIGN KEY (IdEntiteMobile) REFERENCES EntiteMobile (IdEntiteMobile) ON DELETE CASCADE,
);

INSERT INTO EntiteMobile (IdEntiteMobile, TypeEntite)
VALUES ('AC1322', 'Avion'),
       ('AC35', 'Avion'),
       ('AC39', 'Avion'),
       ('AC33', 'Avion'),
       ('AC7', 'Avion'),
       ('AC10', 'Avion'),
       ('AC64', 'Avion'),
       ('AC4', 'Avion'),
       ('AC25', 'Avion'),
       ('AC887', 'Avion'),
       ('AC6', 'Avion'),
       ('AC81', 'Avion'),
       ('AC893', 'Avion'),
       ('AC62', 'Avion'),
       ('AC873', 'Avion'),
       ('AC856', 'Avion'),
       ('AC827', 'Avion'),
       ('AC877', 'Avion'),
       ('AC835', 'Avion'),
       ('AC855', 'Avion'),
       ('AC937', 'Avion'),
       ('AC997', 'Avion'),
       ('AC881', 'Avion'),
       ('AC849', 'Avion'),
       ('AC885', 'Avion'),
       ('AC871', 'Avion'),
       ('AC1325', 'Avion'),
       ('AC954', 'Avion'),
       ('AC1093', 'Avion'),
       ('AC540', 'Avion'),
       ('AC737', 'Avion'),
       ('AC857', 'Avion'),
       ('AC775', 'Avion'),
       ('AC1200', 'Avion'),
       ('AC193', 'Avion'),
       ('AC7210', 'Avion'),
       ('AC999', 'Avion'),
       ('AC926', 'Avion'),
       ('AC100', 'Avion'),
       ('AC1278', 'Avion'),
       ('AC948', 'Avion'),
       ('AC105', 'Avion'),
       ('AC1332', 'Avion'),
       ('AC980', 'Avion');

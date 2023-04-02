--Historique des positions (Fonction)
   GO
   CREATE OR ALTER FUNCTION choix_position (@flight_nbr varchar(10), @choix varchar(10))
   RETURNS @choix_position
   TABLE (flight_nbr VARCHAR(10),
       flight_time INT,
       latitude FLOAT(30),
       longitude FLOAT(30))
   AS
   BEGIN
       IF (@choix = 'historique')
       BEGIN
           INSERT @choix_position
               SELECT * FROM Position
               WHERE flight_nbr = @flight_nbr;
       END;
       ELSE IF (@choix = 'derniere')
       BEGIN
           INSERT @choix_position
               SELECT * FROM Position
               WHERE flight_nbr = @flight_nbr AND
               flight_time = (SELECT MAX(flight_time) FROM Position WHERE flight_nbr = @flight_nbr)
       END;
       RETURN;
   END;
   GO

-- On teste la fonction
SELECT * FROM choix_position('AC120', 'historique');
SELECT * FROM choix_position('AC120', 'derniere');

--Lorsqu'on ajoute ou modifie un vol, il faut que le nom du vol commence par «AC» (Trigger)
go
   CREATE TRIGGER tr_add_new_flight
   ON EntiteMobile
       FOR INSERT
       AS
       BEGIN
       DECLARE @flight_nbr VARCHAR(10)
       SELECT @flight_nbr = flight_nbr
       FROM INSERTED
  
       IF LEFT(@flight_nbr, 2) != 'AC'
       BEGIN
           PRINT 'Le numéro de vol doit commencer par AC';
           ROLLBACK TRANSACTION
           RETURN
       END
   END
  
go

-- on teste le trigger
go
INSERT INTO EntiteMobile (flight_nbr, flight_origin, flight_destin) VALUES
('ZZ777', 'YYZ', 'ICN');
go
go
INSERT INTO EntiteMobile (flight_nbr, flight_origin, flight_destin) VALUES
('AC646', 'YUL', 'SEA');
go

--Curseur qui permet d'afficher le type de client

go
CREATE OR ALTER PROCEDURE afficher_type_client
AS
BEGIN
   -- Déclaration des variables locales à la procédure
   DECLARE @nom VARCHAR(50), @type VARCHAR(30);


   -- Déclaration du curseur avec l'ensemble des noms et types de tous les clients
   DECLARE type_client CURSOR FOR
   SELECT Nom, TypeClient
   FROM Client;


   -- Ouverture du curseur
   OPEN type_client;


   -- Itération à travers tous les clients de la table Client
   FETCH NEXT FROM type_client INTO @nom, @type;
   WHILE @@FETCH_STATUS = 0
   BEGIN


       --Affichage de résultats avec une instruction IF
       IF(@type = 'Corporation')
           print 'Le client ' + @nom + ' est une corporation';
       -- Sinon, l'employé participe à un ou plusieurs projets
       ELSE IF(@type = 'Membre du public')
           print 'Le client ' + @nom + ' est un membre du public';
       ELSE IF(@type = 'Gouvernement')
           print 'Le client ' + @nom + ' est le gouvernement';


       -- Passage au client suivant
       FETCH NEXT FROM type_client INTO @nom, @type;
   END;


   -- Fermeture du curseur et libération de la mémoire
   CLOSE type_client;
   DEALLOCATE type_client;
END;
GO


-- On teste notre procédure
EXEC afficher_type_client;

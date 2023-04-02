-- infos de la table EntiteMobile
 SELECT * FROM EntiteMobile ORDER BY flight_nbr;


-- infos de la table Client
 SELECT * FROM Client;


-- nombre d'entités suivies pour chaque client
 SELECT c.Nom, COUNT(DISTINCT a.flight_nbr) AS NombreEntites, STRING_AGG(e.flight_nbr, ',') AS NumerosEntites
 FROM Client c
 LEFT JOIN Adoption a ON c.IdClient = a.IdClient
 LEFT JOIN EntiteMobile e ON a.flight_nbr = e.flight_nbr
 LEFT JOIN Climat cl ON e.flight_nbr = cl.flight_nbr
 GROUP BY c.Nom;


-- associer chaque client avec une entité qui traversent un climat dont le windspeed est supérieur à 40
 SELECT c.Nom, em.flight_nbr, cl.windspeed
 FROM Client c
 INNER JOIN Adoption a ON c.IdClient = a.IdClient
 INNER JOIN EntiteMobile em ON a.flight_nbr = em.flight_nbr
 INNER JOIN Climat cl ON em.flight_nbr = cl.flight_nbr
 INNER JOIN Position p ON cl.flight_nbr = p.flight_nbr AND cl.request_datetime = p.flight_time
 WHERE cl.windspeed > 40;


-- noms des entités qui traversent un climat dont le windspeed est inférieur à 20
 SELECT DISTINCT EntiteMobile.flight_nbr, EntiteMobile.flight_origin, EntiteMobile.flight_destin, Climat.windspeed
 FROM EntiteMobile
 INNER JOIN Position ON EntiteMobile.flight_nbr = Position.flight_nbr
 INNER JOIN Climat ON Position.flight_nbr = Climat.flight_nbr AND Position.flight_time = Climat.request_datetime
 WHERE Climat.windspeed < 20;


-- dernière position disponible du vol, avec/sans climat
 SELECT c.*
 FROM Climat c
 INNER JOIN (
     SELECT flight_nbr, MAX(flight_time) AS max_date
     FROM Position
     GROUP BY flight_nbr
 ) AS latest_position ON c.flight_nbr = latest_position.flight_nbr
                        AND c.request_datetime = latest_position.max_date
 INNER JOIN Position p ON c.flight_nbr = p.flight_nbr
                        AND c.request_datetime = p.flight_time


--Droit d'accès
   SELECT
   DISTINCT c.IdClient,
   c.Nom,
   CASE WHEN a.flight_nbr IS NULL THEN 'Non' ELSE 'Oui' END AS "Droit d'accès"
   FROM
       Client c
   LEFT JOIN
       Adoption a ON c.IdClient = a.IdClient
   GROUP BY c.IdClient, c.Nom, a.flight_nbr;


--Moyenne pour la vitesse de vent < 10
   SELECT AVG(windspeed) AS avg_windspeed
   FROM Climat 
   WHERE Climat.windspeed < 10;


--Entités qui passent par un climat dont le windspeed est < 20
   SELECT DISTINCT EntiteMobile.flight_nbr, EntiteMobile.flight_origin, EntiteMobile.flight_destin
   FROM EntiteMobile
   INNER JOIN Position ON EntiteMobile.flight_nbr = Position.flight_nbr
   INNER JOIN Climat ON Position.flight_nbr = Climat.flight_nbr AND Position.flight_time = Climat.request_datetime
   WHERE Climat.windspeed < 20


--Nom des clients dont le type est «membre du public» et qui possèdent une entité avec flight_nbr de plus de trois chiffres
   SELECT DISTINCT c.Nom
   FROM Client c
   INNER JOIN Adoption a ON c.IdClient = a.IdClient
   INNER JOIN EntiteMobile em ON a.flight_nbr = em.flight_nbr
   WHERE c.TypeClient = 'Membre du public' AND em.flight_nbr LIKE '%[0-9][0-9][0-9][0-9]%'

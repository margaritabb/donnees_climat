Idées de requêtes:

**- Droit d'accès pour un client**

  `SELECT
    c.IdClient,
    c.Nom,
    c.DateAdoption,
    CASE WHEN a.IdEntiteMobile IS NULL THEN 'Non' ELSE 'Oui' END AS "Droit d'accès"
  FROM
      Client c
  LEFT JOIN
      Adoption a ON c.IdClient = a.IdClient;`

**- nombre d'entités suivies pour chaque client**

  `SELECT c.Nom, COUNT(DISTINCT a.flight_nbr) AS NombreEntites, STRING_AGG(e.flight_nbr, ',') AS NumerosEntites
  FROM Client c
  LEFT JOIN Adoption a ON c.IdClient = a.IdClient
  LEFT JOIN EntiteMobile e ON a.flight_nbr = e.flight_nbr
  LEFT JOIN Climat cl ON e.flight_nbr = cl.flight_nbr
  GROUP BY c.Nom;`



**- associes chaque client avec une entité qui traversent un climat dont le windspeed est supérieur à 40**

  `SELECT c.Nom, em.flight_nbr
  FROM Client c
  INNER JOIN Adoption a ON c.IdClient = a.IdClient
  INNER JOIN EntiteMobile em ON a.flight_nbr = em.flight_nbr
  INNER JOIN Climat cl ON em.flight_nbr = cl.flight_nbr
  INNER JOIN Position p ON cl.flight_nbr = p.flight_nbr AND cl.request_datetime = p.flight_time
  WHERE cl.windspeed > 40;

  
**- moyenne température, autres stats descriptives (min, max, etc.)**

  SELECT AVG(pm.windspeed) AS avg_windspeed
  FROM Position pm
  INNER JOIN Climat cm ON pm.request_datetime = cm.request_datetime
      AND pm.latitude = cm.latitude 
      AND pm.longidude = cm.longidude
  WHERE cm.windspeed < 10;`
  
**- dernière position disponible du vol, avec/sans climat**

  `SELECT c.*, p.latitude, p.longitude 
  FROM Climat c 
  INNER JOIN (
      SELECT flight_nbr, MAX(request_datetime) AS max_date 
      FROM Position 
      GROUP BY flight_nbr
  ) AS latest_position ON c.flight_nbr = latest_position.flight_nbr 
                         AND c.request_datetime = latest_position.max_date
  INNER JOIN Position p ON c.flight_nbr = p.flight_nbr 
                         AND c.request_datetime = p.flight_time`

- historique des positions, avec/sans climat
- climat infos simples vs détaillées
- si entité n'existe pas, afficher un message d'erreur

**- somme des clients pour chaque entité qui ne passe pas par un climat tropical**

  `SELECT EntiteMobile.flight_nbr, EntiteMobile.flight_origin, EntiteMobile.flight_destin, SUM(CASE WHEN Climat.windspeed > 20 THEN 1 ELSE 0 END) AS TotalClients
  FROM EntiteMobile 
  INNER JOIN Adoption ON EntiteMobile.flight_nbr = Adoption.flight_nbr 
  INNER JOIN Client ON Adoption.IdClient = Client.IdClient 
  INNER JOIN Position ON EntiteMobile.flight_nbr = Position.flight_nbr 
  INNER JOIN Climat ON Position.flight_nbr = Climat.flight_nbr AND Position.flight_time = Climat.request_datetime 
  GROUP BY EntiteMobile.flight_nbr, EntiteMobile.flight_origin, EntiteMobile.flight_destin;`

  
**- noms des entités qui traversent un climat dont le windspeed est infrieur à 20**

  `SELECT DISTINCT EntiteMobile.flight_nbr, EntiteMobile.flight_origin, EntiteMobile.flight_destin
  FROM EntiteMobile 
  INNER JOIN Position ON EntiteMobile.flight_nbr = Position.flight_nbr 
  INNER JOIN Climat ON Position.flight_nbr = Climat.flight_nbr AND Position.flight_time = Climat.request_datetime 
  WHERE Climat.windspeed < 20;`
  
**- creer un trigger (par exemple: lorsqu'on met un jour un vol, il faut que le numero de vol commence par AC)**

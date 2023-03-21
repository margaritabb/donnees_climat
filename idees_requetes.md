Idées de requêtes:
- nombre d'entités suivies

- associes chaque client avec une entité qui traversent un climat dont le windspeed est supérieur à 40
  SELECT c.Nom, em.IdEntiteMobile
  FROM Client c
  INNER JOIN Adoption a ON c.IdClient = a.IdClient
  INNER JOIN EntiteMobile em ON a.IdEntiteMobile = em.IdEntiteMobile
  INNER JOIN Position p ON em.IdEntiteMobile = p.IdEntiteMobile
  INNER JOIN Climat cl ON p.request_datetime = cl.request_datetime AND p.latitude = cl.latitude AND p.longidude = cl.longidude
  WHERE cl.windspeed > 40
  ORDER BY c.Nom, em.IdEntiteMobile;

Cette requête utilise les jointures INNER JOIN pour récupérer les informations de toutes les tables nécessaires. Ensuite, nous avons ajouté la clause WHERE pour filtrer les résultats en fonction du windspeed. Enfin, nous avons trié les résultats par ordre croissant du client, puis par ordre croissant de l'entité mobile.

  
- moyenne température, autres stats descriptives (min, max, etc.)
- dernière position disponible du vol, avec/sans climat
- historique des positions, avec/sans climat
- climat infos simples vs détaillées
- si entité n'existe pas, afficher un message d'erreur

- somme des clients pour chaque entité qui ne passe pas par un climat tropical
  SELECT EntiteMobile.IdEntiteMobile, COUNT(DISTINCT Client.IdClient) AS NbClients
  FROM EntiteMobile
  INNER JOIN Adoption ON EntiteMobile.IdEntiteMobile = Adoption.IdEntiteMobile
  INNER JOIN Client ON Adoption.IdClient = Client.IdClient
  WHERE NOT EXISTS (
      SELECT *
      FROM Climat
      INNER JOIN Position ON Climat.request_datetime = Position.request_datetime AND Climat.latitude = Position.latitude AND Climat.longidude = Position.longidude
      WHERE Position.IdEntiteMobile = EntiteMobile.IdEntiteMobile AND Climat.windspeed < 20
  )
  GROUP BY EntiteMobile.IdEntiteMobile
  ORDER BY NbClients DESC;
  
- noms des entités qui traversent un climat dont le windspeed est infrieur à 20
  SELECT DISTINCT em.Nom
  FROM EntiteMobile em
  JOIN Adoption a ON em.IdEntiteMobile = a.IdEntiteMobile
  JOIN Position p ON a.IdEntiteMobile = p.IdEntiteMobile
  JOIN Climat c ON p.request_datetime = c.request_datetime AND p.latitude = c.latitude AND p.longidude = c.longidude
  WHERE c.windspeed < 20;
  
- creer un trigger (par exemple: lorsqu'on met un jour un vol, il faut que le numero de vol commence par AC)

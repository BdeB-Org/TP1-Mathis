-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom: Douangpanya Mathis || Votre DA: 6229633 
--ASSUREZ VOUS DE LA BONNE LISIBILIES DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2

-- Pour OUTILS_USAGER
DESCRIBE OUTILS_USAGER;
-- Pour OUTILS_OUTIL
DESCRIBE OUTILS_OUTIL;
-- Pour OUTILS_EMPRUNT
DESCRIBE OUTILS_EMPRUNT;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2

SELECT CONCAT(prenom, ' ', nom_famille) AS "Nom Complet" FROM OUTILS_USAGER;

-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2

SELECT DISTINCT ville FROM OUTILS_USAGER ORDER BY ville;

-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2

SELECT * FROM outils_outil ORDER BY nom, code_outil;

-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2

SELECT num_emprunt FROM outils_emprunt WHERE date_retour IS NULL;

-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3

SELECT num_emprunt FROM outils_emprunt WHERE EXTRACT(YEAR FROM date_emprunt) < 2014;

-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3

SELECT nom, code_outil FROM outils_outil WHERE UPPER(caracteristiques) LIKE 'J%';

-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2

SELECT nom, code_outil FROM outils_outil WHERE fabricant = 'Stanley';

-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2

SELECT nom, fabricant FROM outils_outil WHERE annee BETWEEN 2006 AND 2008;

-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3

SELECT code_outil, nom FROM outils_outil WHERE caracteristiques NOT LIKE '%20 volt%';

-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2

SELECT COUNT(*) FROM OUTILS_OUTIL WHERE fabricant != 'Makita';

-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5

SELECT u.prenom || ' ' || u.nom_famille AS "Nom complet", e.num_emprunt, e.date_emprunt, e.date_retour, COALESCE(o.prix, 0) AS "Prix"
FROM outils_emprunt e
JOIN outils_usager u ON e.num_usager = u.num_usager
JOIN outils_outil o ON e.code_outil = o.code_outil
WHERE u.ville IN ('Vancouver', 'Regina');

-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4

SELECT o.nom, o.code_outil
FROM outils_outil o
JOIN outils_emprunt e ON o.code_outil = e.code_outil
WHERE e.date_retour IS NULL;

-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3

SELECT u.nom_famille, u.prenom, u.courriel 
FROM outils_usager u 
WHERE NOT EXISTS (
    SELECT 1 
    FROM outils_emprunt e 
    WHERE e.num_usager = u.num_usager
);

-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4

SELECT o.code_outil, COALESCE(o.prix, 0) AS "Prix"
FROM outils_outil o
LEFT OUTER JOIN outils_emprunt e ON o.code_outil = e.code_outil
WHERE e.code_outil IS NULL;

-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4

SELECT o.nom, COALESCE(o.prix, (SELECT AVG(prix) FROM outils_outil)) AS "Prix"
FROM outils_outil o
WHERE o.fabricant = 'Makita' AND o.prix > (SELECT AVG(prix) FROM outils_outil);

-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4

SELECT u.nom_famille, u.prenom, u.adresse, o.nom, o.code_outil
FROM outils_usager u
JOIN outils_emprunt e ON u.num_usager = e.num_usager
JOIN outils_outil o ON e.code_outil = o.code_outil
WHERE EXTRACT(YEAR FROM e.date_emprunt) > 2014
ORDER BY u.nom_famille;

-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4

SELECT o.nom, o.prix
FROM outils_outil o
JOIN outils_emprunt e ON o.code_outil = e.code_outil
GROUP BY o.nom, o.prix
HAVING COUNT(e.code_outil) > 1;

-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6


--  Une jointure

SELECT DISTINCT u.nom_famille, u.prenom, u.adresse, u.ville
FROM outils_usager u
INNER JOIN outils_emprunt e ON u.num_usager = e.num_usager;

--  IN

SELECT nom_famille, prenom, adresse, ville 
FROM outils_usager 
WHERE num_usager IN (SELECT num_usager FROM outils_emprunt);

--  EXISTS

SELECT nom_famille, prenom, adresse, ville 
FROM outils_usager u
WHERE EXISTS (SELECT 1 FROM outils_emprunt e WHERE u.num_usager = e.num_usager);

-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3

SELECT fabricant, AVG(prix) AS "Moyenne du Prix"
FROM outils_outil
GROUP BY fabricant;

-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4

SELECT u.ville, SUM(o.prix) AS "Somme des Prix"
FROM outils_usager u
JOIN outils_emprunt e ON u.num_usager = e.num_usager
JOIN outils_outil o ON e.code_outil = o.code_outil
GROUP BY u.ville
ORDER BY "Somme des Prix" DESC;

-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2

SELECT u.ville, SUM(o.prix) AS "Somme des Prix"
FROM outils_usager u
JOIN outils_emprunt e ON u.num_usager = e.num_usager
JOIN outils_outil o ON e.code_outil = o.code_outil
GROUP BY u.ville
ORDER BY "Somme des Prix" DESC;

-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2

INSERT INTO outils_outil (code_outil, nom, annee)
VALUES ('code_nouveau_outil2', 'Nom du nouvel outil 2', 2024);

-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2

DELETE FROM outils_outil WHERE code_outil IN ('code_nouveau_outil', 'code_nouveau_outil2');

-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2

UPDATE outils_usager SET nom_famille = UPPER(nom_famille);

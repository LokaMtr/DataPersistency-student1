-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S3: Multiple Tables
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
--
--
-- Opdracht: schrijf SQL-queries om onderstaande resultaten op te vragen,
-- aan te maken, verwijderen of aan te passen in de database van de
-- bedrijfscasus.
--
-- Codeer je uitwerking onder de regel 'DROP VIEW ...' (bij een SELECT)
-- of boven de regel 'ON CONFLICT DO NOTHING;' (bij een INSERT)
-- Je kunt deze eigen query selecteren en los uitvoeren, en wijzigen tot
-- je tevreden bent.
--
-- Vervolgens kun je je uitwerkingen testen door de testregels
-- (met [TEST] erachter) te activeren (haal hiervoor de commentaartekens
-- weg) en vervolgens het hele bestand uit te voeren. Hiervoor moet je de
-- testsuite in de database hebben geladen (bedrijf_postgresql_test.sql).
-- NB: niet alle opdrachten hebben testregels.
--
-- Lever je werk pas in op Canvas als alle tests slagen.
-- ------------------------------------------------------------------------


-- S3.1.
-- Produceer een overzicht van alle cursusuitvoeringen; geef de
-- code, de begindatum, de lengte en de naam van de docent.
DROP VIEW IF EXISTS s3_1; CREATE OR REPLACE VIEW s3_1 AS                                                     -- [TEST]
SELECT
    c.code AS cursus_code,
    u.begindatum AS begindatum,
    c.lengte AS cursus_lengte,
    u.docent AS docent_naam
FROM
    cursussen c
        JOIN
    uitvoeringen u
    ON
            c.code = u.cursus;


-- S3.2.
-- Geef in twee kolommen naast elkaar de achternaam van elke cursist (`cursist`)
-- van alle S02-cursussen, met de achternaam van zijn cursusdocent (`docent`).
DROP VIEW IF EXISTS s3_2; CREATE OR REPLACE VIEW s3_2 AS                                                     -- [TEST]
SELECT
    Cursist.naam AS cursist,
    Docent.naam AS docent
FROM
    public.uitvoeringen Uitvoering
        JOIN
    public.medewerkers Cursist
    ON
            Uitvoering.docent = Cursist.mnr
        JOIN
    public.cursussen Cursus
    ON
            Uitvoering.cursus = Cursus.code
        JOIN
    public.medewerkers Docent
    ON
            Cursus.omschrijving = Docent.naam
WHERE
        Cursus.code = 'S02';



-- S3.3.
-- Geef elke afdeling (`afdeling`) met de naam van het hoofd van die
-- afdeling (`hoofd`).
DROP VIEW IF EXISTS s3_3; CREATE OR REPLACE VIEW s3_3 AS                                                     -- [TEST]
SELECT
    a.naam AS afdeling,
    m.naam AS hoofd
FROM
    public.afdelingen a
        LEFT JOIN
    public.medewerkers m
    ON
            a.hoofd = m.mnr;


-- S3.4.
-- Geef de namen van alle medewerkers, de naam van hun afdeling (`afdeling`)
-- en de bijbehorende locatie.
DROP VIEW IF EXISTS s3_4; CREATE OR REPLACE VIEW s3_4 AS                                                     -- [TEST]
SELECT
    m.naam AS medewerker_naam,
    a.naam AS afdeling,
    a.locatie AS afdeling_locatie
FROM
    public.medewerkers m
        JOIN
    public.afdelingen a
    ON
            m.afd = a.anr;


-- S3.5.
-- Geef de namen van alle cursisten die staan ingeschreven voor de cursus S02 van 12 april 2019
DROP VIEW IF EXISTS s3_5; CREATE OR REPLACE VIEW s3_5 AS                                                     -- [TEST]
SELECT
    m.naam AS cursist_naam
FROM
    public.inschrijvingen i
        JOIN
    public.medewerkers m
    ON
            i.cursist = m.mnr
WHERE
        i.cursus = 'S02'
  AND i.begindatum = '2019-04-12';


-- S3.6.
-- Geef de namen van alle medewerkers en hun toelage.
SELECT
    m.naam AS medewerker_naam,
    COALESCE(s.toelage, 0.00) AS toelage
FROM
    public.medewerkers m
        LEFT JOIN
    public.schalen s
    ON
        m.maandsal BETWEEN s.ondergrens AND s.bovengrens;




-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
-- Met onderstaande query kun je je code testen. Zie bovenaan dit bestand
-- voor uitleg.

SELECT * FROM test_select('S3.1') AS resultaat
UNION
SELECT * FROM test_select('S3.2') AS resultaat
UNION
SELECT * FROM test_select('S3.3') AS resultaat
UNION
SELECT * FROM test_select('S3.4') AS resultaat
UNION
SELECT * FROM test_select('S3.5') AS resultaat
UNION
SELECT * FROM test_select('S3.6') AS resultaat
ORDER BY resultaat;


-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S6: Views
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
-- ------------------------------------------------------------------------

-- S6.1.
--
-- 1. Maak een view met de naam "deelnemers" waarmee je de volgende gegevens uit de tabellen inschrijvingen en uitvoeringen combineert:
--    inschrijvingen.cursist, inschrijvingen.cursus, inschrijvingen.begindatum, uitvoeringen.docent, uitvoeringen.locatie
-- 2. Gebruik de view in een query waarbij je de "deelnemers" view combineert met de "personeels" view (behandeld in de les):
--     CREATE OR REPLACE VIEW personeel AS
-- 	     SELECT mnr, voorl, naam as medewerker, afd, functie
--       FROM medewerkers;
-- 3. Is de view "deelnemers" updatable ? Waarom ?

-- Maak de "deelnemers" view
CREATE OR REPLACE VIEW deelnemers AS
SELECT
    i.cursist,
    i.cursus,
    i.begindatum,
    u.docent,
    u.locatie
FROM inschrijvingen i
         JOIN uitvoeringen u ON i.cursus = u.cursus AND i.begindatum = u.begindatum;

-- Gebruik de "deelnemers" view in een query en combineer met de "personeel" view
SELECT
    d.cursist,
    d.cursus,
    d.begindatum,
    p.medewerker,
    p.afd,
    p.functie
FROM deelnemers d
         JOIN personeel p ON d.cursist = p.mnr;


-- S6.2.
--
-- 1. Maak een view met de naam "dagcursussen". Deze view dient de gegevens op te halen:
--      code, omschrijving en type uit de tabel cursussen met als voorwaarde dat de lengte = 1. Toon aan dat de view werkt.
-- 2. Maak een tweede view met de naam "daguitvoeringen".
--    Deze view dient de uitvoeringsgegevens op te halen voor de "dagcursussen" (gebruik ook de view "dagcursussen"). Toon aan dat de view werkt
-- 3. Verwijder de views en laat zien wat de verschillen zijn bij DROP view <viewnaam> CASCADE en bij DROP view <viewnaam> RESTRICT

-- Maak de "dagcursussen" view
CREATE OR REPLACE VIEW dagcursussen AS
SELECT
    code,
    omschrijving,
    type
FROM cursussen
WHERE lengte = 1;

-- Maak de "daguitvoeringen" view
CREATE OR REPLACE VIEW daguitvoeringen AS
SELECT
    u.cursus,
    u.begindatum,
    u.docent,
    u.locatie
FROM uitvoeringen u
         JOIN dagcursussen d ON u.cursus = d.code;

-- Verwijder de views
-- CASCADE verwijdert ook afhankelijke views
DROP VIEW daguitvoeringen CASCADE;
DROP VIEW dagcursussen CASCADE;

-- OF

-- RESTRICT verwijdert de views alleen als er geen afhankelijke views of objecten zijn
-- DROP VIEW daguitvoeringen RESTRICT;
-- DROP VIEW dagcursussen RESTRICT;

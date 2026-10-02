-- =============================================
-- PROJET DÉTECTION DE FRAUDE
-- Analyse SQL - Credit Card Fraud Detection
-- =============================================

-- REQUÊTE 1 : Vue globale fraude vs normal
SELECT 
    CASE WHEN Class = 0 THEN 'Normal' ELSE 'Fraude' END AS type_transaction,
    COUNT(*) AS nombre,
    ROUND(AVG(Amount), 2) AS montant_moyen,
    ROUND(MIN(Amount), 2) AS montant_min,
    ROUND(MAX(Amount), 2) AS montant_max,
    ROUND(SUM(Amount), 2) AS montant_total
FROM transactions
GROUP BY Class;

-- REQUÊTE 2 : Tranches de montants frauduleux
SELECT 
    CASE 
        WHEN Amount < 10 THEN '< 10€'
        WHEN Amount < 50 THEN '10€ - 50€'
        WHEN Amount < 100 THEN '50€ - 100€'
        WHEN Amount < 500 THEN '100€ - 500€'
        ELSE '> 500€'
    END AS tranche_montant,
    COUNT(*) AS nb_fraudes,
    ROUND(AVG(Amount), 2) AS montant_moyen
FROM transactions
WHERE Class = 1
GROUP BY tranche_montant
ORDER BY nb_fraudes DESC;

-- REQUÊTE 3 : Fraudes par période de la journée
SELECT 
    CASE 
        WHEN (Time % 86400) < 21600 THEN '00h-06h (Nuit)'
        WHEN (Time % 86400) < 43200 THEN '06h-12h (Matin)'
        WHEN (Time % 86400) < 64800 THEN '12h-18h (Après-midi)'
        ELSE '18h-24h (Soir)'
    END AS periode,
    COUNT(*) AS nb_fraudes,
    ROUND(AVG(Amount), 2) AS montant_moyen
FROM transactions
WHERE Class = 1
GROUP BY periode
ORDER BY nb_fraudes DESC;

-- REQUÊTE 4 : Impact financier des fraudes
SELECT 
    ROUND(SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END), 2) AS pertes_fraude,
    ROUND(SUM(CASE WHEN Class = 0 THEN Amount ELSE 0 END), 2) AS volume_normal,
    ROUND(SUM(Amount), 2) AS volume_total,
    ROUND(SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END) * 100.0 / SUM(Amount), 4) AS pct_pertes
FROM transactions;

-- REQUÊTE 5 : Top 10 fraudes les plus coûteuses
SELECT 
    ROUND(Amount, 2) AS montant,
    ROUND(Time / 3600, 1) AS heure,
    V1, V2, V3
FROM transactions
WHERE Class = 1
ORDER BY Amount DESC
LIMIT 10;
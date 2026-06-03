/*====================================================
    DECODING TAMIL NADU ASSEMBLY ELECTION 2026 ANALYSIS
    Author  : Ranjith A R
    Project : Codebasics Resume Project Challenge 2026
====================================================*/

USE tamil_nadu_election;

/*====================================================
    DATA VALIDATION
====================================================*/

-- Total Records in Constituency Master

SELECT COUNT(*) AS total_constituencies
FROM constituency_master;

-- Total Records in 2021 Election Dataset

SELECT COUNT(*) AS total_records_2021
FROM tn_2021_results;

-- Total Records in 2026 Election Dataset

SELECT COUNT(*) AS total_records_2026
FROM tn_2026_results;


/*====================================================
    QUERY 1 : TOTAL VOTES BY PARTY (2026)
    Objective:
    Identify parties with the highest vote count.
====================================================*/

SELECT
    party,
    SUM(votes) AS total_votes
FROM tn_2026_results
GROUP BY party
ORDER BY total_votes DESC;


/*====================================================
    QUERY 2 : SEATS WON BY PARTY (2026)
    Objective:
    Determine Assembly seat distribution.
====================================================*/

WITH winners AS (
    SELECT
        constituency,
        party,
        votes,
        ROW_NUMBER() OVER (
            PARTITION BY constituency
            ORDER BY votes DESC
        ) AS rn
    FROM tn_2026_results
)
SELECT
    party,
    COUNT(*) AS seats_won
FROM winners
WHERE rn = 1
GROUP BY party
ORDER BY seats_won DESC;


/*====================================================
    QUERY 3 : TOP 10 LANDSLIDE VICTORIES
    Objective:
    Identify constituencies with highest vote counts.
====================================================*/

SELECT
    constituency,
    candidate,
    party,
    votes
FROM tn_2026_results
ORDER BY votes DESC
LIMIT 10;


/*====================================================
    QUERY 4 : AVERAGE TURNOUT BY REGION
    Objective:
    Compare voter participation across regions.
====================================================*/

SELECT
    region,
    ROUND(AVG(turnout), 2) AS avg_turnout
FROM tn_2026_results
GROUP BY region
ORDER BY avg_turnout DESC;


/*====================================================
    QUERY 5 : HIGHEST TURNOUT CONSTITUENCIES
    Objective:
    Find top 20 constituencies by turnout.
====================================================*/

SELECT
    constituency,
    region,
    turnout
FROM tn_2026_results
ORDER BY turnout DESC
LIMIT 20;


/*====================================================
    QUERY 6 : PARTY VOTE SHARE (%)
    Objective:
    Calculate vote share percentage by party.
====================================================*/

SELECT
    party,
    ROUND(
        SUM(votes) * 100.0 /
        (SELECT SUM(votes) FROM tn_2026_results),
        2
    ) AS vote_share_percent
FROM tn_2026_results
GROUP BY party
ORDER BY vote_share_percent DESC;


/*====================================================
    QUERY 7 : REGIONAL PARTY DOMINANCE
    Objective:
    Analyze seat wins across regions.
====================================================*/

WITH winners AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY constituency
               ORDER BY votes DESC
           ) AS rn
    FROM tn_2026_results
)
SELECT
    region,
    party,
    COUNT(*) AS seats_won
FROM winners
WHERE rn = 1
GROUP BY region, party
ORDER BY region, seats_won DESC;


/*====================================================
    QUERY 8 : RESERVED VS GENERAL SEATS
    Objective:
    Compare party performance in reserved seats.
====================================================*/

WITH winners AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY constituency
               ORDER BY votes DESC
           ) AS rn
    FROM tn_2026_results
)
SELECT
    reserved,
    party,
    COUNT(*) AS seats_won
FROM winners
WHERE rn = 1
GROUP BY reserved, party
ORDER BY reserved, seats_won DESC;


/*====================================================
    QUERY 9 : TOP 10 PARTIES BY TOTAL VOTES
    Objective:
    Rank parties by total votes received.
====================================================*/

SELECT
    party,
    SUM(votes) AS total_votes
FROM tn_2026_results
GROUP BY party
ORDER BY total_votes DESC
LIMIT 10;


/*====================================================
    QUERY 10 : CONSTITUENCY COUNT BY REGION
    Objective:
    Determine regional constituency distribution.
====================================================*/

SELECT
    region,
    COUNT(*) AS constituency_count
FROM constituency_master
GROUP BY region
ORDER BY constituency_count DESC;


/*====================================================
                    THE END
                    THANK YOU
====================================================*/
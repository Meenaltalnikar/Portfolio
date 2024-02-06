create database Portfolio;
use Portfolio;
select * from ipl_players;
select * from top_buys;
select * from unsold_players;

SELECT *
FROM ipl_players
left JOIN top_buys ON ipl_players.PLAYERS = top_buys.NATIONALITY
left JOIN unsold_players ON top_buys.NATIONALITY = unsold_players.PLAYER;

-- Q1  unsold Players count by Nationality 
SELECT NATIONALITY, COUNT(*) AS UNSOLD_PLAYERS_COUNT
FROM unsold_players
GROUP BY NATIONALITY;

-- Q2 Top 5 highest spenders
SELECT TEAM, SUM(`PRICE PAID`) AS TOTAL_SPENDING
FROM top_buys
GROUP BY TEAM
ORDER BY TOTAL_SPENDING DESC
LIMIT 5;

-- Q3 Average Base Price by Player type
SELECT TYPE, AVG('BASE PRICE') AS AVG_BASE_PRICE
FROM unsold_players
GROUP BY TYPE;

-- Q4 Top 5 Unsold Players with Highest Base Price
SELECT PLAYER, `BASE PRICE`
FROM unsold_players
ORDER BY `BASE PRICE` DESC
LIMIT 5;

-- Q5 Team Wise Player count
SELECT TEAM, COUNT(*) AS PLAYER_COUNT
FROM ipl_players
GROUP BY TEAM;

-- Q6 Teams That Spent Above Average
SELECT TEAM
FROM top_buys
WHERE `PRICE PAID` > (SELECT AVG(`PRICE PAID`) FROM top_buys);

-- Q7 Player Type Distribution In Unsold Players
SELECT TYPE, COUNT(*) AS TYPE_COUNT
FROM unsold_players
GROUP BY TYPE;

-- Q8 Highest Base Price by Team in Unsold Player
SELECT TYPE, COUNT(*) AS TYPE_COUNT
FROM unsold_players
GROUP BY TYPE; 

-- Q9 Players With Highest Price By Nationality in IPL Players
SELECT NATIONALITY,PLAYERS, `PRICE PAID`
FROM ipl_players
WHERE (NATIONALITY, `PRICE PAID`) IN (
    SELECT NATIONALITY, MAX(`PRICE PAID`) AS MAX_PRICE_PAID
    FROM ipl_players
    GROUP BY NATIONALITY
);

-- Q10 Most Expensive Player in each Team
SELECT a.TEAM, a.PLAYERS, a.`PRICE PAID` AS HIGHEST_PRICE_PAID
FROM ipl_players a
INNER JOIN (
    SELECT TEAM, MAX(`PRICE PAID`) AS MAX_PRICE
    FROM ipl_players
    GROUP BY TEAM
) b ON a.TEAM = b.TEAM AND a.`PRICE PAID` = b.MAX_PRICE;

-- Q11 Teams with a Balanced Distribution of Player Types:
SELECT TEAM
FROM (
  SELECT TEAM, TYPE, COUNT(*) AS COUNT_PER_TYPE,
         RANK() OVER (PARTITION BY TEAM ORDER BY COUNT(*) DESC) AS TYPE_RANK
  FROM ipl_players
  GROUP BY TEAM, TYPE
) AS subquery
GROUP BY TEAM
HAVING MAX(TYPE_RANK) - MIN(TYPE_RANK) <= 1;

-- Q12 Team With most Overspent Players
SELECT TEAM, COUNT(*) AS OVERSPENT_PLAYERS
FROM ipl_players
WHERE `PRICE PAID` > (SELECT AVG(`PRICE PAID`) FROM ipl_players) * 1.5
GROUP BY TEAM
ORDER BY OVERSPENT_PLAYERS DESC;



























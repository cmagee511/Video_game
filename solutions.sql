-- Select all information for the top ten best-selling games
-- Order the results from best-selling game down to tenth best-selling

SELECT *
FROM game_sales
ORDER BY games_sold DESC
LIMIT 10;

-- Join games_sales and reviews
-- Select a count of the number of games where both critic_score and user_score are null

SELECT
       COUNT(g.*)      
FROM game_sales as g
LEFT JOIN reviews as r
ON g.game = r.game
WHERE r.critic_score IS NULL 
      AND r.user_score IS NULL

-- Select release year and average critic score for each year, rounded and aliased
-- Join the game_sales and reviews tables
-- Group by release year
-- Order the data from highest to lowest avg_critic_score and limit to 10 results

SELECT g.year,
       ROUND(AVG(r.critic_score),2) as avg_critic_score
FROM game_sales as g
LEFT JOIN reviews as r
ON g.game = r.game
GROUP BY year
ORDER BY avg_critic_score DESC
Limit 10;

-- Update the query to add a count of games released in each year called num_games
-- Update the query so that it only returns years that have more than four reviewed games

SELECT g.year,
       ROUND(AVG(r.critic_score),2) as avg_critic_score,
       COUNT(g.game) as num_games
FROM game_sales as g
INNER JOIN reviews as r
ON g.game = r.game
GROUP BY year
HAVING  COUNT(g.game) > 4
ORDER BY avg_critic_score DESC
Limit 10;


-- Select the year and avg_critic_score for those years that dropped off the list of critic favorites 
-- Order the results from highest to lowest avg_critic_score

SELECT year,
       avg_critic_score
FROM top_critic_years
EXCEPT
SELECT year,
       avg_critic_score
FROM top_critic_years_more_than_four_games
ORDER BY avg_critic_score DESC;

-- Select year, an average of user_score, and a count of games released in a given year, aliased and rounded
-- Include only years with more than four reviewed games; group data by year
-- Order data by avg_user_score, and limit to ten results

SELECT g.year,
       ROUND(AVG(r.user_score),2) as avg_user_score,
       COUNT(r.*) as num_games
FROM game_sales as g
LEFT JOIN reviews as r
ON g.game = r.game
GROUP BY year
HAVING COUNT(r.*)> 4
ORDER BY avg_user_score DESC
Limit 10;

-- Select the year results that appear on both tables

SELECT year      
FROM top_critic_years_more_than_four_games
INTERSECT
SELECT year     
FROM top_user_years_more_than_four_games
ORDER BY year ASC;

-- Select year and sum of games_sold, aliased as total_games_sold; order results by total_games_sold descending
-- Filter game_sales based on whether each year is in the list returned in the previous question

SELECT year,
       SUM(games_sold) as total_games_sold
FROM game_sales
WHERE year IN (SELECT year      
FROM top_critic_years_more_than_four_games
INTERSECT
SELECT year     
FROM top_user_years_more_than_four_games
ORDER BY year DESC)
GROUP BY year
ORDER BY year DESC;

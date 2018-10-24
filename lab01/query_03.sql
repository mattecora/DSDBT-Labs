SELECT      T.datemonth,
            SUM(F.numberofcalls) AS total_calls,
            RANK() OVER (ORDER BY SUM(F.numberofcalls) DESC) AS calls_rank
FROM        Facts F, TimeDim T
WHERE       F.id_time = T.id_time
AND         T.dateyear = 2003
GROUP BY    T.datemonth
ORDER BY    calls_rank;
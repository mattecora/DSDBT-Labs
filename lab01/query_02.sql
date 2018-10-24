SELECT      T.datemonth,
            SUM(F.numberofcalls) AS total_calls,
            SUM(F.price) AS total_income,
            RANK() OVER (ORDER BY SUM(F.price) DESC) AS income_rank
FROM        Facts F, TimeDim T
WHERE       F.id_time = T.id_time
GROUP BY    T.datemonth
ORDER BY    income_rank;
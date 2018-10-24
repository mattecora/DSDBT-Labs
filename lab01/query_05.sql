SELECT      T.dateyear,
            T.datemonth,
            SUM(F.price) AS monthly_income,
            SUM(SUM(F.price)) OVER (
                PARTITION BY    T.dateyear
                ORDER BY        T.datemonth
                ROWS            UNBOUNDED PRECEDING
            ) AS from_beginning_income
FROM        Facts F, TimeDim T
WHERE       F.id_time = T.id_time
GROUP BY    T.datemonth, T.dateyear
ORDER BY    T.dateyear, T.datemonth;
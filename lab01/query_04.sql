SELECT      T.dayofmonth,
            SUM(F.price) AS total_income,
            ROUND(AVG(SUM(F.price)) OVER (
                ORDER BY    T.dayofmonth
                ROWS        2 PRECEDING
            ), 2) AS three_months_avg
FROM        Facts F, TimeDim T
WHERE       F.id_time = T.id_time
AND         T.datemonth = '07-2003'
GROUP BY    T.dayofmonth
ORDER BY    T.dayofmonth;
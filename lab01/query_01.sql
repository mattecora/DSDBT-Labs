SELECT      F.id_phonerate,
            T.dateyear,
            SUM(F.price) AS rate_yearly_income,
            SUM(SUM(F.price)) OVER (PARTITION BY F.id_phonerate) AS rate_total_income,
            SUM(SUM(F.price)) OVER (PARTITION BY T.dateyear) AS overall_yearly_income,
            SUM(SUM(F.price)) OVER () AS overall_total_income
FROM        Facts F, TimeDim T
WHERE       F.id_time = T.id_time
GROUP BY    F.id_phonerate, T.dateyear
ORDER BY    F.id_phonerate;
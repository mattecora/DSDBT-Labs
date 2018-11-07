SELECT      PurchaseMode,
            PurchaseYear,
            PurchaseMonth,
            ROUND(SUM(Revenues)/COUNT(*), 2)
                AS AvgDailyRevenue,
            SUM(SUM(Revenues)) OVER (
                PARTITION BY PurchaseYear, PurchaseMode
                ORDER BY PurchaseMonth
                ROWS UNBOUNDED PRECEDING
                ) AS RevenueFromBeginningOfYear,
            ROUND(SUM(NumberOfTickets)/SUM(SUM(NumberOfTickets))
                OVER (PARTITION BY PurchaseMonth) * 100
                , 2) AS PercentageOverMonth
FROM        F_TICKETSALES TS, D_PURCHASEDATE PD
WHERE       TS.PurchaseDate_ID = PD.PurchaseDate_ID
GROUP BY    PurchaseMode, PurchaseMonth, PurchaseYear
ORDER BY    PurchaseMode, PurchaseYear, PurchaseMonth;

-- MySQL syntax

SELECT
       p.TRANSACTION_DATE,
       -- Calculating the total amount in Euros for all transactions
       SUM(ROUND(p.AMOUNT * COALESCE(cr.EXCHANGE_RATE_TO_EUR, 1), 2)) AS TOTAL_AMOUNT_EUR
FROM payments p
         JOIN currencies c ON p.CURRENCY = c.CURRENCY_ID AND c.END_DATE IS NULL
         LEFT JOIN currency_rates cr ON c.CURRENCY_ID = cr.CURRENCY_ID AND p.TRANSACTION_DATE = cr.EXCHANGE_DATE
         -- Excluding blacklist table entries where there is END_DATE but NO START_DATE
         LEFT JOIN (SELECT USER_ID, BLACKLIST_START_DATE, BLACKLIST_END_DATE
                    FROM blacklist
                    WHERE BLACKLIST_START_DATE IS NOT NULL OR BLACKLIST_END_DATE IS NULL)
                    b ON p.USER_ID_SENDER = b.USER_ID
WHERE
        -- Checking if the user is not blacklisted
        b.BLACKLIST_START_DATE IS NULL AND b.BLACKLIST_END_DATE IS NULL OR
        -- Checking if the TRANSACTION_DATE is before the blacklisting START_DATE
        b.BLACKLIST_START_DATE IS NOT NULL AND b.BLACKLIST_START_DATE > p.TRANSACTION_DATE OR
        -- Checking if the TRANSACTION_DATE is after the blacklisting END_DATE
        b.BLACKLIST_START_DATE IS NOT NULL AND b.BLACKLIST_END_DATE IS NOT NULL AND b.BLACKLIST_END_DATE < p.TRANSACTION_DATE
GROUP BY p.TRANSACTION_DATE;

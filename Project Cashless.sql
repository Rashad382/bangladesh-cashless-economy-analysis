Select
	platform,
	COUNT(*) AS Number_of_records
FROM combined_national_payment_data
GROUP BY platform
ORDER BY platform

Select
	MIN(month) AS first_month,
	MAX(month) AS last_month,
	COUNT(DISTINCT month) AS Number_of_months
FROM combined_national_payment_data

SELECT 
    COUNT(DISTINCT platform) AS number_of_platforms
FROM combined_national_payment_data;

--Aggregate Rows--

SELECT DISTINCT
	platform
FROM combined_national_payment_data
WHERE platform LIKE 'Total%'
OR platform= 'Banking Sector Digital Txn. (A)'

--Individual Payment Channels--

SELECT DISTINCT
	platform
FROM combined_national_payment_data
WHERE platform NOT LIKE 'Total%'
AND platform != 'Banking Sector Digital Txn. (A)'

-- Payment Channel Data Table
SELECT
	month,
	platform, 
	transaction_value,
	transaction_volume
INTO payment_channel_data
FROM combined_national_payment_data
WHERE platform NOT LIKE 'Total%'
AND platform != 'Banking Sector Digital Txn. (A)'

--Total Transaction Volume--
SELECT
    platform,
    SUM(CAST(transaction_volume AS BIGINT)) AS total_transactions
INTO total_transaction_volume
FROM payment_channel_data
GROUP BY platform

--Total Value--
SELECT
    platform,
    SUM(CAST(transaction_value AS BIGINT)) AS total_value
INTO total_transaction_value
FROM payment_channel_data
GROUP BY platform

--Average Transaction Value--
SELECT 
    platform, 
    SUM(CAST(transaction_volume AS BIGINT)) AS total_transactions,
    SUM(CAST(transaction_value AS BIGINT)) AS total_value,
    ROUND(
        SUM(CAST(transaction_value AS FLOAT)) / SUM(CAST(transaction_volume AS FLOAT)), 
        2
    ) AS avg_transaction_size_bdt
FROM 
    payment_channel_data
GROUP BY 
    platform
ORDER BY 
    avg_transaction_size_bdt DESC

--Total Digital Banking--
	SELECT
		month,
		transaction_value,
		transaction_volume
	FROM combined_national_payment_data
	WHERE platform = 'Total Digital Txn. in Fin. System (A+C)'
	ORDER BY month

-- Overall Digital Payment month-over-month Growth
	WITH digital_growth AS
	(
	SELECT
		month,
		transaction_value,
		transaction_volume,
		LAG(transaction_volume) OVER (ORDER BY MONTH) AS previous_month_volume,
		LAG(transaction_value) OVER (ORDER BY MONTH) AS previous_month_value
	FROM combined_national_payment_data
	WHERE platform= 'Total Digital Txn. in Fin. System (A+C)'
	)
	SELECT
		month,
		transaction_value,
		transaction_volume,
		ROUND(
		(CAST(transaction_volume AS FLOAT) - previous_month_volume)
		/ previous_month_volume * 100,
		2) AS volume_growth_pct,
		ROUND(
		(CAST(transaction_value AS FLOAT) - previous_month_value)
		/ previous_month_value * 100,
		2) AS value_growth_pct
	FROM digital_growth
	ORDER BY month

-- Cashless Payment Channel Data
SELECT
    month,
    platform,
    transaction_value,
    transaction_volume
INTO cashless_payment_data
FROM payment_channel_data
WHERE platform IN
	(
    'MFS Digital Txn. (C)',
    'Intra/Inter Bank Digital Txn without BB Platforms',
    'EFT Cr.',
    'IBFT',
    'POS',
    'RTGS',
    'EFT Dr.',
    'IDTP'
	)
SELECT *
FROM cashless_payment_data
ORDER BY month, platform

SELECT
	platform,
	Total_value
INTO cashless_payment_data
FROM Total_value

-- Top 3 Digital Payment Channel Contribution by Month

WITH channel_contribution AS
(
    SELECT
        month,

        ROW_NUMBER() OVER (
            PARTITION BY month
            ORDER BY transaction_volume DESC
        ) AS channel_rank,

        platform,

        ROUND(
            CAST(transaction_volume AS FLOAT)
            /
            SUM(CAST(transaction_volume AS FLOAT))
            OVER (PARTITION BY month)
            * 100,
            2
        ) AS volume_contribution_pct,

        ROUND(
            CAST(transaction_value AS FLOAT)
            /
            SUM(CAST(transaction_value AS FLOAT))
            OVER (PARTITION BY month)
            * 100,
            2
        ) AS value_contribution_pct

    FROM cashless_payment_data

    WHERE transaction_volume IS NOT NULL
      AND transaction_value IS NOT NULL
)

SELECT
    month,
    channel_rank,
    platform,
    volume_contribution_pct,
    value_contribution_pct

INTO monthly_top_digital_channels

FROM channel_contribution

WHERE channel_rank <= 3

-- Digital vs Traditional Transactions Volume Share
SELECT
    month,

    MAX(CASE
        WHEN platform = 'Total Digital Txn. in Fin. System (A+C)'
        THEN transaction_volume
    END) AS digital_volume,

    MAX(CASE
        WHEN platform = 'Total Non-Digital Txn. in Fin. System (B+D)'
        THEN transaction_volume
    END) AS traditional_volume,

    ROUND(
        CAST(
        MAX(CASE
        WHEN platform = 'Total Digital Txn. in Fin. System (A+C)'
        THEN transaction_volume END) AS FLOAT)
        /
        NULLIF(MAX(CASE
        WHEN platform = 'Total Digital Txn. in Fin. System (A+C)'
        THEN transaction_volume
        END)
        +
        MAX(CASE
        WHEN platform = 'Total Non-Digital Txn. in Fin. System (B+D)'
        THEN transaction_volume END),0) * 100,
        2
    ) AS digital_volume_share,

    ROUND(
      CAST(
         MAX(CASE
          WHEN platform = 'Total Non-Digital Txn. in Fin. System (B+D)'
          THEN transaction_volume END) AS FLOAT)
        /
        NULLIF(MAX(CASE
           WHEN platform = 'Total Digital Txn. in Fin. System (A+C)'
           THEN transaction_volume END)
           +
           MAX(CASE
           WHEN platform = 'Total Non-Digital Txn. in Fin. System (B+D)'
           THEN transaction_volume END),0) * 100,
        2
    ) AS traditional_volume_share

INTO digital_traditional_volume_share

FROM combined_national_payment_data

WHERE platform IN
(
    'Total Digital Txn. in Fin. System (A+C)',
    'Total Non-Digital Txn. in Fin. System (B+D)'
)

GROUP BY month
ORDER BY month

-- Digital vs Traditional Transaction Value Share

SELECT
    month,

    MAX(CASE
        WHEN platform = 'Total Digital Txn. in Fin. System (A+C)'
        THEN transaction_value
    END) AS digital_value,

    MAX(CASE
        WHEN platform = 'Total Non-Digital Txn. in Fin. System (B+D)'
        THEN transaction_value
    END) AS traditional_value,

    ROUND(
        CAST(
        MAX(CASE
        WHEN platform = 'Total Digital Txn. in Fin. System (A+C)'
        THEN transaction_value END) AS FLOAT)
        /
        NULLIF(MAX(CASE
        WHEN platform = 'Total Digital Txn. in Fin. System (A+C)'
        THEN transaction_value
        END)
        +
        MAX(CASE
        WHEN platform = 'Total Non-Digital Txn. in Fin. System (B+D)'
        THEN transaction_value END),0) * 100,
        2
    ) AS digital_value_share,

    ROUND(
      CAST(
         MAX(CASE
          WHEN platform = 'Total Non-Digital Txn. in Fin. System (B+D)'
          THEN transaction_volume END) AS FLOAT)
        /
        NULLIF(MAX(CASE
           WHEN platform = 'Total Digital Txn. in Fin. System (A+C)'
           THEN transaction_value END)
           +
           MAX(CASE
           WHEN platform = 'Total Non-Digital Txn. in Fin. System (B+D)'
           THEN transaction_value END),0) * 100,
        2
    ) AS traditional_value_share

INTO digital_traditional_value_share

FROM combined_national_payment_data

WHERE platform IN
(
    'Total Digital Txn. in Fin. System (A+C)',
    'Total Non-Digital Txn. in Fin. System (B+D)'
)

GROUP BY month
ORDER BY month


--Digital Vs Traditional Overall Comparison
SELECT
    'Transaction Volume Share' AS metric,

    MAX(CASE
    WHEN month = '2025-01-01'
    THEN digital_volume_share
    END) AS jan_2025_digital,

    MAX(CASE
    WHEN month = '2026-03-01'
    THEN digital_volume_share
    END) AS mar_2026_digital,

    MAX(CASE
    WHEN month = '2026-03-01'
    THEN digital_volume_share
    END)
    -
    MAX(CASE
    WHEN month = '2025-01-01'
    THEN digital_volume_share
    END) AS change_pp

FROM digital_traditional_volume_share

UNION ALL

SELECT
    'Transaction Value Share',

    MAX(CASE
    WHEN month = '2025-01-01'
    THEN digital_value_share
    END),

    MAX(CASE
    WHEN month = '2026-03-01'
    THEN digital_value_share
    END),

    MAX(CASE
    WHEN month = '2026-03-01'
    THEN digital_value_share
    END)
    -
    MAX(CASE
    WHEN month = '2025-01-01'
    THEN digital_value_share
    END)

FROM digital_traditional_value_share
WITH source_data AS (
    SELECT
        CUSTOMER_ID,
        CUSTOMER_NAME,
        UPPER(CUSTOMER_REGION) AS CUSTOMER_REGION,
        DATE(CREATED_DATE) AS CREATED_DATE,
        CUSTOMER_SEGMENT
    FROM {{ var('db_name') }}.{{ var('schema_name') }}.{{ var('table_name') }}
),

transformed_data AS (
    SELECT
        CUSTOMER_ID,
        CUSTOMER_NAME,
        CUSTOMER_REGION,
        CREATED_DATE,
        CUSTOMER_SEGMENT,

        -- Customer Category based on CUSTOMER_SEGMENT
        CASE 
            WHEN CUSTOMER_SEGMENT IN ('Premium', 'Enterprise') THEN 'High Value'
            ELSE 'Standard'
        END AS CUSTOMER_CATEGORY,

        -- Calculate Customer Age in Days since CREATED_DATE
        DATEDIFF(DAY, CREATED_DATE, CURRENT_DATE()) AS CUSTOMER_AGE_DAYS,

        -- Flag recent customers created within the last 365 days
        CASE 
            WHEN DATEDIFF(DAY, CREATED_DATE, CURRENT_DATE()) <= 365 THEN 'Recent'
            ELSE 'Old'
        END AS RECENT_CUSTOMER_FLAG
    FROM source_data
)

SELECT *
FROM transformed_data

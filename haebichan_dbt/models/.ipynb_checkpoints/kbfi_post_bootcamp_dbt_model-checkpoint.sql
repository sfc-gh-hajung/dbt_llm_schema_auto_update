
WITH base AS (
  SELECT category, LAT, seen
  FROM kbfi_view
  FETCH FIRST 10000 ROWS ONLY
)
SELECT 
  category,
    avg(seen) as avg_seen,
    min(LAT) as min_lat,
    
FROM base 
GROUP BY 1

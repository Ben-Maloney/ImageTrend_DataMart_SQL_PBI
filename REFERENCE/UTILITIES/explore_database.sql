-- SELECT table_name 
-- FROM information_schema.tables;

SELECT 
  table_name, 
  column_name, 
  data_type, 
  character_maximum_length, 
  numeric_precision, 
  numeric_scale, 
  is_nullable
FROM 
  information_schema.columns
ORDER BY 
  table_name, 
  column_name;
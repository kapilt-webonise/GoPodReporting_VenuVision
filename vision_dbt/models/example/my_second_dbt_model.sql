
-- Use the `ref` function to select from other models

select *
from {{ ref('testmodel') }}
where id = 1

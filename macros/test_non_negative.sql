-- Generic test: fails if the column contains negative values.
-- Usage in schema.yml:
--   tests:
--     - non_negative

{% test non_negative(model, column_name) %}

select *
from {{ model }}
where {{ column_name }} < 0

{% endtest %}

# dbt retail demo: marts, SCD-2, and data-quality checks

A small, self-contained dbt project I built to show how I work with the transformation layer. It mirrors the patterns I use at my job (dbt models with tests, SCD-2 snapshots, parity audits), rebuilt from scratch on synthetic data.

## What it shows

- **Staging layer** that cleans raw input: dedupes by primary key, drops impossible rows (negative quantities), casts types.
- **Dimensional mart** (`fct_sales_daily`) built as an incremental model (`delete+insert`).
- **SCD-2 snapshot** of the product catalog, and a `dim_products` view with `valid_from / valid_to / is_current`. Edit a price in `seeds/raw_products.csv` and re-run `dbt seed && dbt snapshot` to watch history accumulate.
- **Loss-audit test** (`tests/assert_no_revenue_loss.sql`): total revenue in the mart must reconcile with staging to the cent. This is the same idea I use for history rewrites at work: never cut over until the diff is zero or explained.
- **Generic data-quality test** (`non_negative`) plus the standard unique / not_null / relationships coverage.

## How to run

Requires Python. DuckDB needs no server, the warehouse is a local file.

```bash
pip install dbt-duckdb
dbt seed
dbt snapshot
dbt run
dbt test
```

`dbt build` does the last four in one go.

## Layout

```
seeds/        raw_products, raw_stores, raw_sales (synthetic, intentionally a bit dirty)
models/
  staging/    cleaning + tests
  marts/      fct_sales_daily (incremental), dim_products (from the snapshot)
snapshots/    products_snapshot (SCD-2, check strategy)
macros/       non_negative generic test
tests/        revenue parity audit
```

The raw sales seed contains a duplicated `sale_id` and a negative-quantity row on purpose. Staging handles both, and the tests prove it.

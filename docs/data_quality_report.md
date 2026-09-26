## Data quality issues

| Issue | Where | Evidence | Decision |
|---|---|---|---|
| Missing values | 10 columns | gender 980, return_flag 985, age_group 863, delivery_status 794, order_status 705, customer_rating 505, delivery_days 418, payment_method 415, sales_channel 411, customer_segment 385 | Fill text columns with "Unknown"; leave number columns empty |
| Inconsistent casing | 7 columns | Completed / completed / COMPLETED; Yes / yes; NO / No | Lowercase, then map to one spelling |
| Abbreviations | gender | 10 spellings plus missing, e.g. M, F, m, f, MALE | Mapping dictionary |
| Extra spaces | customer_name, gender, customer_segment | 200, 335 and 350 values | `str.strip()` |
| Wrong data types | phone_number, order_date, delivery_days, customer_rating | Phone read as a number by default; date stored as text; days and rating stored as decimals | Drop phone (not in the brief); convert date; convert to whole numbers |
| Unreliable product ID | product_id | One ID is used for up to 24 different products | Keep, but group products by name |
| Random pricing | unit_price | Every product appears at all 9 price points | Record as a limitation |
| Status contradictions | order_status, delivery_status | 443 cancelled and 355 pending orders marked as delivered | Keep and flag, not delete |
| No issue found | IDs, duplicates, city/region, revenue, dates | 0 duplicates; revenue formula holds on all 5,000 rows; dates 2024-01-01 to 2026-09-01 | Record that these were checked |
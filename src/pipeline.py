print("1. MISSING VALUES")
missing = df.isna().sum()
print(missing[missing > 0].sort_values(ascending=False).to_string())

print("\n2. CASING: spellings per column (before vs after lowercasing)")
for col in ["order_status", "delivery_status", "payment_method", "sales_channel", "customer_segment", "return_flag", "gender"]:
    print(f"{col}: {df[col].nunique()} spellings -> {df[col].str.strip().str.lower().nunique()} real values")

print("\n3. GENDER SPELLINGS")
print(df["gender"].value_counts(dropna=False).to_string())

print("\n4. EXTRA SPACES")
for col in ["customer_name", "gender", "customer_segment"]:
    print(col, int((df[col].notna() & (df[col] != df[col].str.strip())).sum()))

print("\n5. DATA TYPES")
print(df[["phone_number", "order_date", "delivery_days", "customer_rating"]].dtypes.to_string())

print("\n6. PRODUCT ID: most names for one ID:", df.groupby("product_id")["product_name"].nunique().max())
print("7. PRICING: fewest prices for one product:", df.groupby("product_name")["unit_price"].nunique().min(),
      "| total price points:", df["unit_price"].nunique())

o = df["order_status"].str.strip().str.lower()
d = df["delivery_status"].str.strip().str.lower()
print("\n8. CONTRADICTIONS: cancelled but delivered:", int(((o == "cancelled") & (d == "delivered")).sum()),
      "| pending but delivered:", int(((o == "pending") & (d == "delivered")).sum()))

expected = df["quantity"] * df["unit_price"] * (1 - df["discount_rate"])
print("\n9. CHECKS PASSED")
print("Duplicate rows:", int(df.duplicated().sum()))
print("Rows where revenue formula holds:", int(((df["order_revenue"] - expected).abs() < 0.01).sum()), "of", len(df))
print("Max regions per city:", pd.crosstab(df["city"], df["region"]).gt(0).sum(axis=1).max())
print("Dates:", df["order_date"].min(), "to", df["order_date"].max())

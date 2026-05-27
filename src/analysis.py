import pandas as pd

df = pd.read_csv("../data/sales_orders.csv", parse_dates=["order_date"])

print("Rows:", len(df))
print("Date range:", df["order_date"].min().date(), "to", df["order_date"].max().date())

kpis = {
    "Total Revenue": df["revenue"].sum(),
    "Total Profit": df["profit"].sum(),
    "Total Orders": df["order_id"].nunique(),
    "Average Order Value": df["revenue"].mean(),
    "Profit Margin": df["profit"].sum() / df["revenue"].sum()
}
print("\nKPI Summary")
for k, v in kpis.items():
    print(f"{k}: {v:,.2f}" if isinstance(v, float) else f"{k}: {v}")

monthly = df.groupby(pd.Grouper(key="order_date", freq="M")).agg(
    revenue=("revenue", "sum"),
    profit=("profit", "sum"),
    orders=("order_id", "nunique")
).reset_index()

regional = df.groupby("region").agg(
    revenue=("revenue", "sum"),
    profit=("profit", "sum"),
    orders=("order_id", "nunique")
).sort_values("revenue", ascending=False)

print("\nTop Regions")
print(regional)
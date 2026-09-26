# Swiggy-Sales-Customer-Analytics

**A comprehensive, production-grade data analytics project analyzing 600,000+ food delivery orders across 10 Indian cities (2022–2025) — solving 7 critical business challenges through Python, SQL, and interactive Power BI dashboards.**

##  Project Overview

Swiggy, one of India's leading food delivery platforms, operates across **10 major cities** with over **1,000 restaurant partners**. Despite generating **₹39.61 Crores** in Gross Order Value over 4 years (2022–2025), the business faces critical challenges in customer retention, revenue optimization, restaurant performance, and operational efficiency.

###  Platform Metrics at a Glance

| Metric | Value |
|---|---|
|  Total Orders Processed | 6,00,000 |
|  Gross Order Value | ₹39.62 Crores |
|  Active Customers | 10,000+ |
|  Restaurant Partners | 1,000 |
|  Cities Covered | 10 |
|  Order Fulfillment Rate | 95% |
|  Cancellation Rate | ~5% |
|  Avg Order Value | ₹695 |

---

##  Business Problem

Swiggy faces **7 interconnected business challenges** requiring data-driven solutions:

| # | Business Challenge | Core Question |
|---|---|---|
| 1 | **Customer Retention & Engagement** | Who are our most valuable customers? How do we reduce churn? |
| 2 | **Revenue Optimization** | What are the key revenue drivers? How do we break the growth ceiling? |
| 3 | **Restaurant Partner Performance** | Which restaurants excel or underperform — and why? |
| 4 | **Menu & Product Optimization** | What sells best? How do we increase basket size? |
| 5 | **Operational Efficiency** | When are peak hours? What is causing cancellations? |
| 6 | **Market Expansion & Growth** | Which cities should we expand into next? |
| 7 | **Customer Experience & Satisfaction** | What payment, demographic, and behavioral factors drive spend? |

---

##  Dataset Summary

| Table | Records | Description |
|---|---|---|
| `users` | 10,000 | Customer profiles (demographics, occupation, age) |
| `restaurants` | 1,000 | Restaurant info (city, cuisine, rating, type) |
| `menu` | ~15,658 | Menu items per restaurant (category, price, veg/non-veg) |
| `orders` | 600,000 | Order transactions (date, time, status, payment, amount) |
| `order_items` | ~1,667,399 | Line items per order (quantity, price, item) |

**Data Period:** January 2022 – December 2025 (4 Years)
**Total File Size:** ~128 MB (raw CSVs)

>  All Data is Synthetic and Generated for Educational/Portfolio purposes. No Real Customer or Company data is used.

---

##  Python Analysis

### Notebooks

| Notebook | Description |
|---|---|
| [`Notebooks/Swiggy_Data_Analysis.ipynb`](Notebooks/Swiggy_Data_Analysis.ipynb) | Main analysis notebook — 7 business challenge solutions, 30+ charts |
| [`Notebooks/Exploratory_Data_Analysis.ipynb`](Notebooks/Exploratory_Data_Analysis.ipynb) | Initial EDA — distributions, missing values, outliers |


---

##  Power BI Dashboard

The dashboard is organized into **7 dedicated pages**, each addressing a specific business challenge:

### Dashboard Pages

| Page | Title | Key Visuals |
|---|---|---|
| 1 | **Executive Overview** | Revenue KPIs, YoY Growth, Top City/Cuisine/Restaurant, Alert Cards |
| 2 | **Customer Intelligence** | RFM Segments, CLV by Segment, Cohort Retention Heatmap, Churn Risk |
| 3 | **Revenue Analytics** | MTD/QTD/YTD trend lines, Revenue by City/Cuisine/Time, Seasonal Patterns |
| 4 | **Restaurant Performance** | Top/Bottom Performers, Efficiency Score, Cloud vs Traditional, Rating Impact |
| 5 | **Menu & Product Intelligence** | Best Sellers, Veg vs Non-Veg, Basket Analysis, Price Category Distribution |
| 6 | **Operations & Efficiency** | Order Distribution, Cancellation by City/Time, Peak Hour Capacity, Fleet Insights |
| 7 | **Market Expansion** | Saturation Index, Expansion Priority Score, Cuisine Gaps, Penetration Rate |


---

##  Key Insights & Findings

###  Customer Insights
- **Elite Retention:** 0% one-time customers — every acquired user returns, confirming "habitual" platform status
- **The Loyalty Multiplier:** Loyal customers have a **22x higher CLV** (₹88,972) vs Occasional users (₹3,998)
- **Revenue Concentration:** Top 20% of customers drive **84.1%** of total revenue — a classic Pareto whale-driven business
- **Churn Alert:** 3,892 customers (38.9%) haven't ordered in 90+ days — **₹2.87 Crores at stake**
- **The Retention Cliff:** ~74% of users are lost after Month 1; those surviving 90 days become permanent

###  Revenue Insights
- **Growth Stagnation:** Only 0.15% average annual growth — platform has hit a ceiling in existing markets
- **Seasonal Pattern:** July & December are peak months; February dips 10–12% every year
- **Lunch/Dinner Duopoly:** These two windows drive **87.4%** of all revenue
- **"Big Three" Dominance:** Mumbai, Delhi & Bangalore contribute **₹21.8 Crores (55%)** of total revenue

###  Restaurant Insights
- **AOV Multiplier:** Top restaurants generate **₹6 Lakhs** vs bottom restaurants at ₹2.2 Lakhs — entirely driven by menu engineering
- **Quality Premium:** "Excellent" restaurants (4.5+ rating) command **22% higher AOV** (₹778 vs ₹638)
- **Cloud Kitchen Reach:** Cloud Kitchens serve **2.4x more unique customers** per partner vs Traditional
- **The Jaipur Thai Opportunity:** Thai is Jaipur's #1 revenue driver with only 5 restaurants — massively underserved

###  Menu Insights
- **Veg Dominance:** Platform is **82.2% Veg** — reflecting the Indian market; Non-Veg items avg ₹247.51 vs ₹171.71
- **Paneer Burger King:** Paneer Burger alone generated **₹1.45 Crores** — #1 item on the platform
- **Group Order Culture:** 85% of orders are multi-item with avg **2.78 items** — confirming duo/group ordering behavior
- **The Luxury Gap:** Only 4.7% of orders are Luxury (₹400+) yet contribute a disproportionately high ₹4.76 Crores

###  Operational Insights
- **₹25 Crore Annual Drain:** Monthly cancellation losses of ₹2.08 Cr project to **₹25 Crores annually**
- **761x Peak Surge:** Infrastructure must handle 21,245 orders/hour at peak vs average of 28/hour
- **7-Day Utility:** Near-zero difference between weekday and weekend orders — no weekend surge captured
- **Late Night Blind Spot:** 5.18% cancellation rate in Late Night — restaurants closing without updating status

###  Market Expansion Insights
- **0.1% Ceiling:** Swiggy currently serves <0.1% of the population in all 10 cities — 45M potential customers untapped
- **Top Expansion Priority:** Kolkata (#1 Final Score: 80), followed by Bangalore and Ahmedabad
- **The Lucknow/Ahmedabad Goldmine:** Highest customer-per-restaurant ratios (>155) — critically underserved
- **Metro Saturation:** Mumbai, Delhi, and Bangalore have reached 100% market saturation — shift from acquisition to yield optimization

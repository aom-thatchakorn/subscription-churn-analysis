# Subscription Churn & Revenue Analysis

Case study inspired by Netflix's 2022 subscriber-loss event | SQL · Excel · Power BI

> **Data note:** the dataset is synthetic. It was generated with Claude (AI) to resemble real subscription behaviour, because real customer-level data is not publicly available. This project demonstrates an end-to-end analysis workflow; the findings do not describe real customers.

## Business question
Which customer segments carry the highest churn risk, how much revenue is exposed, and what would retention actions be worth?

## Data
- 2,500 customer records (synthetic, AI-generated)
- Variables: plan duration, subscription type, tenure, country, age, gender, device (7 variables)

## Method
1. **SQL:** defined churn as no payment within 30 days of the dataset's snapshot date; created a tenure segment (New <=90 days vs Established) with CASE WHEN; calculated revenue impact
2. **Excel:** ran chi-square tests of independence (α = 0.05) on 7 variables using contingency tables
3. **Excel:** for the significant variables, used SUMIF/SUMIFS, XLOOKUP and PivotTables to size revenue exposure and run retention scenarios
4. **Power BI:** built a dashboard (DAX measures, KPI cards, segment breakdowns); cross-checked key figures against SQL and Excel

## Key findings
| Factor | Comparison | p-value | Result |
|---|---|---|---|
| Plan duration | Monthly 17.3% vs Annual 10.1% | 0.000007 | Significant |
| Subscription type | Basic 17.6% vs Premium 12.7% | 0.0109 | Significant |
| Tenure segment | New (<=90 days) 20.0% vs Established 14.8% | 0.035 | Significant |
| Country / Age / Gender / Device | No meaningful variation | > 0.36 (all) | Not significant |

Overall churn rate: 15.24%.

## Revenue exposure
| Item | Amount |
|---|---|
| Realized loss (already churned) | $4,802 / month |
| Active Basic + Monthly customers (650) | $6,500 / month |
| Total exposure | $11,302 / month (~$135,600 / year) |

Of the 650 customers, 52 also have New tenure (all three risk factors), worth $520 / month. These 52 are part of the 650, not additional.

Exposure is the revenue linked to at-risk segments, not a forecast of loss: most customers in these segments will not churn.

## Scenario analysis
Expected churners = customers in segment × segment churn rate. 
Revenue saved = expected churners × churn reduction × $10 (Basic plan price).

| Tier | Segment | Customers | Churn rate | Reduction | Revenue saved / month |
|---|---|---|---|---|---|
| 1 | Basic + Monthly | 650 | 19.15% | 10% | $125 |
| | | | | 20% | $249 |
| | | | | 30% | $374 |
| 2 | Basic + Monthly + New (<=90 days) | 52 | 24.64% | 10% | $13 |
| | | | | 20% | $26 |
| | | | | 30% | $38 |

Assumptions: Assumptions: the reduction is relative to the segment's current churn rate (e.g. for Tier 1, a 30% reduction takes churn from 19.15% to about 13.4%). Churn rates are calculated on all customers in the segment (active and churned) and applied to the currently active customers. Tier 2 is a subset of Tier 1, so the two tiers are not added together. Revenue per customer is $10/month (Basic plan price). Intervention costs are not deducted.

## Recommendations
1. **Strengthen 90-day onboarding.** New customers churn 35% more than established ones (20.0% vs 14.8%). Add an onboarding email series, in-app tutorial and check-ins at day 30/60/90.
2. **Incentivize annual billing.** Monthly churn is ~1.7x annual, the strongest driver found. Test a 10–15% annual-commitment discount, starting with Basic-tier customers.
3. **Two-tier retention.** Run a broad campaign (email, in-app offers) for the 650 Basic + Monthly customers, and personal outreach for the 52 who also have New tenure.

## Limitations
- **Synthetic data:** statistical significance reflects how the data was generated, not real customer behaviour
- **Association, not causation:** chi-square tests show association between variables and churn
- **Multiple testing:** 7 tests at α = 0.05 with no correction; under a Bonferroni correction only plan duration would remain significant
- **Variables tested one at a time:** the combined effect of the three risk factors (tier 2) was not tested directly
- **Exposure is an upper bound,** and scenarios do not deduct the cost of retention actions such as discounts
- Small segment (52 customers): churn rate is unstable
- **Churn rate as a monthly rate:** the observed churn share is treated as the expected churn over one month; the true monthly rate may be lower.

# D2C Customer Churn Analysis

**Problem:** D2C brands discover customers have churned 60–90 days after their last 
purchase — too late for effective win-back. This project builds an early warning 
system using RFM segmentation to identify at-risk customers before they are lost.

## Key Findings

- **97.5%** of customers never made a second purchase
- Repeat buyers spend **90% more** on average (₹261 vs ₹138)
- **84.2%** of the customer base is already classified as Lost (inactive 324+ days)
- The At Risk segment (268 customers, ₹288 avg revenue) is the highest-ROI 
  intervention target — still within win-back range

## Dataset

Olist Brazilian E-Commerce Public Dataset (Kaggle)  
74,364 unique customers | 100,000+ transactions | 2016–2018

## Tools Used

- **MySQL** — RFM segmentation, cohort queries, segment summary
- **Excel** — Dashboard with RFM table, monthly trend chart, buyer split analysis
- **PowerPoint** — 3-slide insight deck for stakeholder presentation

## Files

| File | Description |
|---|---|
| `churn_queries.sql` | All 6 MySQL queries used in the analysis |
| `P2_Churn_Analysis.xlsx` | Excel dashboard — 3 sheets |
| `P2_Churn_Presentation.pptx` | 3-slide insight presentation |

## RFM Segments

| Segment | Customers | % of Base | Avg Revenue | Action |
|---|---|---|---|---|
| At Risk | 268 | 0.4% | ₹288 | Urgency win-back |
| Loyal | 37 | 0.05% | ₹230 | VIP program |
| Needs Attention | 11,420 | 15.4% | ₹137 | Day 84 nudge |
| Lost | 62,639 | 84.2% | ₹141 | Mass re-engagement |

## Business Recommendation

Converting just 1% of one-time buyers (725 customers) to repeat buyers at the 
repeat buyer average revenue adds **₹189,000+ in incremental revenue**.

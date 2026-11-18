# IPO Valuation & Listing Performance: Indian Mainboard IPOs (Aug-Dec 2025)

**Question:** Do subscription demand (QIB / NII / Retail) and issue size explain listing-day returns, and does the day-1 pop last?

**Tools:** Excel (formula-driven workbook), SQL (SQLite, 6 queries), Python (pandas, statsmodels, matplotlib).

## Data
- 57 mainboard IPOs listed Aug-Dec 2025, from the Trendlyne IPO screener (pulled Nov 2026).
- Fields: issue size, issue price, QIB/NII/Retail/Total subscription, listing open/close price, return till date.
- Excluded: Knowledge Realty Trust (REIT) and Anantam Highways (InvIT), which are trust units without a comparable retail book.
- Listing gain is recomputed from prices (close vs issue price) and cross-checked against the source.

## Key findings
1. Average listing-day gain was about 10.0% (median 5.0%); 68% of IPOs closed above issue price on day 1.
2. Listing gain rises with subscription: about 0% for <10x issues vs about 40% for 100x+ issues. Spearman rho = 0.57 (p < 0.001).
3. Subscription does not predict later returns (rho = 0.14, p = 0.28).
4. Regression: log total subscription + log issue size gives R² = 0.34; splitting by QIB/NII/Retail gives R² = 0.45 (NII coefficient is distorted by multicollinearity).
5. Day-1 winners average +50% till date vs -13% for losers, but the median return for the whole sample is only about 2% and the mean is skewed by outliers.

## Limitations
- One half-year sample (Aug-Dec 2025); no P/E or P/B data (needs RHP financials).
- "Return till date" is a snapshot with different holding periods per IPO, not a fixed 1M/6M window.
- Correlation, not causation.

## Files
| File | What it is |
|---|---|
| `IPO_Analysis.xlsx` | Data sheet + Summary sheet (live formulas, 2 charts) |
| `ipo_queries.sql` | 6 SQL queries (month, subscription bucket, size bucket, top/bottom 5, pop persistence, QIB vs retail) |
| `IPO_Analysis.ipynb` | Python notebook: EDA, regression, charts, findings |
| `ipo_data.csv` | Cleaned dataset |
| `charts/` | Exported chart images |

## Next steps
- Add P/E and P/B at issue price for the 15-20 largest IPOs.
- Replace the snapshot with 1M/6M returns via `yfinance` and abnormal returns vs Nifty 50.
- Extend to 2023-2024.

# Is Bangladesh Actually Transitioning Toward a Cashless Economy?

## Project Overview

Bangladesh has been expanding digital payment infrastructure across mobile financial services, bank transfers, cards, and electronic payment systems. But a rise in digital transactions does not automatically mean that traditional payment methods are being replaced.

This project investigates one focused question:

> **Is Bangladesh actually transitioning toward a cashless economy?**

The analysis uses Bangladesh Bank national payment data covering **January 2025 to March 2026** and applies SQL-based analysis to understand how digital and traditional payment activity changed over the period.

The goal is not to assume that Bangladesh is becoming cashless, but to let the data determine the extent and nature of the transition.

---

## Business Question

**Is Bangladesh actually transitioning toward a cashless economy?**

To answer this, the analysis follows a focused sequence:

1. Identify the payment channels included in the national payment data.
2. Separate aggregate measures from individual payment channels.
3. Identify payment channels that can reasonably be classified as cashless/digital.
4. Measure overall digital payment activity.
5. Identify the digital channels driving transaction activity.
6. Compare digital and traditional payment activity by transaction volume and transaction value.
7. Compare the beginning and end of the analysis period to assess whether the structure of payments changed.

---

## Data

**Source:** Bangladesh Bank — National Payment System data

**Period:** January 2025 – March 2026

The dataset contains monthly transaction volume and transaction value across Bangladesh's major payment channels and aggregate payment categories.

### Digital / cashless channels used in the analysis

The project conservatively classifies the following channels as cashless/digital:

- MFS Digital Transactions
- Intra/Inter Bank Digital Transactions without BB Platforms
- EFT Credit
- EFT Debit
- IBFT
- POS
- RTGS
- IDTP

Channels involving cash activity or whose payment nature is mixed/ambiguous were not automatically classified as cashless.

This conservative definition is intentional: the analysis avoids treating every electronic-looking banking record as a completely cashless transaction.

---

## Tools

- **SQL Server / T-SQL** — data preparation, aggregation, calculations and analysis
- **Power BI** — planned visualization and dashboard development
- **GitHub** — project documentation and portfolio presentation

---

## SQL Analysis

The SQL analysis covers:

### 1. Payment channel exploration

- Number of payment platforms
- Monthly coverage
- Identification of aggregate and individual payment channels

### 2. Digital payment analysis

- Total transaction volume
- Total transaction value
- Average transaction value by platform
- Overall month-over-month digital transaction growth

### 3. Digital channel contribution

The project identifies the top digital payment channels by month and measures their contribution to:

- Transaction volume
- Transaction value

### 4. Digital vs. traditional comparison

Digital and traditional transactions are compared using:

- Transaction volume share
- Transaction value share

The final comparison focuses on **January 2025 vs. March 2026**.

---

## Key Findings

### 1. Digital transaction volume share decreased

Digital transactions accounted for:

- **50.90%** of transaction volume in January 2025
- **48.12%** in March 2026

This represents a decline of **2.78 percentage points**.

Therefore, based on transaction count alone, the data does **not** show a clear shift toward digital payments during the period.

### 2. Digital transaction value share increased

Digital transactions accounted for:

- **31.87%** of transaction value in January 2025
- **36.31%** in March 2026

This represents an increase of **4.44 percentage points**.

This indicates that digital payment activity gained importance in terms of the monetary value being transacted, even though its share of total transaction count declined.

### 3. The transition is therefore not a simple replacement of traditional payments

The results show two different movements:

| Measure | Jan 2025 | Mar 2026 | Change |
|---|---:|---:|---:|
| Digital transaction volume share | 50.90% | 48.12% | -2.78 pp |
| Digital transaction value share | 31.87% | 36.31% | +4.44 pp |

This is an important distinction.

Bangladesh's payment system cannot be described simply as:

> "Digital transactions are replacing traditional transactions."

Instead, the data suggests a **more nuanced transition** in which digital payments became more significant in monetary value, while their share of transaction count did not increase over the measured period.

---

## Conclusion

### Is Bangladesh actually transitioning toward a cashless economy?

**The data provides evidence of a partial and uneven transition toward digital payments, but not evidence of a complete shift away from traditional payment methods.**

Between January 2025 and March 2026:

- Digital payment **volume share fell by 2.78 percentage points**.
- Digital payment **value share increased by 4.44 percentage points**.
- By March 2026, digital payments represented **48.12% of transaction volume** and **36.31% of transaction value** under the project's measurement framework.

Therefore, the strongest conclusion is:

> **Bangladesh shows signs of a transition toward digital payments, particularly in the share of transaction value, but the transition is not yet a clear replacement of traditional payment activity.**

This distinction is important because measuring only the number of digital transactions could lead to a different conclusion from measuring the monetary value of those transactions.

---

## Limitations

- The analysis covers **January 2025 to March 2026**, so it represents a relatively short period.
- "Cashless" is defined conservatively for this project based on the characteristics of the available payment channels.
- Some payment systems contain mixed or indirect forms of electronic activity and were therefore excluded from the strict cashless subset rather than being assumed to be fully cashless.
- The analysis describes transaction behavior in the Bangladesh Bank payment-system data; it does not measure every cash transaction occurring in the economy.
- The results show association and movement in payment activity, not the causal reasons behind those changes.

---

## Project Structure

```text
bangladesh-cashless-economy-analysis/
│
├── README.md
│
├── sql/
│   └── cashless_economy_analysis.sql
│
├── data/
│   └── README.md
│
├── screenshots/
│   └── ...
│
└── dashboard/
    └── ...
```

The Power BI dashboard and screenshots will be added as the visualization stage of the project is completed.

---

## What This Project Demonstrates

This project demonstrates practical skills in:

- SQL data exploration
- Data cleaning and filtering
- Working with aggregate and transactional data
- Conditional aggregation
- Window functions
- Month-over-month analysis
- Contribution analysis
- Percentage-share calculations
- Comparing digital vs. traditional payment systems
- Translating data into a business conclusion

---

## Next Step

The next stage of the project is to build an interactive **Power BI dashboard** that communicates the findings visually.

The dashboard will focus on:

1. Digital vs. traditional transaction volume share over time
2. Digital vs. traditional transaction value share over time
3. Monthly contribution of the major digital payment channels
4. The January 2025 vs. March 2026 comparison


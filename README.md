# PLSQL_Final-Project
ITI Database Administration Track - Advanced PL/SQL Project

For this project, you will filling PAYMENT_INSTALLMENTS_NO in CONTRACTS table **with update this column**, and fill INSTALLMENTS_PAID table **with insert:**
```
- CONTRACT_ID 
- INSTALLMENT_DATE BASES ON CONTRACT_PAYMENT_TYPE 
  - IF ANNUAL THEN ADD 12 MONTHS 
  - IF QUARTER THEN ADD 3 MONTHS 
  - IF HALF_ANNUAL THEN ADD 6 OMTHS 
  - IF MONTHLY THEN ADD 1 MONTH
- INSTALLMENT_AMOUNT EQUAL AMOUNTS BY PAYMENT_TYPE 
  - CHECK FOR ANY DEPOSIT PAID SUBTACT IT FROM CONTRACT_TOTAL_FEES FIRST, PAID = 0
```
The schema provided below. You can see the columns that **link** tables together via the arrows.

<img width="652" alt="screen-shot-2022-06-12-at-10 02 03-pm" src="https://github.com/Habeeb556/PLSQL_Final-Project/blob/main/System%20Diagram.drawio.png">

$~$

Under the supervision of Sir.[Yahia Momtaz](https://www.linkedin.com/in/yahia-momtaz-20a37840), Technical Instructor, Information Technology Institute.

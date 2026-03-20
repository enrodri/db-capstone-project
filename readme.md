# Little Lemon Database Capstone Project
### Meta Database Engineer Professional Certificate

This repository contains the complete database solution for **Little Lemon**, a fictional Mediterranean restaurant. The project demonstrates database proficiency, covering data modeling, advanced SQL programming, Python-to-MySQL integration, and interactive data visualization.

---

## 🛠️ Tech Stack & Tools
* **Database:** MySQL Server & MySQL Workbench
* **Data Generation:** Python (Faker library)
* **Database Client:** Python (mysql-connector-python) & Jupyter Notebook
* **Visualization:** Tableau Public
* **Version Control:** Git & GitHub

---

## 📂 Project Structure
* **`/screenshot_procedures`**: Contains screenshots related to the creation and execution examples of stored procedures.
* **`/tableau`**: Contains screenshots of the Tableau Public worksheets.
* **`little_lemon_generation.ipynb`**: Jupyter notebook that uses mysql-connector-python and faker library to create randomized synthetic data for database population.
* **`little_lemon_queries.ipynb`**: Jupyter notebook that contains queries executed through mysql-connector-python.

---

## 🚀 Key Features

### 1. Robust Data Modeling
Implemented a fully normalized relational schema (1NF, 2NF, 3NF) ensuring data integrity across customers, bookings, orders, and menu items.

### 2. Advanced SQL Programming
* **Transaction Management:** Developed `AddValidBooking`, a stored procedure that utilizes `START TRANSACTION` and `ROLLBACK` to prevent double-booking.
* **Administrative CRUD:** Automated restaurant operations with procedures like `AddBooking`, `UpdateBooking`, and `CancelBooking`.

### 3. Automated Data Population (Faker)
To simulate a real-world high-traffic environment, I utilized the **Python `Faker` library**.
* **Synthetic Data Generation:** Hundreds of unique customer records and orders were generated to stress-test stored procedures.
* **Testing at Scale:** This approach allows for comprehensive testing of database performance and trigger logic that static datasets cannot provide.

### 4. Interactive Dashboards (Tableau Public)
**Tableau Public** was used to provide actionable business insights.
* **Live Dashboard:** [(https://public.tableau.com/app/profile/enyel.a.rodr.guez.g./viz/Littlelemoncapstone/Dashboard?publish=yes)]

---

> **Note to Reviewers:** Due to the use of randomized synthetic data via the Faker library, specific values in the SQL screenshots may vary from those displayed in the Tableau dashboard.

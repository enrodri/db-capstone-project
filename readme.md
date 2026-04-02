# 🍋 Little Lemon: Database Capstone Project
### *Project overview*

This repository contains the complete database solution for Little Lemon, a fictional Mediterranean restaurant. The project demonstrates database proficiency, covering data modeling, advanced SQL programming, Python-to-MySQL integration, and interactive data visualization.

---

## 📂 Project Structure
```text
.
├── sql/
│   ├── database_schema.sql       # ERD implementation and table creation
│   ├── execution_procedures.sql     # Administrative and analytic procedures
│   └── population_procedures.sql     # Database population based on the faker library
├── python_client/
│   ├── little_lemon_population.ipynb     # Automated seeding using Faker library
│   └── little_lemon_execution.ipynb       # SQL-Python bridge
├── diagrams/
│   └── database_schema.png    # ERD snapshot
├── docs/
│   ├── population.md    # Stored procedures related to database population
│   └── execution.md    # Stored procedures related to queries execution and booking management
├── data/
│   └── little_lemon_data.xlsx    # Excel file for Tableau ingestion
└── README.md
```

---

## 🏗️ Database Schema
The database is designed in **3rd Normal Form (3NF)** to ensure zero data redundancy and high referential integrity.

### Core Components
| Objective | Table(s) | Description |
| :--- | :--- | :--- |
| **Transactional** | `Orders` and `OrderItems` | Track individual records. |
| **Operational** | `Bookings` and `OrderDeliveryStatus` | Manage reservations and logistics. |
| **Administrative** | `Staff`, `MenuItems` and `CustomerDetails` | Manage the restaurant's core entities.. |

---

## 🐍 Data Automation (Faker Library)
To simulate a production-ready environment, this project moves beyond static `INSERT` statements:
* **Faker Integration:** Utilized the **Python Faker library** to generate unique customer, staff, and address data.
 * **Validated Ingestion:** Data is processed through `Populate` stored procedures that include `IF EXISTS` checks and `SIGNAL SQLSTATE` error handling to prevent orphaned records.
  * **Probabilistic Logic:** The population script simulates real-world variance, such as a **25% takeaway rate** for orders.

> **View the Technical Details:** [🛠️ Data Ingestion & Seeding Documentation](https://github.com/enrodri/db-capstone-project/blob/main/docs/population.md)

---

## 🚀 Business Logic Layer

The system includes a suite of operational procedures designed to manage day-to-day restaurant functions and provide analytical insights.

  * **Booking Management:** Procedures for checking, adding, updating, and cancelling reservations with built-in conflict detection.
  * **Sales Analytics:** Dedicated procedures like `GetMaxQuantity` for inventory optimization.
  * **Python-SQL Bridge:** The `little_lemon_execution.ipynb` notebook demonstrates how these procedures are called programmatically to manage the backend.

> **View the Technical Details:** [🚀 Operational Execution Documentation](https://github.com/enrodri/db-capstone-project/blob/main/docs/execution.md)

-----

## 📊 Business Intelligence (Tableau)

The final phase involves translating normalized SQL data into interactive insights.

**[🔗 View the Interactive Tableau Dashboard](https://public.tableau.com/app/profile/enyel.a.rodr.guez.g./viz/Littlelemoncapstone/Dashboard)**

-----

## 🛠️ Quick Start

1.  **Schema:** Execute `sql/database_schema.sql` to build the database tables.
2.  **Procedures:** Run the scripts in `docs/population_procedures.sql` and `docs/execution_procedures.sql` to register the stored procedures.
3.  **Population:** Run `python_client/little_lemon_population.ipynb` to seed the database with synthetic records.
4.  **Execution:** Use `python_client/little_lemon_execution.ipynb` to test the business logic layer.

# 🍋 Little Lemon: Database Capstone Project
### *Project overview*

This repository contains the complete database solution for Little Lemon, a fictional Mediterranean restaurant. The project demonstrates database proficiency, covering data modeling, advanced SQL programming, Python-to-MySQL integration, and interactive data visualization.

---

## 📂 Project Structure
```text
.
├── sql/
│   ├── database_schema.sql       # ERD implementation and table creation
│   ├── stored_procedures.sql     # Administrative and analytic procedures
│   └── views_and_queries.sql     # Virtual tables and optimized reporting
├── python_client/
│   ├── little_lemon_population.ipynb     # Automated seeding using Faker library
│   └── little_lemon_execution.ipynb       # SQL-Python bridge for reporting
├── diagrams/
│   └── database_schema.png    # ERD snapshot
├── docs/
│   ├── population.md    # Stored procedures related to database population based on the faker library
│   └── execution.md    # Stored procedures related to queries execution and booking management
├── data/
│   └── processed_exports/        # CSV files used for Tableau ingestion
└── README.md
```

---

## 🏗️ Database Schema
The database is designed in **3rd Normal Form (3NF)** to ensure zero data redundancy and high referential integrity.

### Core Tables
| Table | Primary Key | Description |
| :--- | :--- | :--- |
| **Orders** | `OrderID` | Tracks transactions and total bill amounts. |
| **CustomerDetails** | `CustomerID` | Stores PII including names and contact info. |
| **Bookings** | `BookingID` | Manages table reservations and schedules. |
| **OderItems** | `OrderItemID` | Links all requested menu items with their corresponding orders. |
| **MenuItem** | `MenuItemID` | Contains individual dish names and prices. |
| **OrderDeliveryStatus** | `DeliveryID` | Contains all the takeaway requests. |
| **Staff** | `StaffID` | Stores staff info. |

---

## ⚙️ Stored Procedures & Logic
The system implements professional-grade logic to handle restaurant operations.

### 1. Administrative Procedures (CRUD)
| Procedure | Parameters | Purpose |
| :--- | :--- | :--- |
| `AddBooking` | ID, Date, Table, etc. | Validates customer existence before inserting a new booking. |
| `UpdateBooking` | ID, Date | Updates the schedule for an existing reservation. |
| `CancelBooking` | ID | Removes a reservation record from the system. |
| `CancelOrder` | ID | Deletes an order record based on user input. |

### 2. Advanced Transactional Logic
* **`AddValidBooking`**: Utilizing `START TRANSACTION` and `ROLLBACK`, this procedure ensures **ACID compliance**. it checks if a table is already claimed on a specific date before committing a new entry, preventing double-bookings.
* **`CheckBooking`**: A diagnostic tool to verify table availability instantly.

### 3. Analytics & Optimization
* **`GetMaxQuantity`**: A high-performance query to identify the largest single-item order.
* **`PopulateOrders` / `PopulateBookings`**: Custom scripts designed to seed the database with synthetic data for testing.

---

## 🐍 Data Automation (Faker Library)
To simulate a production-ready environment, this project moves beyond static `INSERT` statements:
* **Faker Integration:** Hundreds of unique records were generated using the **Python Faker library**.
* **Relationship Mapping:** The Python scripts dynamically map Foreign Keys between customers and orders, ensuring a realistic and interconnected dataset for analysis.

---

## 📊 Business Intelligence (Tableau Public)
The final analysis was performed by exporting the normalized SQL data into **Tableau Public**.
* **Key Visuals:** Sales by category, high-value customer segmentation (orders > $60), and table occupancy trends.
* **Live Dashboard:** [Insert Your Tableau Public Link Here]
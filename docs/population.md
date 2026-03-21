# 🛠️ Data Ingestion & Synthetic Seeding
### Documentation for `Populate` Stored Procedures

To facilitate high-scale testing and Business Intelligence (BI) analysis, a custom data ingestion layer was developed using MySQL Stored Procedures and the Python Faker library. This approach ensures that synthetic data adheres to the same business logic and relational constraints as production data.

---

## 🏗️ Design Strategy: The "Populate" Prefix
All procedures dedicated to data seeding are prefixed with `Populate_`. This creates a clear distinction between:
* **Application Logic:** (e.g., `AddValidBooking`) – Handles real-time user interactions.
* **Seeding Logic:** (e.g., `PopulateOrders`) – Optimized for batch processing and testing.

---

## 📋 Procedure Catalog & Business Logic

### 1. Core Entity Population
These procedures handle the "Independent" tables that do not rely on foreign keys.
* **`PopulateMenuItems`**: Maps menu offerings by category (Cuisine/Course) and stores both **Price** and **Cost** for margin analysis.

```sql
CREATE PROCEDURE PopulateMenuItems (
    IN p_Name VARCHAR(255), 
    IN p_Type VARCHAR(255), 
    IN p_Cuisine VARCHAR(255), 
    IN p_Price DECIMAL(10,2), 
    IN p_Cost DECIMAL(10,2)
)
BEGIN
    INSERT INTO MenuItem (Name, Type, Cuisine, Price, Cost)
    VALUES (p_Name, p_Type, p_Cuisine, p_Price, p_Cost);
END //
```

* **`PopulateCustomerDetails`**: Generates unique PII (Personal Identifiable Information) including names and contact strings.

```sql
CREATE PROCEDURE PopulateCustomerDetails(
    IN p_FirstName VARCHAR(255),
    IN p_LastName VARCHAR(255),
    IN p_Phone VARCHAR(255),
    IN p_Email VARCHAR(255)
)
BEGIN
    INSERT INTO CustomerDetails (FirstName, LastName, Phone, Email)
    VALUES (p_FirstName, p_LastName, p_Phone, p_Email);
END //
```

* **`PopulateStaff`**: Seeds employee roles and salary tiers.

```sql
CREATE PROCEDURE PopulateStaff(
    IN p_FirstName VARCHAR(255),
    IN p_LastName VARCHAR(255),
    IN p_Email VARCHAR(255),
    IN p_Role VARCHAR(255),
    IN p_Salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO Staff (FirstName, LastName, Email, Role, Salary)
    VALUES (p_FirstName, p_LastName, p_Email, p_Role, p_Salary);
END //
```

### 2. Relational & Transactional Seeding
These procedures include internal validation to prevent "Orphan Records" (data that points to a non-existent parent).

#### **`PopulateBookings`**
* **Logic:** Before insertion, the procedure checks `IF EXISTS` for the `CustomerID`.
* **Integrity:** If a non-existent ID is passed from the Python script, it triggers a `SIGNAL SQLSTATE '45000'`, halting the insertion and preserving data health.

```sql
CREATE PROCEDURE PopulateBookings(
    IN p_Date DATE,
    IN p_Time TIME,
    IN p_ReservedTable INT,
    IN p_GuestCount INT,
    IN p_CustomerReservedID INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM CustomerDetails WHERE CustomerID = p_CustomerReservedID) THEN
        INSERT INTO Bookings (Date, Time, ReservedTable, GuestCount, CustomerReservedID)
        VALUES (p_Date, p_Time, p_ReservedTable, p_GuestCount, p_CustomerReservedID);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer ID does not exist.';
    END IF;
END //
```

#### **`PopulateOrders`**
* **Logic:** Links a transaction to a Customer, a specific Booking event, and a Staff member.

```sql
CREATE PROCEDURE PopulateOrders(
    IN p_OrderDate DATE, 
    IN p_CurrentTable INT,
    IN p_BillAmount DECIMAL(10,2),
    IN p_Discount DECIMAL(10,2),
    IN p_CustomerID INT,
    IN p_BookingID INT,
    IN p_StaffID INT
)
BEGIN
	IF EXISTS (SELECT 1 FROM CustomerDetails WHERE CustomerID = p_CustomerID) THEN
		INSERT INTO Orders (OrderDate, CurrentTable, BillAmount, Discount, CustomerID, BookingID, StaffID)
		VALUES (p_OrderDate, p_CurrentTable, p_BillAmount, p_Discount, p_CustomerID, p_BookingID, p_StaffID);
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer ID does not exist.';
	END IF;
END //
```

### **`PopulateOrderItems`**
* **Logic:** This procedure acts as the relational bridge between a specific transaction and the menu items purchased. 
* **Integrity Check:** It utilizes a **Double Existence Check**. It validates that both the `OrderID` (from the parent table) and the `MenuItemID` (from the catalog) exist before allowing the insertion.
* **Error Handling:** If either ID is missing, it triggers a `SIGNAL SQLSTATE '45000'`. This prevents "orphaned" order items that wouldn't show up correctly in the Tableau dashboard.

```sql
CREATE PROCEDURE PopulateOrderItems(
    IN p_OrderID INT,
    IN p_MenuItemID INT,
    IN p_Quantity INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Orders WHERE OrderID = p_OrderID) 
       AND EXISTS (SELECT 1 FROM MenuItem WHERE MenuItemID = p_MenuItemID) THEN
       
        INSERT INTO OrderItems (OrderID, MenuItemID, Quantity)
        VALUES (p_OrderID, p_MenuItemID, p_Quantity);
        
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Either OrderID or MenuItemID does not exist.';
    END IF;
END //
```

#### **`PopulateDeliveryStatus`**
* **Logic:** Applied to only a subset of orders (simulated **25% takeaway rate** in Python).

```sql
CREATE PROCEDURE PopulateDeliveryStatus(
    IN p_DeliveryDate DATE, 
    IN p_DeliveryStatus VARCHAR(255), 
    IN p_DeliveryAddress VARCHAR(255),
    IN p_OrderID INT
)
BEGIN
	IF EXISTS (SELECT 1 FROM Orders WHERE OrderID = p_OrderID) THEN
		INSERT INTO OrderDeliveryStatus (DeliveryDate, DeliveryStatus, DeliveryAddress, OrderID)
		VALUES (p_DeliveryDate, p_DeliveryStatus, p_DeliveryAddress, p_OrderID);
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order ID does not exist.';
	END IF;
END //
```

---

## 🐍 Python-SQL Integration
The data is fed into these procedures via a Jupyter Notebook workflow.

**Key Features of the Script:**
1. **Relational Sequencing:** Data is inserted in a specific hierarchy (Customers $\rightarrow$ Bookings $\rightarrow$ Orders) to respect Foreign Key constraints.
2. **Batch Persistence:** Utilizing `connection.commit()` at controlled intervals to ensure data stability during 20,000+ row operations.
3. **Probabilistic Simulation:** Python logic is used to decide *if* a delivery record should be created, simulating realistic business variance.

---

## 🛠️ How to Re-Seed the Database
1. Run the `DROP TABLE` statement to clear the schema.
2. Run the `little_lemon` workbench file to forward engineer the schema.
3. Execute the `Population_procedures` SQL scripts to register the procedures.
4. Run the `little_lemon_population.ipynb` notebook.
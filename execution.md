
# 🚀 Business Logic & Operational Execution
### Documentation for Restaurant Management Procedures

This document outlines the operational layer of the Little Lemon database. These procedures manage restaurant operations, including reservation management.

---

## 📅 Booking Management System
The booking system ensures data integrity by validating Customer IDs and checking for existing records before performing updates or deletions.

### 1. `CheckBooking`
Used to verify if a specific table is already reserved on a given date.
* **Input:** `Date`, `TableNumber`
* **Output:** A status message confirming availability.

```sql
CREATE PROCEDURE CheckBooking(
	IN p_Date DATE,
    IN p_ReservedTable INT
)
BEGIN
	IF EXISTS (SELECT 1 FROM Bookings WHERE p_Date = Date AND p_ReservedTable = ReservedTable) THEN
		SELECT CONCAT("Table ", p_ReservedTable, " is already booked") AS "Booking status";
    ELSE
		SELECT CONCAT("Table ", p_ReservedTable, " is available") AS "Booking status";
    END IF;
END //
```

```sql
CALL CheckBooking("2022-11-12", 3);
```

### 2. `AddBooking`
Safely adds a new reservation. It performs a dual check: ensuring the `BookingID` is unique and verifying that the `CustomerID` exists in the system.

```sql
CREATE PROCEDURE AddBooking(
    IN p_BookingID INT,
    IN p_Date DATE,
    IN p_Time TIME,
    IN p_ReservedTable INT,
    IN p_GuestCount INT,
    IN p_CustomerReservedID INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Bookings WHERE BookingID = p_BookingID) THEN
		IF EXISTS (SELECT 1 FROM CustomerDetails WHERE CustomerID = p_CustomerReservedID) THEN
			INSERT INTO Bookings (BookingID, Date, Time, ReservedTable, GuestCount, CustomerReservedID)
			VALUES (p_BookingID, p_Date, p_Time, p_ReservedTable, p_GuestCount, p_CustomerReservedID);
            SELECT CONCAT("New booking ", p_BookingID, " added") AS "Confirmation";
		ELSE
			SELECT CONCAT("Customer ID ", p_CustomerReservedID, " does not exist, try again") AS "Error";
		END IF;
    ELSE 
		SELECT CONCAT("Booking ID ", p_BookingID, " already in use") AS "Error";
	END IF;
END //
```

```sql
CALL AddBooking(9, "2022-12-30", "18:00:00", 4, 3, 1);
```

### 3. `UpdateBooking` & `CancelBooking`
These procedures allow for the dynamic modification of the reservation ledger. They include error handling to notify the user if they attempt to modify a non-existent Booking ID.

```sql
CREATE PROCEDURE UpdateBooking(
    IN p_BookingID INT,
    IN p_Date DATE,
    IN p_Time TIME,
    IN p_ReservedTable INT,
    IN p_GuestCount INT,
    IN p_CustomerReservedID INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Bookings WHERE BookingID = p_BookingID) THEN
        UPDATE Bookings 
        SET Date = p_Date, 
            Time = p_Time, 
            ReservedTable = p_ReservedTable, 
            GuestCount = p_GuestCount, 
            CustomerReservedID = p_CustomerReservedID
        WHERE BookingID = p_BookingID;
        SELECT CONCAT("Booking ", p_BookingID, " updated") AS "Confirmation";
    ELSE
        SELECT CONCAT("Booking ID ", p_BookingID, " does not exist") AS "Error";
    END IF;
END //
```

```sql
CREATE PROCEDURE CancelBooking(
    IN p_BookingID INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Bookings WHERE BookingID = p_BookingID) THEN
        DELETE FROM Bookings 
        WHERE BookingID = p_BookingID;
        SELECT CONCAT("Booking ", p_BookingID, " cancelled") AS "Confirmation";
    ELSE
        SELECT CONCAT("Booking ID ", p_BookingID, " does not exist") AS "Error";
    END IF;
END //
```

---

## 📈 Administrative Analytics
These procedures are designed to provide quick insights into restaurant performance.

### `GetMaxQuantity`
Identifies the highest quantity of a single item ever ordered.

```sql
CREATE PROCEDURE `GetMaxQuantity`()
BEGIN
	SELECT MAX(Quantity) AS "Max Quantity in Order" FROM OrderItems;
END //
```

```sql
CALL GetMaxQuantity();
```
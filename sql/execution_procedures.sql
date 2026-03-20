DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `AddBooking`(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `AddValidBooking`(
	IN p_Date DATE,
    IN p_Time TIME,
    IN p_ReservedTable INT,
    IN p_GuestCount INT,
    IN p_CustomerReservedID INT
)
BEGIN
	DECLARE v_booking_status VARCHAR (255);
    START TRANSACTION;
    IF EXISTS (SELECT 1 FROM Bookings WHERE p_Date = Date AND p_ReservedTable = ReservedTable) THEN
		ROLLBACK;
        SET v_booking_status = CONCAT("Table ", p_ReservedTable, " is already booked - booking cancelled");
    ELSE
		INSERT INTO Bookings (Date, Time, ReservedTable, GuestCount, CustomerReservedID)
        VALUES (p_Date, p_Time, p_ReservedTable, p_GuestCount, p_CustomerReservedID);
        COMMIT;
        SET v_booking_status = CONCAT("Table ", p_ReservedTable, " is available - booking successful");
    END IF;
    
    SELECT v_booking_status AS "Booking status";
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `CancelBooking`(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `CancelOrder`(IN p_OrderID INT)
BEGIN
    DELETE FROM Orders 
    WHERE OrderID = p_OrderID;
    SELECT CONCAT("Order ", p_OrderID, " is cancelled") AS Confirmation;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `CheckBooking`(
	IN p_Date DATE,
    IN p_ReservedTable INT
)
BEGIN
	IF EXISTS (SELECT 1 FROM Bookings WHERE p_Date = Date AND p_ReservedTable = ReservedTable) THEN
		SELECT CONCAT("Table ", p_ReservedTable, " is already booked") AS "Booking status";
    ELSE
		SELECT CONCAT("Table ", p_ReservedTable, " is available") AS "Booking status";
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `GetMaxQuantity`()
BEGIN
	SELECT MAX(Quantity) AS "Max Quantity in Order" FROM OrderItems;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `UpdateBooking`(
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
END$$
DELIMITER ;

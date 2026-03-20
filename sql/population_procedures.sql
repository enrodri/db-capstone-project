DELIMITER //

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
    END IF;DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `PopulateBookings`(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `PopulateCustomerDetails`(
    IN p_FirstName VARCHAR(255),
    IN p_LastName VARCHAR(255),
    IN p_Phone VARCHAR(255),
    IN p_Email VARCHAR(255)
)
BEGIN
    INSERT INTO CustomerDetails (FirstName, LastName, Phone, Email)
    VALUES (p_FirstName, p_LastName, p_Phone, p_Email);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `PopulateDeliveryStatus`(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `PopulateMenuItems`(
    IN p_Name VARCHAR(255), 
    IN p_Type VARCHAR(255), 
    IN p_Cuisine VARCHAR(255), 
    IN p_Price DECIMAL(10,2), 
    IN p_Cost DECIMAL(10,2)
)
BEGIN
    INSERT INTO MenuItem (Name, Type, Cuisine, Price, Cost)
    VALUES (p_Name, p_Type, p_Cuisine, p_Price, p_Cost);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `PopulateOrderItems`(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `PopulateOrders`(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`little_lemon`@`%` PROCEDURE `PopulateStaff`(
    IN p_FirstName VARCHAR(255),
    IN p_LastName VARCHAR(255),
    IN p_Email VARCHAR(255),
    IN p_Role VARCHAR(255),
    IN p_Salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO Staff (FirstName, LastName, Email, Role, Salary)
    VALUES (p_FirstName, p_LastName, p_Email, p_Role, p_Salary);
END$$
DELIMITER ;

END //

DELIMITER ;
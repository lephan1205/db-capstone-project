---
jupyter:
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
  language_info:
    codemirror_mode:
      name: ipython
      version: 3
    file_extension: .py
    mimetype: text/x-python
    name: python
    nbconvert_exporter: python
    pygments_lexer: ipython3
    version: 3.11.5
  nbformat: 4
  nbformat_minor: 5
---

::: {#1c71e3ed-dcbf-49c1-8ce3-82c82b873c6f .cell .markdown}
# Little Lemon Restaurant Database

```{=html}
<hr/>
```
:::

::: {#c21582fd-9aac-43b7-b31e-9a33c429acd1 .cell .markdown}
-   [Project Description](#description)
-   [Entity-Relationship Diagram](#erp)
-   [Installation and Setup](#setup)
-   [Stored Procedures](#procedures)
    -   [AddValidBooking](#addvalidbooking)
    -   [CheckBooking](#checkbooking)
    -   [UpdateBooking](#updatebooking)
    -   [CancelBooking](#cancelbooking)
    -   [CancelOrder](#cancelorder)
    -   [AddBooking](#addbooking)
    -   [GetMaxQuantity](#getmax)
-   [Data Analysis with Tableau](#tableau)
    -   [Customer Sales](#customersales)
    -   [Profit Chart](#profitchart)
    -   [Sales Bubble Chart](#salesbubble)
    -   [Cuisine Sales and Profit](#cuisinesales)
    -   [Customer Sales Dashboard](#salesdashboard)
:::

::: {#8f9b4776-53b9-4ac3-8d9b-5600fd4c193b .cell .markdown}
`<a id="description">`{=html}`</a>`{=html}

## Project Description

```{=html}
<hr/>
```
:::

::: {#f9c95b85-ce9b-4e19-95e6-4200d64d2e31 .cell .markdown}
This project is part of **Meta Database Engineer Certificate** courses
on Coursera. The project designs and implements a relational database
system for Little Lemon Restaurant. MySQL is used for data modeling and
Tableau is used for data analytics and visualization.
:::

::: {#76f2b118-22e3-4e6b-a091-36c73a970aa8 .cell .markdown}
`<a id="erp">`{=html}`</a>`{=html}

## Entity-Relationship Diagram

```{=html}
<hr/>
```
:::

::: {#275ad753-424f-4e8d-8021-f97837c3194a .cell .markdown}
The database maintains the following information about the business:

-   Bookings
-   Orders
-   Order delivery status
-   Menu
-   Customer details
-   Staff information

The entity-relationship (ER)
[diagram](../db-capstone-project/images/diagram.png) below displays the
relationships between these entities. `<p>`{=html}
`<center>`{=html}`<img src="../db-capstone-project/images/diagram.png">`{=html}
`</p>`{=html}
:::

::: {#0c30d639-3c8c-4974-9b5c-5384dac83396 .cell .markdown}
`<a id="setup">`{=html}`</a>`{=html}

## Installation and Setup

```{=html}
<hr/>
```
:::

::: {#7f4853a2-b478-4947-8d5f-c67aa30d5abd .cell .markdown}
Follow the steps below to setup the database:

1.  **Install MySQL:** Download and install MySQL Server and MySQL
    Workbench on your machine.

2.  **Download SQL File:** Download the
    [little_lemon_db.sql](../db-capstone-project/little_lemon_db.sql)
    file from this repository.

3.  **Import and Execute in MySQL Workbench:**

    -   Open MySQL Workbench
    -   Navigate to `Server` \> `Data Import`
    -   Select `Import from Self-Contained Files` from the
        `Import Options` pane and load the `little_lemon_db.sql` file.
    -   Click `Start Import` to load and execute the SQL commands from
        the file.

The database is now set up with tables and stored procedures populated.
:::

::: {#185a6698-4b8d-4374-99b7-70d159d9267d .cell .markdown}
`<a id="procedures">`{=html}`</a>`{=html}

## Stored Procedures

```{=html}
<hr/>
```
:::

::: {#9006d3f3-4abe-472b-b4a6-f8d14a88163b .cell .markdown}
`<a id="addvalidbooking">`{=html}`</a>`{=html}

### AddValidBooking
:::

::: {#21d95401-2f24-4deb-93ee-ba8ca8a486f8 .cell .markdown}
This stored procedure uses a **transaction statement** to perform a
**rollback** if a customer reserves a table that is already booked at
the specified datetime. Otherwise, a new valid reservation is added to
the database. The procedure takes four input parameters (booking
datetime, table number, customer id, and staff id) and output a message
either confirming valid reservation is completed or the table has been
booked and the reservation attempt is therefore cancelled.
:::

::: {#5ddbdc9f-0b42-48e7-a471-823ab49ea601 .cell .markdown}
``` sql
DELIMITER //
CREATE PROCEDURE AddValidBooking(IN booking_datetime DATETIME, IN booking_table INT, IN customer_id INT, IN staff_id INT)
BEGIN
	DECLARE booking_count INT;
    START TRANSACTION;
    
    SELECT COUNT(*) INTO booking_count
    FROM Bookings
    WHERE Date = booking_datetime AND TableNumber = booking_table;
    
    IF booking_count > 0 THEN
		ROLLBACK;
        SELECT CONCAT("Table ", booking_table, " is unavailable -- booking cancelled!") AS 'Status';
	ELSE
		INSERT INTO Bookings(CustomerID, StaffID, Date, TableNumber)
        VALUES(customer_id, staff_id, booking_datetime, booking_table);
        
        COMMIT;
        SELECT CONCAT("Booking successfully completed for table ", booking_table);
    END IF;
END //
DELIMITER ;
```
:::

::: {#bf5b64b8-f8fa-48fa-bee4-48d53cddfec6 .cell .markdown}
``` sql
CALL AddValidBooking("2024-02-02 12:30:00", 3, 6, 2);
```
:::

::: {#94ba53cd-92f2-4baa-b3a4-d1dda29fb031 .cell .markdown}
`<a id="checkbooking">`{=html}`</a>`{=html}

### CheckBooking
:::

::: {#f108b58d-c465-4e9d-bec5-59675a1317ec .cell .markdown}
This stored procedure checks whether a table in the restaurant is
already booked. It takes two input parameters in the form of booking
datetime and table number. It outputs a message indicating whether the
specified table is already booked or is available.
:::

::: {#a88f801d-6b1a-46c8-a07b-341570cc94cf .cell .markdown}
``` sql
DELIMITER //
CREATE PROCEDURE CheckBooking(IN booking_datetime DATETIME, IN booking_table INT)
BEGIN
	DECLARE booking_count INT;
    DECLARE table_status VARCHAR(45);
    
	SELECT COUNT(*) INTO booking_count 
	FROM Bookings
	WHERE Date = booking_datetime AND TableNumber = booking_table;

	IF booking_count > 0 THEN 
		SET table_status = 'already booked';
	ELSE
		SET table_status = 'available';
	END IF;
    
    SELECT CONCAT('Table ', booking_table, ' is ', table_status);
END //
DELIMITER ;
```
:::

::: {#d863fc1f-2d83-4842-9e9b-530751d27a4a .cell .markdown}
``` sql
CALL CheckBooking("2024-02-01 12:00:00", 5);
```
:::

::: {#c57ad33a-3c2e-4c16-a059-801d904520c1 .cell .markdown}
`<a id="updatebooking">`{=html}`</a>`{=html}

### UpdateBooking
:::

::: {#3f0a5e0e-36ff-49ae-846a-af3fa622e5e5 .cell .markdown}
This stored procedure update existing bookings in the `Bookings` table.
It takes two input parameters (booking id and new datetime) and output a
messge indicating the booking is updated.
:::

::: {#bfa12009-ee1e-4a88-b987-c9ccf5b9dc5e .cell .markdown}
``` sql
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN booking_id INT, IN new_datetime DATETIME)
BEGIN
	UPDATE Bookings
    SET Date = new_datetime
    WHERE BookingID = booking_id;
    
    SELECT CONCAT("Booking ", booking_id, " updated.") AS "Confirmation";
END //
DELIMITER ;
```
:::

::: {#e74c5043-1994-48d9-85b2-85e2bbaea0f8 .cell .markdown}
``` sql
CALL UpdateBooking(9, "2024-02-01 12:30:00")
```
:::

::: {#1299f2ce-b132-4606-ba2c-06a7258ab0ae .cell .markdown}
`<a id="cancelbooking">`{=html}`</a>`{=html}

### CancelBooking
:::

::: {#227463b0-4862-4924-a730-341d8e78168a .cell .markdown}
This stored procedure cancels an existing booking by deleting it from
the `Bookings` table. It takes a booking id as input and output a
confirmation message indicating the specified booking is cancelled.
:::

::: {#812d84e7-c7eb-431e-9460-820a53209294 .cell .markdown}
``` sql
DELIMITER //
CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
	DELETE FROM Bookings
    WHERE BookingID = booking_id;
    
    SELECT CONCAT("Booking ", booking_id, " is cancelled.") AS "Confirmation";
END //
DELIMITER ;
```
:::

::: {#8257d83e-2f18-4031-a720-7e9f51c90c48 .cell .markdown}
``` sql
CALL CancelBooking(9)
```
:::

::: {#b6f7d5d9-0990-488f-9000-4674fc5ae8fd .cell .markdown}
`<a id="cancelorder">`{=html}`</a>`{=html}

### CancelOrder
:::

::: {#0568e2d9-34a3-4188-8431-a150077934d6 .cell .markdown}
This stored procedure is used to delete an order record based on the
user input of the order id.
:::

::: {#a677bd7d-f303-4de6-9b75-2e6cb3a8e3bd .cell .markdown}
``` sql
DELIMITER //
CREATE PROCEDURE CancelOrder(IN delete_order_id INT)
BEGIN
	DECLARE order_quantity INT;
    SELECT Quanity INTO order_quantity FROM Orders WHERE OrderID = delete_order_id;
    IF order_quantity > 0 THEN
		DELETE FROM Orders WHERE OrderID = delete_order_id;
        DELETE FROM OrderDeliveryStatuses WHERE OrderID = delete_order_id;
        SELECT CONCAT('Order ', delete_order_id, ' is cancelled') AS 'Confirmation';
	ELSE
		SELECT CONCAT('Order ', delete_order_id, ' does not exist') AS 'Confirmation';
	END IF;
END //
DELIMITER ;
```
:::

::: {#2c7ca1bd-b7b0-419b-bd99-7a06c887f74b .cell .markdown}
``` sql
CALL CancelOrder(5)
```
:::

::: {#3b2f5b03-5abd-4448-b142-fd3a180047f9 .cell .markdown}
`<a id="addbooking">`{=html}`</a>`{=html}

### AddBooking
:::

::: {#5e0c77e2-490b-4793-a7a0-d57ad3de55ab .cell .markdown}
This store procedure add new booking to the `Bookings` table. It takes
four input parameters (booking datetime, table number, customer id, and
staff id) and output a message confirming the new table reservation.
:::

::: {#34e4dda9-564c-4697-949c-bf14a2ed1276 .cell .markdown}
``` sql
DELIMITER //
CREATE DPROCEDURE AddBooking(
	IN booking_id INT,
    IN customer_id INT,
    IN staff_id INT,
    IN booking_datetime DATETIME,
    IN booking_table INT
)
BEGIN
	INSERT INTO Bookings(BookingID, CustomerID, StaffID, Date, TableNumber)
    VALUES(booking_id, customer_id, staff_id, booking_datetime, booking_table);
    
    SELECT "New booking added." AS "Confirmation";
END //
DELIMITER ;
```
:::

::: {#f16cfa4a-c65b-4199-bc40-8b01a57fe7d9 .cell .markdown}
``` sql
CALL AddBooking("2024-02-02 12:30:00", 3, 6, 2)
```
:::

::: {#2a014506-941d-4dbe-8ab9-6c118a34b92d .cell .markdown}
`<a id="getmax">`{=html}`</a>`{=html}

### GetMaxQuanity
:::

::: {#f7b42fc6-6ce6-485c-bd53-4131eeffe57b .cell .markdown}
This stored procedure retrieve the maximum order quantity in the
`Orders` table.
:::

::: {#2a86c81f-27c2-41ab-964e-7ffc4e446087 .cell .markdown}
``` sql
DELIMITER //
CREATE PROCEDURE GetMaxQuanity()
BEGIN
	DECLARE max_quantity INT;
    SELECT MAX(Quantity) INTO max_quantity FROM Orders;
    SELECT max_quantity AS 'Max Quanity in Order';
END //
DELIMITER ;
```
:::

::: {#77456408-a127-4c33-ae78-c480a0f270a1 .cell .markdown}
``` sql
CALL GetMaxQuantity()
```
:::

::: {#611c6762-fe90-495a-aba4-2ea925641b35 .cell .markdown}
`<a id="tableau">`{=html}`</a>`{=html}

## Data Analysis with Tableau

```{=html}
<hr/>
```
:::

::: {#60c2d699-83ec-4504-b0d2-668cc0104753 .cell .markdown}
You may view the interactive dashboard or download the complete Tableau
Public workbork
[`<u>`{=html}here`</u>`{=html}](https://public.tableau.com/app/profile/le.phan3723/viz/little-lemon-restaurant-sales-analysis/CustomerSalesDashboard)
on my Tableau Public profile. This workbook contains the following
analyses:

1.  Customer Sales
2.  Profit Chart
3.  Sales Bubble Chart
4.  Cuisine Sales and Profits
5.  Customer Sales Dashboard
:::

::: {#f8d8acd5-0f57-4220-ac57-214e362c1d07 .cell .markdown}
`<a id="customersales">`{=html}`</a>`{=html}

### Customer Sales
:::

::: {#cc37d420-0c09-4d6b-a3df-a037bd755b7f .cell .markdown}
![images](../db-capstone-project/images/little-lemon-customer-sales.png)
:::

::: {#44e68747-8b77-4f6a-a0a6-5e630aeb2541 .cell .markdown}
`<a id="profitchart">`{=html}`</a>`{=html}

### Profit Chart
:::

::: {#39ca183d-bf2a-405f-8d8a-5b575325701b .cell .markdown}
![images](../db-capstone-project/images/little-lemon-profit-chart.png)
:::

::: {#9ebd116a-96eb-478d-92c5-d549c23bde03 .cell .markdown}
`<a id="salesbubble">`{=html}`</a>`{=html}

### Sales Bubble Chart
:::

::: {#6e6d3632-56bd-4c64-ae4c-3dabab3c7aa6 .cell .markdown}
![images](../db-capstone-project/images/little-lemon-sales-bubble-chart.png)
:::

::: {#f29d8ac6-1b72-4868-b7f4-7e136e5b8996 .cell .markdown}
`<a id="cuisinesales">`{=html}`</a>`{=html}

### Cuisine Sales and Profit
:::

::: {#eed8c98c-43fc-487e-96e1-22f7b4733685 .cell .markdown}
![images](../db-capstone-project/images/little-lemon-cuisine-sales-and-profit-chart.png)
:::

::: {#fd69ffa5-be70-4a96-875c-bcbcf889150b .cell .markdown}
`<a id="salesdashboard" >`{=html} `</a>`{=html}

### Customer Sales Dashboard
:::

::: {#2fbf3641-0ead-4cc2-850e-ded4dd1901ba .cell .markdown}
![images](../db-capstone-project/images/little-lemon-interactive-dashboard.png)
:::

::: {#4815e5a0-6875-4c91-b690-d17cc2898356 .cell .code}
``` python
```
:::

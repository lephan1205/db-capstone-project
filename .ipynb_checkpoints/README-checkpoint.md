{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "1c71e3ed-dcbf-49c1-8ce3-82c82b873c6f",
   "metadata": {},
   "source": [
    "# Little Lemon Restaurant Database\n",
    "<hr/>"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "c21582fd-9aac-43b7-b31e-9a33c429acd1",
   "metadata": {},
   "source": [
    "- [Project Description](#description)\n",
    "- [Entity-Relationship Diagram](#erp)\n",
    "- [Installation and Setup](#setup)\n",
    "- [Stored Procedures](#procedures)\n",
    "    - [AddValidBooking](#addvalidbooking)\n",
    "    - [CheckBooking](#checkbooking)\n",
    "    - [UpdateBooking](#updatebooking)\n",
    "    - [CancelBooking](#cancelbooking)\n",
    "    - [CancelOrder](#cancelorder)\n",
    "    - [AddBooking](#addbooking)\n",
    "    - [GetMaxQuantity](#getmax)\n",
    "- [Data Analysis with Tableau](#tableau)\n",
    "    - [Customer Sales](#customersales)\n",
    "    - [Profit Chart](#profitchart)\n",
    "    - [Sales Bubble Chart](#salesbubble)\n",
    "    - [Cuisine Sales and Profit](#cuisinesales)\n",
    "    - [Customer Sales Dashboard](#salesdashboard)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "8f9b4776-53b9-4ac3-8d9b-5600fd4c193b",
   "metadata": {},
   "source": [
    "<a id=\"description\"></a>\n",
    "## Project Description\n",
    "<hr/>"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f9c95b85-ce9b-4e19-95e6-4200d64d2e31",
   "metadata": {},
   "source": [
    "This project is part of **Meta Database Engineer Certificate** courses on Coursera.  The project designs and implements a relational database system for Little Lemon Restaurant.  MySQL is used for data modeling and Tableau is used for data analytics and visualization."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "76f2b118-22e3-4e6b-a091-36c73a970aa8",
   "metadata": {},
   "source": [
    "<a id=\"erp\"></a>\n",
    "## Entity-Relationship Diagram\n",
    "<hr/>"
   ]
  },
  {
   "attachments": {},
   "cell_type": "markdown",
   "id": "275ad753-424f-4e8d-8021-f97837c3194a",
   "metadata": {},
   "source": [
    "The database maintains the following information about the business:\n",
    "* Bookings\n",
    "* Orders\n",
    "* Order delivery status\n",
    "* Menu\n",
    "* Customer details\n",
    "* Staff information\n",
    "\n",
    "The entity-relationship (ER) [diagram](../db-capstone-project/images/diagram.png) below displays the relationships between these entities.\n",
    "<p>\n",
    "    <center><img src=\"../db-capstone-project/images/diagram.png\">\n",
    "</p>"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "0c30d639-3c8c-4974-9b5c-5384dac83396",
   "metadata": {},
   "source": [
    "<a id=\"setup\"></a>\n",
    "## Installation and Setup\n",
    "<hr/>"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "7f4853a2-b478-4947-8d5f-c67aa30d5abd",
   "metadata": {},
   "source": [
    "Follow the steps below to setup the database:\n",
    "1. **Install MySQL:**  Download and install MySQL Server and MySQL Workbench on your machine.\n",
    "2. **Download SQL File:** Download the [little_lemon_db.sql](../db-capstone-project/little_lemon_db.sql) file  from this repository.\n",
    "3. **Import and Execute in MySQL Workbench:**\n",
    "\n",
    "    * Open MySQL Workbench\n",
    "    * Navigate to `Server` > `Data Import`\n",
    "    * Select `Import from Self-Contained Files` from the `Import Options` pane and load the `little_lemon_db.sql` file.\n",
    "    * Click `Start Import` to load and execute the SQL commands from the file.\n",
    "\n",
    "The database is now set up with tables and stored procedures populated."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "185a6698-4b8d-4374-99b7-70d159d9267d",
   "metadata": {},
   "source": [
    "<a id=\"procedures\"></a>\n",
    "## Stored Procedures\n",
    "<hr/>"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "9006d3f3-4abe-472b-b4a6-f8d14a88163b",
   "metadata": {},
   "source": [
    "<a id=\"addvalidbooking\"></a>\n",
    "### AddValidBooking"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "21d95401-2f24-4deb-93ee-ba8ca8a486f8",
   "metadata": {},
   "source": [
    "This stored procedure uses a **transaction statement** to perform a **rollback** if a customer reserves a table that is already booked at the specified datetime.  Otherwise, a new valid reservation is added to the database.  The procedure takes four input parameters (booking datetime, table number, customer id, and staff id) and output a message either confirming valid reservation is completed or the table has been booked and the reservation attempt is therefore cancelled."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "5ddbdc9f-0b42-48e7-a471-823ab49ea601",
   "metadata": {},
   "source": [
    "```sql\n",
    "DELIMITER //\n",
    "CREATE PROCEDURE AddValidBooking(IN booking_datetime DATETIME, IN booking_table INT, IN customer_id INT, IN staff_id INT)\n",
    "BEGIN\n",
    "\tDECLARE booking_count INT;\n",
    "    START TRANSACTION;\n",
    "    \n",
    "    SELECT COUNT(*) INTO booking_count\n",
    "    FROM Bookings\n",
    "    WHERE Date = booking_datetime AND TableNumber = booking_table;\n",
    "    \n",
    "    IF booking_count > 0 THEN\n",
    "\t\tROLLBACK;\n",
    "        SELECT CONCAT(\"Table \", booking_table, \" is unavailable -- booking cancelled!\") AS 'Status';\n",
    "\tELSE\n",
    "\t\tINSERT INTO Bookings(CustomerID, StaffID, Date, TableNumber)\n",
    "        VALUES(customer_id, staff_id, booking_datetime, booking_table);\n",
    "        \n",
    "        COMMIT;\n",
    "        SELECT CONCAT(\"Booking successfully completed for table \", booking_table);\n",
    "    END IF;\n",
    "END //\n",
    "DELIMITER ;\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "bf5b64b8-f8fa-48fa-bee4-48d53cddfec6",
   "metadata": {},
   "source": [
    "```sql\n",
    "CALL AddValidBooking(\"2024-02-02 12:30:00\", 3, 6, 2);\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "94ba53cd-92f2-4baa-b3a4-d1dda29fb031",
   "metadata": {},
   "source": [
    "<a id=\"checkbooking\"></a>\n",
    "### CheckBooking"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f108b58d-c465-4e9d-bec5-59675a1317ec",
   "metadata": {},
   "source": [
    "This stored procedure checks whether a table in the restaurant is already booked.  It takes two input parameters in the form of booking datetime and table number.  It outputs a message indicating whether the specified table is already booked or is available."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "a88f801d-6b1a-46c8-a07b-341570cc94cf",
   "metadata": {},
   "source": [
    "```sql\n",
    "DELIMITER //\n",
    "CREATE PROCEDURE CheckBooking(IN booking_datetime DATETIME, IN booking_table INT)\n",
    "BEGIN\n",
    "\tDECLARE booking_count INT;\n",
    "    DECLARE table_status VARCHAR(45);\n",
    "    \n",
    "\tSELECT COUNT(*) INTO booking_count \n",
    "\tFROM Bookings\n",
    "\tWHERE Date = booking_datetime AND TableNumber = booking_table;\n",
    "\n",
    "\tIF booking_count > 0 THEN \n",
    "\t\tSET table_status = 'already booked';\n",
    "\tELSE\n",
    "\t\tSET table_status = 'available';\n",
    "\tEND IF;\n",
    "    \n",
    "    SELECT CONCAT('Table ', booking_table, ' is ', table_status);\n",
    "END //\n",
    "DELIMITER ;\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "d863fc1f-2d83-4842-9e9b-530751d27a4a",
   "metadata": {},
   "source": [
    "```sql\n",
    "CALL CheckBooking(\"2024-02-01 12:00:00\", 5);\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "c57ad33a-3c2e-4c16-a059-801d904520c1",
   "metadata": {},
   "source": [
    "<a id=\"updatebooking\"></a>\n",
    "### UpdateBooking"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "3f0a5e0e-36ff-49ae-846a-af3fa622e5e5",
   "metadata": {},
   "source": [
    "This stored procedure update existing bookings in the `Bookings` table.  It takes two input parameters (booking id and new datetime) and output a messge indicating the booking is updated."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "bfa12009-ee1e-4a88-b987-c9ccf5b9dc5e",
   "metadata": {},
   "source": [
    "```sql\n",
    "DELIMITER //\n",
    "CREATE PROCEDURE UpdateBooking(IN booking_id INT, IN new_datetime DATETIME)\n",
    "BEGIN\n",
    "\tUPDATE Bookings\n",
    "    SET Date = new_datetime\n",
    "    WHERE BookingID = booking_id;\n",
    "    \n",
    "    SELECT CONCAT(\"Booking \", booking_id, \" updated.\") AS \"Confirmation\";\n",
    "END //\n",
    "DELIMITER ;\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "e74c5043-1994-48d9-85b2-85e2bbaea0f8",
   "metadata": {},
   "source": [
    "```sql\n",
    "CALL UpdateBooking(9, \"2024-02-01 12:30:00\")\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "1299f2ce-b132-4606-ba2c-06a7258ab0ae",
   "metadata": {},
   "source": [
    "<a id=\"cancelbooking\"></a>\n",
    "### CancelBooking"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "227463b0-4862-4924-a730-341d8e78168a",
   "metadata": {},
   "source": [
    "This stored procedure cancels an existing booking by deleting it from the `Bookings` table.  It takes a booking id as input and output a confirmation message indicating the specified booking is cancelled."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "812d84e7-c7eb-431e-9460-820a53209294",
   "metadata": {},
   "source": [
    "```sql\n",
    "DELIMITER //\n",
    "CREATE PROCEDURE CancelBooking(IN booking_id INT)\n",
    "BEGIN\n",
    "\tDELETE FROM Bookings\n",
    "    WHERE BookingID = booking_id;\n",
    "    \n",
    "    SELECT CONCAT(\"Booking \", booking_id, \" is cancelled.\") AS \"Confirmation\";\n",
    "END //\n",
    "DELIMITER ;\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "8257d83e-2f18-4031-a720-7e9f51c90c48",
   "metadata": {},
   "source": [
    "```sql\n",
    "CALL CancelBooking(9)\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "b6f7d5d9-0990-488f-9000-4674fc5ae8fd",
   "metadata": {},
   "source": [
    "<a id=\"cancelorder\"></a>\n",
    "### CancelOrder"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "0568e2d9-34a3-4188-8431-a150077934d6",
   "metadata": {},
   "source": [
    "This stored procedure is used to delete an order record based on the user input of the order id.  "
   ]
  },
  {
   "cell_type": "markdown",
   "id": "a677bd7d-f303-4de6-9b75-2e6cb3a8e3bd",
   "metadata": {},
   "source": [
    "```sql\n",
    "DELIMITER //\n",
    "CREATE PROCEDURE CancelOrder(IN delete_order_id INT)\n",
    "BEGIN\n",
    "\tDECLARE order_quantity INT;\n",
    "    SELECT Quanity INTO order_quantity FROM Orders WHERE OrderID = delete_order_id;\n",
    "    IF order_quantity > 0 THEN\n",
    "\t\tDELETE FROM Orders WHERE OrderID = delete_order_id;\n",
    "        DELETE FROM OrderDeliveryStatuses WHERE OrderID = delete_order_id;\n",
    "        SELECT CONCAT('Order ', delete_order_id, ' is cancelled') AS 'Confirmation';\n",
    "\tELSE\n",
    "\t\tSELECT CONCAT('Order ', delete_order_id, ' does not exist') AS 'Confirmation';\n",
    "\tEND IF;\n",
    "END //\n",
    "DELIMITER ;\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "2c7ca1bd-b7b0-419b-bd99-7a06c887f74b",
   "metadata": {},
   "source": [
    "```sql\n",
    "CALL CancelOrder(5)\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "3b2f5b03-5abd-4448-b142-fd3a180047f9",
   "metadata": {},
   "source": [
    "<a id=\"addbooking\"></a>\n",
    "### AddBooking"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "5e0c77e2-490b-4793-a7a0-d57ad3de55ab",
   "metadata": {},
   "source": [
    "This store procedure add new booking to the `Bookings` table.  It takes four input parameters (booking datetime, table number, customer id, and staff id) and output a message confirming the new table reservation."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "34e4dda9-564c-4697-949c-bf14a2ed1276",
   "metadata": {},
   "source": [
    "```sql\n",
    "DELIMITER //\n",
    "CREATE DPROCEDURE AddBooking(\n",
    "\tIN booking_id INT,\n",
    "    IN customer_id INT,\n",
    "    IN staff_id INT,\n",
    "    IN booking_datetime DATETIME,\n",
    "    IN booking_table INT\n",
    ")\n",
    "BEGIN\n",
    "\tINSERT INTO Bookings(BookingID, CustomerID, StaffID, Date, TableNumber)\n",
    "    VALUES(booking_id, customer_id, staff_id, booking_datetime, booking_table);\n",
    "    \n",
    "    SELECT \"New booking added.\" AS \"Confirmation\";\n",
    "END //\n",
    "DELIMITER ;\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f16cfa4a-c65b-4199-bc40-8b01a57fe7d9",
   "metadata": {},
   "source": [
    "```sql\n",
    "CALL AddBooking(\"2024-02-02 12:30:00\", 3, 6, 2)\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "2a014506-941d-4dbe-8ab9-6c118a34b92d",
   "metadata": {},
   "source": [
    "<a id=\"getmax\"></a>\n",
    "### GetMaxQuanity"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f7b42fc6-6ce6-485c-bd53-4131eeffe57b",
   "metadata": {},
   "source": [
    "This stored procedure retrieve the maximum order quantity in the `Orders` table."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "2a86c81f-27c2-41ab-964e-7ffc4e446087",
   "metadata": {},
   "source": [
    "```sql\n",
    "DELIMITER //\n",
    "CREATE PROCEDURE GetMaxQuanity()\n",
    "BEGIN\n",
    "\tDECLARE max_quantity INT;\n",
    "    SELECT MAX(Quantity) INTO max_quantity FROM Orders;\n",
    "    SELECT max_quantity AS 'Max Quanity in Order';\n",
    "END //\n",
    "DELIMITER ;\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "77456408-a127-4c33-ae78-c480a0f270a1",
   "metadata": {},
   "source": [
    "```sql\n",
    "CALL GetMaxQuantity()\n",
    "```"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "611c6762-fe90-495a-aba4-2ea925641b35",
   "metadata": {},
   "source": [
    "<a id=\"tableau\"></a>\n",
    "## Data Analysis with Tableau\n",
    "<hr/>"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "60c2d699-83ec-4504-b0d2-668cc0104753",
   "metadata": {},
   "source": [
    "You may view the interactive dashboard or download the complete Tableau Public workbork [<u>here</u>](https://public.tableau.com/app/profile/le.phan3723/viz/little-lemon-restaurant-sales-analysis/CustomerSalesDashboard) on my Tableau Public profile. This workbook contains the following analyses:\n",
    "1. Customer Sales\n",
    "2. Profit Chart\n",
    "3. Sales Bubble Chart\n",
    "4. Cuisine Sales and Profits\n",
    "5. Customer Sales Dashboard"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f8d8acd5-0f57-4220-ac57-214e362c1d07",
   "metadata": {},
   "source": [
    "<a id=\"customersales\"></a>\n",
    "### Customer Sales"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "cc37d420-0c09-4d6b-a3df-a037bd755b7f",
   "metadata": {},
   "source": [
    "![images](../db-capstone-project/images/little-lemon-customer-sales.png)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "44e68747-8b77-4f6a-a0a6-5e630aeb2541",
   "metadata": {},
   "source": [
    "<a id=\"profitchart\"></a>\n",
    "### Profit Chart"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "39ca183d-bf2a-405f-8d8a-5b575325701b",
   "metadata": {},
   "source": [
    "![images](../db-capstone-project/images/little-lemon-profit-chart.png)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "9ebd116a-96eb-478d-92c5-d549c23bde03",
   "metadata": {},
   "source": [
    "<a id=\"salesbubble\"></a>\n",
    "### Sales Bubble Chart"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "6e6d3632-56bd-4c64-ae4c-3dabab3c7aa6",
   "metadata": {},
   "source": [
    "![images](../db-capstone-project/images/little-lemon-sales-bubble-chart.png)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f29d8ac6-1b72-4868-b7f4-7e136e5b8996",
   "metadata": {},
   "source": [
    "<a id=\"cuisinesales\"></a>\n",
    "### Cuisine Sales and Profit"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "eed8c98c-43fc-487e-96e1-22f7b4733685",
   "metadata": {},
   "source": [
    "![images](../db-capstone-project/images/little-lemon-cuisine-sales-and-profit-chart.png)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "fd69ffa5-be70-4a96-875c-bcbcf889150b",
   "metadata": {},
   "source": [
    "<a id=\"salesdashboard\" > </a>\n",
    "### Customer Sales Dashboard"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "2fbf3641-0ead-4cc2-850e-ded4dd1901ba",
   "metadata": {},
   "source": [
    "![images](../db-capstone-project/images/little-lemon-interactive-dashboard.png)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "4815e5a0-6875-4c91-b690-d17cc2898356",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.11.5"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}

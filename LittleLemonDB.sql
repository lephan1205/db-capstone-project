-- MySQL dump 10.13  Distrib 8.3.0, for macos14 (arm64)
--
-- Host: localhost    Database: LittleLemonDB
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Bookings`
--

DROP TABLE IF EXISTS `Bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Bookings` (
  `BookingID` int NOT NULL AUTO_INCREMENT,
  `CustomerID` int NOT NULL,
  `StaffID` int NOT NULL,
  `Date` datetime NOT NULL,
  `TableNumber` int NOT NULL,
  PRIMARY KEY (`BookingID`),
  KEY `customer_id_fk_idx` (`CustomerID`),
  KEY `staff_id_fk_idx` (`StaffID`),
  CONSTRAINT `customer_id_fk` FOREIGN KEY (`CustomerID`) REFERENCES `CustomerDetails` (`CustomerID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_id_fk` FOREIGN KEY (`StaffID`) REFERENCES `StaffInformation` (`StaffID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bookings`
--

LOCK TABLES `Bookings` WRITE;
/*!40000 ALTER TABLE `Bookings` DISABLE KEYS */;
INSERT INTO `Bookings` VALUES (1,1,1,'2024-01-01 12:00:00',8),(2,2,2,'2024-01-01 12:15:00',10),(3,3,3,'2024-01-02 13:15:00',12),(4,4,4,'2024-01-02 13:45:00',11),(5,5,5,'2024-01-03 14:00:00',7),(6,6,6,'2024-01-03 15:00:00',9),(7,7,7,'2024-01-04 16:00:00',5),(8,8,8,'2024-01-04 17:00:00',3),(9,9,9,'2024-01-04 18:00:00',4),(10,10,10,'2024-01-05 19:00:00',6),(11,1,1,'2024-02-02 12:30:00',8),(12,4,3,'2024-02-02 13:00:00',9),(13,6,4,'2024-02-02 14:30:00',10),(14,5,8,'2024-02-03 13:00:00',7),(15,9,7,'2024-02-03 15:00:00',6);
/*!40000 ALTER TABLE `Bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CustomerDetails`
--

DROP TABLE IF EXISTS `CustomerDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerDetails` (
  `CustomerID` int NOT NULL AUTO_INCREMENT,
  `FullName` varchar(100) NOT NULL,
  `ContactNumber` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  PRIMARY KEY (`CustomerID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CustomerDetails`
--

LOCK TABLES `CustomerDetails` WRITE;
/*!40000 ALTER TABLE `CustomerDetails` DISABLE KEYS */;
INSERT INTO `CustomerDetails` VALUES (1,'Vanessa McCarthy','0757536378','van.mccarthy@email.com'),(2,'Marcos Romero','0757536379','marcos.romero@email.com'),(3,'Hiroki Yamane','0757536376','hiroki.yamane@email.com'),(4,'Anna Iversen','0757536375','anna.iversen@email.com'),(5,'Diana Pinto','0757536374','diana.pinto@email.com'),(6,'Altay Ayhan','0757636378','altay.ayhan@email.com'),(7,'Jane Murphy','0753536379','jane.murphy@email.com'),(8,'Laurina Delgado','0754536376','laura.delgado@email.com'),(9,'Mike Edwards','0757236375','mike.edwards@email.com'),(10,'Karl Pederson','0757936374','karl.pedersen@email.com');
/*!40000 ALTER TABLE `CustomerDetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MenuItems`
--

DROP TABLE IF EXISTS `MenuItems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MenuItems` (
  `MenuItemsID` int NOT NULL AUTO_INCREMENT,
  `CourseName` varchar(45) NOT NULL,
  `StarterName` varchar(45) NOT NULL,
  `DesertName` varchar(45) NOT NULL,
  `Drink` varchar(45) NOT NULL,
  `Price` decimal(3,0) NOT NULL,
  PRIMARY KEY (`MenuItemsID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MenuItems`
--

LOCK TABLES `MenuItems` WRITE;
/*!40000 ALTER TABLE `MenuItems` DISABLE KEYS */;
INSERT INTO `MenuItems` VALUES (1,'Grilled Chicken','Greek Salad','Cheesecake','Ice Tea',30),(2,'Rib Eye Steak','Tomato Soup','Teramisu','Red Wine',40),(3,'Peperroni Pizza','Garlic Bread','Ice Cream','Soda',25),(4,'Spaghetti Carbonara','Bruschetta','Chocolate Cake','Ice Tea',30),(5,'Chicken Tenders','Coleslaw','Apple Pie','Soda',15),(6,'Sushi Plater','Miso Soup','Macha Ice Cream','Sake',45),(7,'Texas BBQ Ribs','Corrnbread','Fruit Cup','Beer',30),(8,'Chicken Curry','Samosas','Gulab Jamun','Ice Tea',25),(9,'Lobster Tail','Oysters','Lime Pie','White Wine',50),(10,'Kobe Burger','Sweet Potato Fries','Brownie','Beer',30);
/*!40000 ALTER TABLE `MenuItems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OrderDeliveryStatuses`
--

DROP TABLE IF EXISTS `OrderDeliveryStatuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OrderDeliveryStatuses` (
  `DeliveryID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int NOT NULL,
  `Date` datetime NOT NULL,
  `Status` varchar(45) NOT NULL,
  PRIMARY KEY (`DeliveryID`),
  KEY `orderid_fk_idx` (`OrderID`),
  CONSTRAINT `orderid_fk` FOREIGN KEY (`OrderID`) REFERENCES `Orders` (`OrderID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrderDeliveryStatuses`
--

LOCK TABLES `OrderDeliveryStatuses` WRITE;
/*!40000 ALTER TABLE `OrderDeliveryStatuses` DISABLE KEYS */;
INSERT INTO `OrderDeliveryStatuses` VALUES (1,1,'2024-01-01 12:10:00','Delivered'),(2,2,'2024-01-01 12:50:00','Preparing'),(3,3,'2024-01-02 13:35:00','Preparing'),(4,4,'2024-01-02 14:15:00','Delivered'),(6,6,'2024-01-02 15:00:00','Out for delivery'),(7,7,'2024-01-03 14:15:00','Delivered'),(8,8,'2024-01-03 15:30:00','Out for delivery'),(9,9,'2024-01-03 15:20:00','Preparing'),(10,10,'2024-01-04 16:30:00','Delivered'),(11,11,'2024-01-04 16:30:00','Delivered'),(12,12,'2024-01-04 16:10:00','Preparing'),(13,13,'2024-01-04 17:20:00','Preparing'),(14,14,'2024-01-04 17:20:00','Preparing'),(15,15,'2024-01-04 18:30:00','Delivered'),(16,16,'2024-01-04 18:30:00','Delivered'),(17,17,'2024-01-04 18:30:00','Delivered'),(18,18,'2024-01-05 19:05:00','Preparing'),(19,19,'2024-02-02 13:15:00','Delivered'),(20,20,'2024-02-02 13:15:00','Delivered'),(21,21,'2024-02-02 14:00:00','Preparing'),(22,22,'2024-02-02 14:00:00','Preparing'),(23,23,'2024-02-02 15:15:00','Delivered'),(24,24,'2024-02-02 15:15:00','Delivered'),(25,25,'2024-02-03 13:45:00','Delivered'),(26,26,'2024-02-03 13:45:00','Delivered'),(27,27,'2024-02-03 15:25:00','Preparing'),(28,28,'2024-02-03 15:25:00','Preparing'),(29,29,'2024-02-03 15:25:00','Preparing'),(30,30,'2024-02-03 15:25:00','Preparing');
/*!40000 ALTER TABLE `OrderDeliveryStatuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Orders`
--

DROP TABLE IF EXISTS `Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Orders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `CustomerID` int NOT NULL,
  `MenuItemsID` int NOT NULL,
  `StaffID` int NOT NULL,
  `Date` datetime NOT NULL,
  `Quantity` int NOT NULL,
  PRIMARY KEY (`OrderID`),
  KEY `customer_id_fk_idx` (`CustomerID`),
  KEY `menuitem_id_fk_idx` (`MenuItemsID`),
  KEY `staff_id_fk_idx` (`StaffID`),
  CONSTRAINT `customer_id2_fk` FOREIGN KEY (`CustomerID`) REFERENCES `CustomerDetails` (`CustomerID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `menuitem_id2_fk` FOREIGN KEY (`MenuItemsID`) REFERENCES `MenuItems` (`MenuItemsID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `staff_id2_fk` FOREIGN KEY (`StaffID`) REFERENCES `StaffInformation` (`StaffID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Orders`
--

LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;
INSERT INTO `Orders` VALUES (1,1,1,1,'2024-01-01 12:00:00',2),(2,2,2,2,'2024-01-01 12:45:00',1),(3,3,3,3,'2024-01-02 13:30:00',3),(4,4,4,4,'2024-01-02 14:00:00',1),(6,6,6,6,'2024-01-02 14:30:00',2),(7,5,7,5,'2024-01-03 14:15:00',3),(8,8,8,3,'2024-01-03 15:00:00',2),(9,6,8,6,'2024-01-03 15:15:00',2),(10,7,9,7,'2024-01-04 16:15:00',1),(11,7,10,7,'2024-01-04 16:15:00',2),(12,3,6,3,'2024-01-04 16:30:00',1),(13,8,3,8,'2024-01-04 17:15:00',1),(14,8,5,8,'2024-01-04 17:15:00',1),(15,9,9,9,'2024-01-04 18:15:00',1),(16,9,7,9,'2024-01-04 18:15:00',1),(17,9,5,9,'2024-01-04 18:15:00',1),(18,10,6,10,'2024-01-05 19:00:00',1),(19,1,7,1,'2024-02-02 12:45:00',1),(20,1,9,1,'2024-02-02 12:45:00',1),(21,4,4,3,'2024-02-02 13:45:00',1),(22,4,6,3,'2024-02-02 13:45:00',2),(23,6,9,4,'2024-02-02 14:45:00',1),(24,6,7,4,'2024-02-02 14:45:00',1),(25,5,7,8,'2024-02-03 13:15:00',1),(26,5,10,8,'2024-02-03 13:15:00',1),(27,9,4,7,'2024-02-03 15:15:00',1),(28,9,6,7,'2024-02-03 15:15:00',1),(29,9,9,7,'2024-02-03 15:15:00',1),(30,9,7,7,'2024-02-03 15:15:00',1);
/*!40000 ALTER TABLE `Orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `ordersview`
--

DROP TABLE IF EXISTS `ordersview`;
/*!50001 DROP VIEW IF EXISTS `ordersview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ordersview` AS SELECT 
 1 AS `OrderID`,
 1 AS `Quantity`,
 1 AS `Cost`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `StaffInformation`
--

DROP TABLE IF EXISTS `StaffInformation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `StaffInformation` (
  `StaffID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Role` varchar(45) NOT NULL,
  `Salary` decimal(10,0) NOT NULL,
  PRIMARY KEY (`StaffID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StaffInformation`
--

LOCK TABLES `StaffInformation` WRITE;
/*!40000 ALTER TABLE `StaffInformation` DISABLE KEYS */;
INSERT INTO `StaffInformation` VALUES (1,'Mario Gollini','Manager',60000),(2,'Adrian Gollini','Waiter',40000),(3,'Giorgos Dioudis','Head Chef',50000),(4,'Fatma Kaya','Cashier',35000),(5,'John Millar','Waiter',40000),(6,'Elena Salvai','Hostess',35000),(7,'Chris Tucker','Manager',55000),(8,'Jessica Beil','Chef',40000),(9,'Brian Gumpel','Waiter',35000),(10,'Kim Vu','Hostess',37000);
/*!40000 ALTER TABLE `StaffInformation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `ordersview`
--

/*!50001 DROP VIEW IF EXISTS `ordersview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`admin1`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `ordersview` AS select `o`.`OrderID` AS `OrderID`,`o`.`Quantity` AS `Quantity`,(`o`.`Quantity` * `m`.`Price`) AS `Cost` from (`orders` `o` left join `menuitems` `m` on((`o`.`MenuItemsID` = `m`.`MenuItemsID`))) where (`o`.`Quantity` >= 2) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-03-04 20:59:08

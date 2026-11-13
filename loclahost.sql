-- MySQL dump 10.13  Distrib 8.0.46, for macos15 (arm64)
--
-- Host: 127.0.0.1    Database: holiday_maker
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `ACCOMMODATION`
--

DROP TABLE IF EXISTS `ACCOMMODATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ACCOMMODATION` (
  `accommodation_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `has_pool` tinyint(1) NOT NULL,
  `has_restaurant` tinyint(1) NOT NULL,
  `distance_beach` int NOT NULL,
  `distance_center` int NOT NULL,
  `rating` decimal(2,1) NOT NULL,
  PRIMARY KEY (`accommodation_id`),
  CONSTRAINT `accommodation_chk_1` CHECK ((`distance_beach` >= 0)),
  CONSTRAINT `accommodation_chk_2` CHECK ((`distance_center` >= 0)),
  CONSTRAINT `accommodation_chk_3` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ACCOMMODATION`
--

LOCK TABLES `ACCOMMODATION` WRITE;
/*!40000 ALTER TABLE `ACCOMMODATION` DISABLE KEYS */;
INSERT INTO `ACCOMMODATION` VALUES (1,'Stark Tower Hotel','Malmö',1,1,500,1000,5.0),(2,'Avengers Grand Hotel','Göteborg',1,1,1200,300,4.8),(3,'Asgard Palace','Malmö',1,0,800,2000,4.5),(4,'Wakanda Resort','Göteborg',0,1,300,1500,4.7),(5,'Shield City Hotel','Malmö',0,0,2500,400,3.8);
/*!40000 ALTER TABLE `ACCOMMODATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BOOKING`
--

DROP TABLE IF EXISTS `BOOKING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BOOKING` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `room_id` int NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `number_of_guests` int NOT NULL,
  PRIMARY KEY (`booking_id`),
  KEY `customer_id` (`customer_id`),
  KEY `room_id` (`room_id`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `CUSTOMER` (`customer_id`),
  CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `ROOM` (`room_id`),
  CONSTRAINT `booking_chk_1` CHECK ((`check_out` > `check_in`)),
  CONSTRAINT `booking_chk_2` CHECK ((`number_of_guests` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BOOKING`
--

LOCK TABLES `BOOKING` WRITE;
/*!40000 ALTER TABLE `BOOKING` DISABLE KEYS */;
INSERT INTO `BOOKING` VALUES (1,1,1,'2026-12-01','2026-12-04',1),(2,2,2,'2026-12-02','2026-12-06',2),(3,3,3,'2026-12-03','2026-12-07',4),(4,4,4,'2026-12-05','2026-12-08',2),(5,5,5,'2026-12-01','2026-12-03',1),(6,1,6,'2026-12-04','2026-12-09',2),(7,2,7,'2026-12-06','2026-12-10',4),(8,3,8,'2026-12-08','2026-12-11',2),(9,4,9,'2026-12-02','2026-12-05',1),(10,5,10,'2026-12-07','2026-12-12',2),(11,1,11,'2026-12-10','2026-12-15',4),(12,2,12,'2026-12-12','2026-12-16',2),(13,3,13,'2026-12-01','2026-12-06',1),(14,4,14,'2026-12-03','2026-12-07',2),(15,5,15,'2026-12-05','2026-12-10',4),(16,1,16,'2026-12-09','2026-12-13',2),(17,2,17,'2026-12-11','2026-12-14',1),(18,3,18,'2026-12-13','2026-12-18',2),(19,4,19,'2026-12-15','2026-12-20',4),(20,5,20,'2026-12-17','2026-12-21',2),(21,1,1,'2026-12-04','2026-12-08',1),(22,2,2,'2026-12-06','2026-12-10',2),(23,3,5,'2026-12-03','2026-12-07',1),(24,4,9,'2026-12-05','2026-12-09',1),(25,5,13,'2026-12-06','2026-12-11',1),(27,2,8,'2026-12-20','2026-12-22',2);
/*!40000 ALTER TABLE `BOOKING` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CUSTOMER`
--

DROP TABLE IF EXISTS `CUSTOMER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CUSTOMER` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(30) NOT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CUSTOMER`
--

LOCK TABLES `CUSTOMER` WRITE;
/*!40000 ALTER TABLE `CUSTOMER` DISABLE KEYS */;
INSERT INTO `CUSTOMER` VALUES (1,'Tony Stark','tony.stark@example.com','070-123 45 67'),(2,'Steve Rogers','steve.rogers@example.com','072-234 56 78'),(3,'Thor Odinson','thor.odinson@example.com','073-345 67 89'),(4,'Bruce Banner','bruce.banner@example.com','076-456 78 90'),(5,'Natasha Romanoff','natasha.romanoff@example.com','070-567 89 01'),(6,'Joel ','kjdiowejdowje@.com','02930920392093');
/*!40000 ALTER TABLE `CUSTOMER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ROOM`
--

DROP TABLE IF EXISTS `ROOM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ROOM` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `accommodation_id` int NOT NULL,
  `room_number` varchar(20) NOT NULL,
  `capacity` int NOT NULL,
  `price_per_night` decimal(10,2) NOT NULL,
  PRIMARY KEY (`room_id`),
  UNIQUE KEY `accommodation_id` (`accommodation_id`,`room_number`),
  CONSTRAINT `room_ibfk_1` FOREIGN KEY (`accommodation_id`) REFERENCES `ACCOMMODATION` (`accommodation_id`),
  CONSTRAINT `room_chk_1` CHECK ((`capacity` > 0)),
  CONSTRAINT `room_chk_2` CHECK ((`price_per_night` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ROOM`
--

LOCK TABLES `ROOM` WRITE;
/*!40000 ALTER TABLE `ROOM` DISABLE KEYS */;
INSERT INTO `ROOM` VALUES (1,1,'101',1,600.00),(2,1,'102',2,900.00),(3,1,'103',4,1500.00),(4,1,'104',2,1100.00),(5,2,'201',1,550.00),(6,2,'202',2,850.00),(7,2,'203',4,1400.00),(8,2,'204',2,1000.00),(9,3,'301',1,700.00),(10,3,'302',2,950.00),(11,3,'303',4,1600.00),(12,3,'304',2,1200.00),(13,4,'401',1,500.00),(14,4,'402',2,800.00),(15,4,'403',4,1300.00),(16,4,'404',2,950.00),(17,5,'501',1,400.00),(18,5,'502',2,650.00),(19,5,'503',4,1100.00),(20,5,'504',2,750.00);
/*!40000 ALTER TABLE `ROOM` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-12 12:20:04

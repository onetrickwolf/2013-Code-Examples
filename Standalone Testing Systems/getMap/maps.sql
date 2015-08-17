-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 09, 2011 at 02:52 AM
-- Server version: 5.1.53
-- PHP Version: 5.3.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `underverse`
--

-- --------------------------------------------------------

--
-- Table structure for table `maps`
--

CREATE TABLE IF NOT EXISTS `maps` (
  `ID` int(20) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(100) NOT NULL,
  `MAP_DATA` longtext NOT NULL,
  `STATUS` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `maps`
--

INSERT INTO `maps` (`ID`, `NAME`, `MAP_DATA`, `STATUS`) VALUES
(1, 'sweetassworldjizzle', '?[32, 120], x1y1, [object pieceP1], null]?[80, 105], x2y1, null, null]?[128, 90], x3y1, [object pieceN], [object propMW]]?[176, 75], x4y1, null, null]?[224, 60], x5y1, null, null]?[272, 45], x6y1, null, null]?[320, 30], x7y1, null, null]?[368, 15], x8y1, null, null]?[32, 150], x1y2, null, null]?[80, 135], x2y2, null, null]?[128, 120], x3y2, null, null]?[176, 105], x4y2, null, null]?[224, 90], x5y2, null, null]?[272, 75], x6y2, null, null]?[320, 60], x7y2, null, null]?[368, 45], x8y2, null, null]?[416, 30], x9y2, null, null]?[32, 180], x1y3, null, null]?[80, 165], x2y3, null, null]?[128, 150], x3y3, null, null]?[176, 135], x4y3, null, null]?[224, 120], x5y3, null, null]?[272, 105], x6y3, null, null]?[320, 90], x7y3, null, null]?[368, 75], x8y3, null, null]?[416, 60], x9y3, null, null]?[464, 45], x10y3, null, null]?[32, 210], x1y4, null, null]?[80, 195], x2y4, null, null]?[128, 180], x3y4, null, null]?[176, 165], x4y4, null, null]?[224, 150], x5y4, null, null]?[272, 135], x6y4, null, null]?[320, 120], x7y4, null, null]?[368, 105], x8y4, null, null]?[416, 90], x9y4, null, null]?[464, 75], x10y4, null, null]?[512, 60], x11y4, null, null]?[32, 240], x1y5, null, null]?[80, 225], x2y5, null, null]?[128, 210], x3y5, null, null]?[176, 195], x4y5, null, null]?[224, 180], x5y5, null, null]?[272, 165], x6y5, null, null]?[320, 150], x7y5, null, null]?[368, 135], x8y5, null, null]?[416, 120], x9y5, null, null]?[464, 105], x10y5, null, null]?[512, 90], x11y5, null, null]?[560, 75], x12y5, null, null]?[32, 270], x1y6, null, null]?[80, 255], x2y6, null, null]?[128, 240], x3y6, null, null]?[176, 225], x4y6, null, null]?[224, 210], x5y6, null, null]?[272, 195], x6y6, null, null]?[320, 180], x7y6, null, null]?[368, 165], x8y6, null, null]?[416, 150], x9y6, null, null]?[464, 135], x10y6, null, null]?[512, 120], x11y6, null, null]?[560, 105], x12y6, null, null]?[608, 90], x13y6, null, null]?[32, 300], x1y7, [object pieceN], null]?[80, 285], x2y7, null, null]?[128, 270], x3y7, null, null]?[176, 255], x4y7, null, null]?[224, 240], x5y7, null, null]?[272, 225], x6y7, null, null]?[320, 210], x7y7, [object pieceN], null]?[368, 195], x8y7, [object pieceN], null]?[416, 180], x9y7, null, null]?[464, 165], x10y7, null, null]?[512, 150], x11y7, null, null]?[560, 135], x12y7, null, null]?[608, 120], x13y7, null, null]?[656, 105], x14y7, [object pieceN], null]?[32, 330], x1y8, [object pieceN], [object propMW]]?[80, 315], x2y8, [object pieceN], null]?[128, 300], x3y8, null, null]?[176, 285], x4y8, null, null]?[224, 270], x5y8, null, null]?[272, 255], x6y8, null, null]?[320, 240], x7y8, [object pieceN], null]?[368, 225], x8y8, [object pieceN], [object propMW]]?[416, 210], x9y8, [object pieceN], null]?[464, 195], x10y8, null, null]?[512, 180], x11y8, null, null]?[560, 165], x12y8, null, null]?[608, 150], x13y8, null, null]?[656, 135], x14y8, [object pieceN], null]?[704, 120], x15y8, [object pieceN], [object propMW]]?[80, 345], x2y9, [object pieceN], null]?[128, 330], x3y9, null, null]?[176, 315], x4y9, null, null]?[224, 300], x5y9, null, null]?[272, 285], x6y9, null, null]?[320, 270], x7y9, null, null]?[368, 255], x8y9, [object pieceN], null]?[416, 240], x9y9, [object pieceN], null]?[464, 225], x10y9, null, null]?[512, 210], x11y9, null, null]?[560, 195], x12y9, null, null]?[608, 180], x13y9, null, null]?[656, 165], x14y9, null, null]?[704, 150], x15y9, [object pieceN], null]?[128, 360], x3y10, null, null]?[176, 345], x4y10, null, null]?[224, 330], x5y10, null, null]?[272, 315], x6y10, null, null]?[320, 300], x7y10, null, null]?[368, 285], x8y10, null, null]?[416, 270], x9y10, null, null]?[464, 255], x10y10, null, null]?[512, 240], x11y10, null, null]?[560, 225], x12y10, null, null]?[608, 210], x13y10, null, null]?[656, 195], x14y10, null, null]?[704, 180], x15y10, null, null]?[176, 375], x4y11, null, null]?[224, 360], x5y11, null, null]?[272, 345], x6y11, null, null]?[320, 330], x7y11, null, null]?[368, 315], x8y11, null, null]?[416, 300], x9y11, null, null]?[464, 285], x10y11, null, null]?[512, 270], x11y11, null, null]?[560, 255], x12y11, null, null]?[608, 240], x13y11, null, null]?[656, 225], x14y11, null, null]?[704, 210], x15y11, null, null]?[224, 390], x5y12, null, null]?[272, 375], x6y12, null, null]?[320, 360], x7y12, null, null]?[368, 345], x8y12, null, null]?[416, 330], x9y12, null, null]?[464, 315], x10y12, null, null]?[512, 300], x11y12, null, null]?[560, 285], x12y12, null, null]?[608, 270], x13y12, null, null]?[656, 255], x14y12, null, null]?[704, 240], x15y12, null, null]?[272, 405], x6y13, null, null]?[320, 390], x7y13, null, null]?[368, 375], x8y13, null, null]?[416, 360], x9y13, null, null]?[464, 345], x10y13, null, null]?[512, 330], x11y13, null, null]?[560, 315], x12y13, null, null]?[608, 300], x13y13, null, null]?[656, 285], x14y13, null, null]?[704, 270], x15y13, null, null]?[320, 420], x7y14, null, null]?[368, 405], x8y14, null, null]?[416, 390], x9y14, null, null]?[464, 375], x10y14, null, null]?[512, 360], x11y14, null, null]?[560, 345], x12y14, null, null]?[608, 330], x13y14, null, null]?[656, 315], x14y14, null, null]?[704, 300], x15y14, null, null]?[368, 435], x8y15, null, null]?[416, 420], x9y15, null, null]?[464, 405], x10y15, null, null]?[512, 390], x11y15, null, null]?[560, 375], x12y15, null, null]?[608, 360], x13y15, [object pieceN], [object propMW]]?[656, 345], x14y15, null, null]?[704, 330], x15y15, [object pieceP2], null]', 'online');

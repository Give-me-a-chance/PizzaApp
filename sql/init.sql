USE [master]
GO
/****** Object:  Database [PizzaTest]    Script Date: 14.02.2026 14:41:46 ******/
CREATE DATABASE [PizzaTest]
GO
USE [PizzaTest]
GO
ALTER DATABASE [PizzaTest] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PizzaTest].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PizzaTest] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PizzaTest] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PizzaTest] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PizzaTest] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PizzaTest] SET ARITHABORT OFF 
GO
ALTER DATABASE [PizzaTest] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PizzaTest] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PizzaTest] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PizzaTest] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PizzaTest] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PizzaTest] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PizzaTest] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PizzaTest] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PizzaTest] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PizzaTest] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PizzaTest] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PizzaTest] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PizzaTest] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PizzaTest] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PizzaTest] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PizzaTest] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PizzaTest] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PizzaTest] SET RECOVERY FULL 
GO
ALTER DATABASE [PizzaTest] SET  MULTI_USER 
GO
ALTER DATABASE [PizzaTest] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PizzaTest] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PizzaTest] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PizzaTest] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PizzaTest] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PizzaTest] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'PizzaTest', N'ON'
GO
ALTER DATABASE [PizzaTest] SET QUERY_STORE = ON
GO
ALTER DATABASE [PizzaTest] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [PizzaTest]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 14.02.2026 14:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_tov] [int] NULL,
	[count] [int] NULL,
	[id_user] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 14.02.2026 14:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[id] [int] NOT NULL,
	[name] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItem]    Script Date: 14.02.2026 14:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_tov] [int] NULL,
	[count] [int] NULL,
	[id_zak] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 14.02.2026 14:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[stat] [int] NULL,
	[dateorder] [smalldatetime] NULL,
	[id_user] [int] NULL,
	[total] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 14.02.2026 14:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[category] [int] NULL,
	[name] [nvarchar](30) NULL,
	[descr] [nvarchar](100) NULL,
	[price] [int] NULL,
	[img] [nvarchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 14.02.2026 14:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[id] [int] NOT NULL,
	[name] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Statuses]    Script Date: 14.02.2026 14:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Statuses](
	[id] [int] NOT NULL,
	[descr] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 14.02.2026 14:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[role] [int] NULL,
	[name] [nvarchar](30) NULL,
	[mail] [nvarchar](50) NULL,
	[pass] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Cart] ON 
GO
INSERT [dbo].[Cart] ([id], [id_tov], [count], [id_user]) VALUES (1176, 14, 1, 1)
GO
INSERT [dbo].[Cart] ([id], [id_tov], [count], [id_user]) VALUES (1177, 25, 1, 1)
GO
SET IDENTITY_INSERT [dbo].[Cart] OFF
GO
INSERT [dbo].[Categories] ([id], [name]) VALUES (1, N'Пиццы')
GO
INSERT [dbo].[Categories] ([id], [name]) VALUES (2, N'Холодные напитки')
GO
INSERT [dbo].[Categories] ([id], [name]) VALUES (3, N'Горячие напитки')
GO
SET IDENTITY_INSERT [dbo].[OrderItem] ON 
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1, 15, 1, 3)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (2, 21, 1, 4)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (3, 25, 1, 4)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (4, 14, 1, 5)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (5, 17, 1, 6)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (6, 25, 1, 7)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (7, 14, 1, 7)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (8, 17, 1, 9)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (9, 15, 2, 10)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (10, 16, 2, 11)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (11, 23, 1, 11)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (12, 23, 1, 12)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (13, 24, 1, 12)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (14, 22, 1, 13)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (15, 19, 1, 13)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (16, 14, 10, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (17, 15, 10, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (18, 16, 7, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (19, 17, 4, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (20, 18, 4, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (21, 19, 3, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (22, 20, 2, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (23, 21, 4, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (24, 22, 4, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (25, 23, 4, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (26, 24, 4, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (27, 25, 3, 14)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (28, 14, 1, 15)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (29, 24, 2, 15)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (30, 17, 1, 16)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (31, 25, 1, 16)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (32, 15, 1, 17)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (33, 14, 1, 18)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (34, 14, 1, 19)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (35, 14, 1, 20)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (36, 25, 1, 20)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (37, 15, 1, 21)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1034, 15, 1, 1019)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1035, 17, 1, 1020)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1036, 23, 1, 1020)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1037, 16, 1, 1021)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1038, 15, 2, 1022)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1039, 23, 2, 1022)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1040, 24, 1, 1022)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1041, 22, 2, 1023)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1042, 18, 1, 1023)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1043, 25, 1, 1024)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1044, 14, 1, 1025)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1045, 22, 1, 1025)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1046, 15, 1, 1026)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1047, 25, 1, 1027)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1048, 20, 1, 1027)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1049, 21, 1, 1028)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1050, 18, 1, 1029)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1051, 18, 1, 1030)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1052, 18, 1, 1031)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1053, 25, 1, 1031)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1054, 14, 1, 1032)
GO
INSERT [dbo].[OrderItem] ([id], [id_tov], [count], [id_zak]) VALUES (1055, 25, 1, 1032)
GO
SET IDENTITY_INSERT [dbo].[OrderItem] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1, 4, CAST(N'2026-01-14T15:28:00' AS SmallDateTime), 7, 420)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (2, 4, CAST(N'2026-01-14T15:28:00' AS SmallDateTime), 7, 420)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (3, 4, CAST(N'2026-01-15T00:57:00' AS SmallDateTime), 7, 420)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (4, 4, CAST(N'2026-01-15T01:00:00' AS SmallDateTime), 7, 590)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (5, 5, CAST(N'2026-01-15T01:26:00' AS SmallDateTime), 6, 450)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (6, 4, CAST(N'2026-01-15T01:30:00' AS SmallDateTime), 6, 440)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (7, 4, CAST(N'2026-01-15T17:42:00' AS SmallDateTime), 7, 530)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (8, 4, CAST(N'2026-01-15T00:00:00' AS SmallDateTime), 7, 530)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (9, 4, CAST(N'2026-01-16T19:05:00' AS SmallDateTime), 7, 440)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (10, 4, CAST(N'2026-01-16T21:06:00' AS SmallDateTime), 7, 840)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (11, 5, CAST(N'2026-01-16T21:10:00' AS SmallDateTime), 7, 1030)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (12, 4, CAST(N'2026-01-16T21:18:00' AS SmallDateTime), 7, 180)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (13, 4, CAST(N'2026-01-16T21:28:00' AS SmallDateTime), 8, 590)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (14, 5, CAST(N'2026-01-16T21:31:00' AS SmallDateTime), 8, 21520)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (15, 4, CAST(N'2026-01-16T23:36:00' AS SmallDateTime), 7, 630)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (16, 4, CAST(N'2026-01-17T19:06:00' AS SmallDateTime), 7, 520)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (17, 5, CAST(N'2026-01-17T22:04:00' AS SmallDateTime), 7, 420)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (18, 4, CAST(N'2026-01-17T22:24:00' AS SmallDateTime), 17, 450)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (19, 5, CAST(N'2026-01-17T22:31:00' AS SmallDateTime), 21, 450)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (20, 4, CAST(N'2026-01-17T23:38:00' AS SmallDateTime), 7, 530)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (21, 4, CAST(N'2026-01-18T04:14:00' AS SmallDateTime), 7, 420)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1019, 4, CAST(N'2026-01-18T18:44:00' AS SmallDateTime), 6, 420)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1020, 4, CAST(N'2026-01-18T18:49:00' AS SmallDateTime), 1019, 530)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1021, 4, CAST(N'2026-01-18T18:50:00' AS SmallDateTime), 7, 470)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1022, 5, CAST(N'2026-01-18T18:53:00' AS SmallDateTime), 1020, 1110)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1023, 4, CAST(N'2026-01-18T19:17:00' AS SmallDateTime), 7, 660)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1024, 5, CAST(N'2026-01-18T19:18:00' AS SmallDateTime), 1021, 80)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1025, 4, CAST(N'2026-01-18T19:34:00' AS SmallDateTime), 6, 540)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1026, 5, CAST(N'2026-01-18T19:35:00' AS SmallDateTime), 6, 420)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1027, 5, CAST(N'2026-01-18T19:35:00' AS SmallDateTime), 1022, 575)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1028, 5, CAST(N'2026-01-18T19:37:00' AS SmallDateTime), 6, 510)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1029, 5, CAST(N'2026-01-18T19:37:00' AS SmallDateTime), 1023, 480)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1030, 4, CAST(N'2026-01-18T23:12:00' AS SmallDateTime), 1024, 480)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1031, 5, CAST(N'2026-01-18T23:13:00' AS SmallDateTime), 6, 560)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1032, 2, CAST(N'2026-02-14T14:02:00' AS SmallDateTime), 6, 530)
GO
INSERT [dbo].[Orders] ([id], [stat], [dateorder], [id_user], [total]) VALUES (1033, 5, CAST(N'2026-02-14T14:02:00' AS SmallDateTime), 6, 0)
GO
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (14, 1, N'Пепперони', N'Томатный соус, сыр моцарелла, пепперони', 450, N'img/pep.jpg')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (15, 1, N'Маргарита', N'Томатный соус, сыр моцарелла, свежие помидоры, базилик', 420, N'img/pep.jpg')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (16, 1, N'Гавайская', N'Ветчина, ананас, сыр, томатный соус', 470, N'img/pep.jpg')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (17, 1, N'Вегетарианская', N'Различные овощи, сыр моцарелла', 440, N'img/pep.jpg')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (18, 1, N'Четыре сыра', N'Сыр моцарелла, сыр дорблю, сыр пармезан, сыр чеддер', 480, N'img/pep.jpg')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (19, 1, N'Мясная', N'Ветчина, салями, бекон, сыр, соус', 500, N'img/pep.jpg')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (20, 1, N'Дьябло', N'Острые колбасы, халапеньо, сыр, томатный соус', 495, N'img/pep.jpg')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (21, 1, N'Цезарь', N'Курица, соус цезарь, пармезан, салат, томаты', 510, N'img/pep.jpg')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (22, 2, N'Кола', N'Добрый кола классический 0.5 л', 90, N'img/colddrink.jpg')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (23, 2, N'Кола', N'Добрый кола без сахара 0.5 л', 90, N'img/colddrink.jpg')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (24, 3, N'Латте', N'Латте 0.4 л', 90, N'img/hotdrink.png')
GO
INSERT [dbo].[Products] ([id], [category], [name], [descr], [price], [img]) VALUES (25, 3, N'Чай', N'Черный чай с лимоном 0.4 л', 80, N'img/hotdrink.png')
GO
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
INSERT [dbo].[Roles] ([id], [name]) VALUES (1, N'Пользователь')
GO
INSERT [dbo].[Roles] ([id], [name]) VALUES (2, N'Сотрудник')
GO
INSERT [dbo].[Statuses] ([id], [descr]) VALUES (1, N'Оформлен')
GO
INSERT [dbo].[Statuses] ([id], [descr]) VALUES (2, N'Готовится')
GO
INSERT [dbo].[Statuses] ([id], [descr]) VALUES (3, N'Готов к выдаче')
GO
INSERT [dbo].[Statuses] ([id], [descr]) VALUES (4, N'Выполнен')
GO
INSERT [dbo].[Statuses] ([id], [descr]) VALUES (5, N'Отменен')
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (1, 1, N'Тест', N'юзер', N'Тест')
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (2, 2, N'Тест', N'админ', N'Тест')
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (4, 1, N'абоба', N'1', N'12345')
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (5, 1, N'Артем', N'тест', N'йЦуК')
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (6, 1, N'тест', N'тест1', N'123')
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (7, 1, N'Анчоус', N'Тест2', N'123')
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (8, 1, N'Алексей', N'Алексей', N'123')
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (17, 1, N'ТестФиз', NULL, NULL)
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (21, 1, N'ТестФиз2', NULL, NULL)
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (1019, 1, N'Ананас', NULL, NULL)
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (1020, 1, N'ТестРег', NULL, NULL)
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (1021, 1, N'ТестТабло', NULL, NULL)
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (1022, 1, N'Без регистрации', NULL, NULL)
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (1023, 1, N'Незарегистрированный', NULL, NULL)
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (1024, 1, N'Настя', NULL, NULL)
GO
INSERT [dbo].[Users] ([id], [role], [name], [mail], [pass]) VALUES (1025, 1, N'Артем', N'test1@mail.ru', N'12345')
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_Mail_NotNull]    Script Date: 14.02.2026 14:41:46 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Mail_NotNull] ON [dbo].[Users]
(
	[mail] ASC
)
WHERE ([mail] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD FOREIGN KEY([id_tov])
REFERENCES [dbo].[Products] ([id])
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD FOREIGN KEY([id_user])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD FOREIGN KEY([id_tov])
REFERENCES [dbo].[Products] ([id])
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD FOREIGN KEY([id_zak])
REFERENCES [dbo].[Orders] ([id])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([id_user])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([stat])
REFERENCES [dbo].[Statuses] ([id])
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD FOREIGN KEY([category])
REFERENCES [dbo].[Categories] ([id])
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD FOREIGN KEY([role])
REFERENCES [dbo].[Roles] ([id])
GO
USE [master]
GO
ALTER DATABASE [PizzaTest] SET  READ_WRITE 
GO

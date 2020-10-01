CREATE DATABASE QL_Lich_Su_Game
GO
USE QL_Lich_Su_Game
GO
CREATE TABLE Users
(
	UserID		VARCHAR(10) PRIMARY KEY,
	Name		NVARCHAR(100) UNIQUE NOT NULL,
	Pass		VARCHAR(50) NOT NULL,
	RoleLevel	INT CHECK(RoleLevel IN(0,1,2))
)
CREATE TABLE ResultOanTuTi
(
	ResultID		INT IDENTITY PRIMARY KEY,
	GameName		NVARCHAR(100),
	TimeResult		DATETIME DEFAULT GETDATE(),
	ComputerPoint	INT CHECK(ComputerPoint >= 0),
	UserPoint		INT CHECK(UserPoint >= 0),
	Result			NVARCHAR(50),
	UserID			VARCHAR(10) CONSTRAINT FK_Result_Users 
					FOREIGN KEY(UserID) REFERENCES Users(UserID)
)
GO
CREATE TABLE ResultDoanSo
(
	ResultID		INT IDENTITY PRIMARY KEY,
	GameName		NVARCHAR(100),
	TimeResult		DATETIME DEFAULT GETDATE(),
	Counts			INT CHECK(Counts >= 0),
	UserPoint		INT CHECK(UserPoint >= 0),
	UserID			VARCHAR(10) CONSTRAINT FK_ResultDoanSo_Users 
					FOREIGN KEY(UserID) REFERENCES Users(UserID)
)
INSERT INTO Users VALUES('admin', N'Người quản lý', '123456', 1)
INSERT INTO Users VALUES('yentran', N'Cô Yến', '123456', 1)
INSERT INTO Users VALUES('nghia', N'Trọng Nghĩa', '123456', 1)
GO
---- Tạo procedure để đăng ký tài khoản chơi game
CREATE PROC ThemUser(@userid VARCHAR(10), @name NVARCHAR(100), @pass VARCHAR(50), 
										@rolelevel INT, @kq NVARCHAR(100) OUTPUT)
	AS
	SET @kq=''
	IF EXISTS(SELECT *FROM Users WHERE UserID = @userid)
		SET @kq = N'UserID đã có người sử dụng'
	IF EXISTS(SELECT *FROM Users WHERE Name = @name)
		SET @kq += N'User Name đã có người sử dụng'+CHAR(10)
	IF @rolelevel NOT IN (0,1,2)
		SET @kq += N'Quyền phải là 0,1,2';
	IF @kq=''
	BEGIN
		INSERT INTO Users VALUES (@userid, @name, @pass, @rolelevel)
		SET @kq = N'Đăng ký tài khoản thành công'
	END

GO
---- Tạo procedure để ghi lại lịch sử người chơi game oẳn tù tì
CREATE PROC GhiLichsuOanTuTi(@gamename NVARCHAR(100), @computerpoint INT, 
@userpoint INT, @result NVARCHAR(50), @userid VARCHAR(10), @kq NVARCHAR(300) OUTPUT)
AS
SET @kq = ''
IF @computerpoint < 0
	SET @kq = N'Điểm máy phải >= 0.'+CHAR(10)
IF @userpoint < 0
	SET @kq += N'Điểm người phải >= 0.'+CHAR(10)
IF NOT EXISTS (SELECT *FROM Users WHERE UserID = @userid)
	SET @kq += N'UserID không hợp lệ'+CHAR(10)
IF @kq = ''
BEGIN
	INSERT INTO ResultOanTuTi (GameName, ComputerPoint, UserPoint, Result, UserID) 
			VALUES (@gamename, @computerpoint, @userpoint, @result, @userid)
	SET @kq = N'Ghi file lịch sử thành công'
END

GO
---- Tạo procedure để ghi lại lịch sử người chơi game oẳn tù tì
CREATE PROC GhiLichsuDoanSo(@gamename NVARCHAR(100), @counts INT, @userpoint INT,
									@userid VARCHAR(10), @kq NVARCHAR(300) OUTPUT)
AS
SET @kq = ''
IF @userpoint < 0
	SET @kq += N'Điểm người phải >= 0.'+CHAR(10)
IF NOT EXISTS (SELECT *FROM Users WHERE UserID = @userid)
	SET @kq += N'UserID không hợp lệ'+CHAR(10)
IF @kq = ''
BEGIN
	INSERT INTO ResultDoanSo (GameName, Counts, UserPoint, UserID) 
					VALUES (@gamename, @counts, @userpoint, @userid)
	SET @kq = N'Ghi file lịch sử thành công'
END
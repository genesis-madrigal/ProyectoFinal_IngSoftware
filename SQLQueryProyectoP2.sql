CREATE DATABASE ProyectoFinal
GO

USE ProyectoFinal
GO


CREATE TABLE Usuarios (
    UsuarioID int identity(1,1) PRIMARY KEY,
    Nombre varchar(50) NOT NULL,
    CorreoElectronico varchar(50),
    Telefono varchar(15) CONSTRAINT uc_Telefono UNIQUE (Telefono),
	CONSTRAINT UQ_Correo UNIQUE (CorreoElectronico)
)
GO

CREATE TABLE Equipos (
    EquipoID int identity(1,1) PRIMARY KEY,
    TipoEquipo varchar(50) NOT NULL,
    Modelo varchar(50),
    UsuarioID int,
    CONSTRAINT fk_usuarioID FOREIGN KEY(UsuarioID) REFERENCES Usuarios(UsuarioID)
)
GO

CREATE TABLE Tecnicos (
    TecnicoID int identity(1,1) PRIMARY KEY,
    Nombre varchar(50),
    Especialidad varchar(20)
)
GO

CREATE TABLE SystemUsers
(
	LogInUser varchar(15) NOT NULL,
	Clave varchar (15) NOT NULL,
	CONSTRAINT PK_loginuser PRIMARY KEY (LogInUser)
)
GO

CREATE TABLE SystemUUsuarios (
	SystemUID int identity(1,1) PRIMARY KEY,
	UsuarioID int NOT NULL,
	LogInUser varchar(15) NOT NULL,	
	CONSTRAINT fk_usuarioIDSystem FOREIGN KEY(UsuarioID) REFERENCES Usuarios(UsuarioID),
	CONSTRAINT fk_SystemLoginU FOREIGN KEY(LogInUser) REFERENCES SystemUsers(LogInUser)
)
GO

CREATE TABLE SystemUTecnicos (
	SystemTID int identity(1,1) PRIMARY KEY,
	TecnicoID int NOT NULL,
	LogInUser varchar(15) NOT NULL,	
	CONSTRAINT fk_tecnicoIDSystem FOREIGN KEY(TecnicoID) REFERENCES Tecnicos(TecnicoID),
	CONSTRAINT fk_SystemLoginT FOREIGN KEY(LogInUser) REFERENCES SystemUsers(LogInUser)
)
GO



CREATE TABLE Reparaciones (
    ReparacionID int identity(1,1) PRIMARY KEY,
    EquipoID int,
    FechaSolicitud DATETIME CONSTRAINT df_FechaSolicitud DEFAULT GETDATE(), /**/
    Estado char(1),
    CONSTRAINT fk_equipoID FOREIGN KEY(EquipoID) REFERENCES Equipos(EquipoID)
)
GO


CREATE TABLE DetallesReparacion (
    DetalleID int identity(1,1) PRIMARY KEY,
    ReparacionID int,
    Descripcion varchar(50),
    FechaInicio DATETIME CONSTRAINT df_FechaInicio DEFAULT GETDATE(),
    FechaFin DATETIME,
    CONSTRAINT fk_reparacionID FOREIGN KEY(ReparacionID) REFERENCES Reparaciones(ReparacionID)
)
GO


CREATE TABLE Asignaciones (
    AsignacionID int identity(1,1) PRIMARY KEY,
    ReparacionID int,
    TecnicoID int,
    FechaAsignacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT fk_asignaciones_reparacionID FOREIGN KEY(ReparacionID) REFERENCES Reparaciones(ReparacionID),
    CONSTRAINT fk_asignaciones_tecnicoID FOREIGN KEY(TecnicoID) REFERENCES Tecnicos(TecnicoID)
)
GO



CREATE TABLE Roles (
	RolID int identity (1,1),
	nombreRol varchar(15) NOT NULL,
	CONSTRAINT PK_RolID PRIMARY KEY (RolID)
)
GO

CREATE TABLE UserRoles (
	LogInUser varchar(15),
	RolID int,
	CONSTRAINT fk_LogInUser FOREIGN KEY(LogInUser) REFERENCES SystemUsers(LogInUser),
	CONSTRAINT fk_rolID FOREIGN KEY(RolID) REFERENCES Roles(RolID)
)
GO

CREATE TABLE Estados
(
	id CHAR(1) Primary Key,
	Descripcion Varchar(50)
)

GO

select * from SystemUsers
select * from UserRoles


INSERT INTO Roles VALUES ('Administrador'), ('Tecnico'), ('Usuario')

GO


SELECT * FROM Equipos
GO
SELECT * FROM Reparaciones
GO
SELECT * FROM DetallesReparacion
GO

SELECT * FROM Asignaciones
GO

SELECT * FROM Usuarios
GO
SELECT * FROM SystemUsers
GO
SELECT * FROM Tecnicos
GO



INSERT INTO Usuarios(Nombre, CorreoElectronico, Telefono) VALUES
('Oscar Isaac', 'oscar@examen2.net', '89898989'),
('Jose Pedro', 'pedro@examen2.net', '87878787'),
('Tom Holland', 'tom@examen2.net', '81818181'),
('Zendaya', 'zendaya@examen2.net', '82828282')
GO

INSERT INTO Equipos(TipoEquipo, Modelo, UsuarioID) VALUES
('Computadora Escritorio', 'Asus', '1'),
('VR Headset', 'Oculus', '4'), 
('Nintendo Switch', 'Nintendo', '2')
GO

INSERT INTO Reparaciones(EquipoID, Estado) VALUES
(1, 'A'),
(2, 'P'),
(3, 'C')
GO

INSERT INTO DetallesReparacion(ReparacionID, Descripcion) VALUES
(1, 'Arreglar fuente de poder'),
(2, 'Puerto de carga no funciona'),
(3, 'Arreglar joycon')
GO


INSERT INTO Tecnicos(Nombre, Especialidad) VALUES
('Edward', 'Técnico en cómputo'),
('Jacob', 'Técnico electricista')
GO

INSERT INTO Asignaciones(ReparacionID, TecnicoID) VALUES
(1, 1),
(2, 2),
(3, 1)
GO

INSERT INTO SystemUsers(LogInUser, Clave) VALUES
('oscar', 123),
('pedro', 456),
('tom', 789)
GO

INSERT INTO SystemUUsuarios(UsuarioID, LogInUser) VALUES
(1, 'oscar'),
(2, 'pedro'),
(3, 'tom')

GO


INSERT INTO SystemUTecnicos(TecnicoID, LogInUser) VALUES
(1, 'edward'),
(2, 'jacob'),
(6, 'alice')
GO


INSERT INTO UserRoles VALUES('oscar', 1), ('pedro', 1), ('tom', 2);
GO

/*DBCC CHECKIDENT ('Tecnicos', RESEED, 0);*/


CREATE PROCEDURE ReporteGeneral
	AS
		BEGIN
			SELECT CONVERT(VARCHAR(20), U.UsuarioID) + '-' + U.Nombre AS [ID Usuario], U.Telefono, U.CorreoElectronico, CONVERT(VARCHAR(20), E.EquipoID) + '-' + E.Modelo AS [ID Equipo], D.Descripcion AS [Detalle reparacion],
			R.Estado, D.FechaInicio AS [Fecha Inicio], D.FechaFin AS [Fecha Fin], CONVERT(VARCHAR(20), T.TecnicoID) + '-' + T.Nombre AS [ID Tecnico], R.ReparacionID AS [ID Reparacion],
			R.FechaSolicitud
			FROM Usuarios U
			INNER JOIN Equipos E ON U.UsuarioID = E.UsuarioID
			INNER JOIN Reparaciones R ON E.EquipoID = R.EquipoID
			INNER JOIN DetallesReparacion D ON D.ReparacionID = R.ReparacionID
			INNER JOIN Asignaciones A ON R.ReparacionID = A.ReparacionID
			INNER JOIN Tecnicos T ON A.TecnicoID = T.TecnicoID
		END
GO


EXEC ReporteGeneral
GO

CREATE PROCEDURE CONSULTAR_EQUIPOS
AS
	BEGIN
		SELECT CONVERT(VARCHAR(20), EquipoID) + ' - ' + TipoEquipo as Equipo, EquipoID from Equipos
	END
GO


CREATE PROCEDURE CONSULTAR_USUARIOS
AS
	BEGIN
		SELECT * FROM Usuarios
	END
GO

CREATE PROCEDURE CONSULTAR_TECNICOS
AS
	BEGIN		
		SELECT CONVERT(VARCHAR(20), TecnicoID) + ' - ' + Nombre as Tecnico, TecnicoID from Tecnicos
	END
GO


CREATE PROCEDURE CONSULTAR_DetallesReparacion
@LOGIN VARCHAR(15),
@ROLID INT
AS
	BEGIN
		IF @ROLID = 2
			BEGIN
				SELECT DR.DetalleID, DR.ReparacionID, DR.Descripcion, T.Nombre AS Tecnico, DR.FechaInicio, DR.FechaFin FROM DetallesReparacion DR
				LEFT JOIN Asignaciones A ON DR.ReparacionID = A.ReparacionID
				LEFT JOIN SystemUTecnicos SU ON A.TecnicoID = SU.TecnicoID 
				LEFT JOIN Tecnicos T ON A.TecnicoID = T.TecnicoID
				WHERE SU.LogInUser = @LOGIN				
			END
		ELSE
			BEGIN
				SELECT DR.DetalleID, DR.ReparacionID, DR.Descripcion, T.Nombre AS Tecnico, DR.FechaInicio, DR.FechaFin FROM DetallesReparacion DR
				LEFT JOIN Asignaciones A ON DR.ReparacionID = A.ReparacionID				
				LEFT JOIN Tecnicos T ON A.TecnicoID = T.TecnicoID
			END
	END
GO


CREATE PROCEDURE CONSULTAR_DetallesReparacion_ID
@CODIGO INT,
@LOGIN VARCHAR(15),
@ROLID INT
AS
	BEGIN
		IF @ROLID = 2
			BEGIN
				SELECT DR.DetalleID, DR.ReparacionID, DR.Descripcion, T.Nombre AS Tecnico, DR.FechaInicio, DR.FechaFin FROM DetallesReparacion DR
				LEFT JOIN Asignaciones A ON DR.ReparacionID = A.ReparacionID
				LEFT JOIN SystemUTecnicos SU ON A.TecnicoID = SU.TecnicoID 
				LEFT JOIN Tecnicos T ON A.TecnicoID = T.TecnicoID
				WHERE SU.LogInUser = @LOGIN AND DR.DetalleID = @CODIGO
			END
		ELSE
			BEGIN
				SELECT DR.DetalleID, DR.ReparacionID, DR.Descripcion, T.Nombre AS Tecnico, DR.FechaInicio, DR.FechaFin FROM DetallesReparacion DR
				LEFT JOIN Asignaciones A ON DR.ReparacionID = A.ReparacionID				
				LEFT JOIN Tecnicos T ON A.TecnicoID = T.TecnicoID
				WHERE DR.DetalleID = @CODIGO
			END
	END
GO


CREATE PROCEDURE CONSULTAR_USERROLES
AS
	BEGIN
		SELECT * FROM UserRoles
	END
GO
DROP PROCEDURE CONSULTAR_REPARACIONES
CREATE PROCEDURE CONSULTAR_REPARACIONES
@LOGIN VARCHAR(15),
@ROLID INT
AS
	BEGIN
		IF @ROLID = 2
			BEGIN
				SELECT R.ReparacionID, R.EquipoID, R.FechaSolicitud, R.Estado FROM Reparaciones R
				LEFT JOIN Asignaciones A ON R.ReparacionID = A.ReparacionID
				LEFT JOIN SystemUTecnicos SU ON A.TecnicoID = SU.TecnicoID 
				WHERE SU.LogInUser = @LOGIN
			END
		ELSE
			BEGIN
				SELECT * FROM Reparaciones
			END
	END
GO

CREATE PROCEDURE CONSULTAR_SYSTEMUSERS
AS
	BEGIN
		SELECT * FROM SystemUsers
	END
GO


CREATE PROCEDURE CONSULTAR_ASIGNACIONES_ID
@CODIGO INT,
@LOGIN VARCHAR(15),
@ROLID INT
AS
	BEGIN
		IF @ROLID = 2
			BEGIN
				SELECT A.AsignacionID AS AsignacionID, A.ReparacionID AS ReparacionID, A.TecnicoID AS TecnicoID, A.FechaAsignacion AS FechaAsignacion FROM Asignaciones A
				LEFT JOIN SystemUTecnicos SU ON A.TecnicoID = SU.TecnicoID 
				WHERE SU.LogInUser = @LOGIN AND A.AsignacionID = @CODIGO
			END
		ELSE
			BEGIN
				SELECT A.AsignacionID AS AsignacionID, A.ReparacionID AS ReparacionID, A.TecnicoID AS TecnicoID, A.FechaAsignacion AS FechaAsignacion FROM Asignaciones A
				WHERE A.AsignacionID = @CODIGO
			END
	END
GO

CREATE PROCEDURE CONSULTAR_TECNICOS_ID
@CODIGO INT
 AS
	BEGIN
	  SELECT * FROM Tecnicos WHERE TecnicoID = @CODIGO
	END
GO

CREATE PROCEDURE CONSULTAR_EQUIPOS_ID
@CODIGO INT
 AS
	BEGIN
	  SELECT * FROM Equipos WHERE EquipoID = @CODIGO
	END
GO

CREATE PROCEDURE CONSULTAR_USERROLES_ID
@CODIGO INT
 AS
	BEGIN
	  SELECT * FROM UserRoles WHERE RolID = @CODIGO
	END
GO

CREATE PROCEDURE CONSULTAR_REPARACIONES_ID
@CODIGO INT
 AS
	BEGIN
	  SELECT * FROM Reparaciones WHERE ReparacionID = @CODIGO
	END
GO

CREATE PROCEDURE CONSULTAR_SYSTEMUSERS_ID
@CODIGO INT
 AS
	BEGIN
	  SELECT * FROM SystemUsers WHERE LogInUser = @CODIGO
	END
GO


CREATE PROCEDURE INSERTAR_EQUIPO
@TIPOEQUIPO VARCHAR(50),
@MODELO VARCHAR(50),
@USUARIOID INT
 AS 
	BEGIN
		INSERT INTO Equipos(TipoEquipo, Modelo, UsuarioID) VALUES (@TIPOEQUIPO, @MODELO, @USUARIOID)
	END
GO

CREATE PROCEDURE INSERTAR_USUARIO
@NOMBRE VARCHAR(50),
@CORREOELECTRONICO VARCHAR(50),
@TELEFONO VARCHAR(15)
 AS 
	BEGIN
		INSERT INTO Usuarios(Nombre, CorreoElectronico, Telefono) VALUES (@NOMBRE, @CORREOELECTRONICO, @TELEFONO)
	END
GO

CREATE PROCEDURE INSERTAR_TECNICO
@NOMBRE VARCHAR(50),
@ESPECIALIDAD VARCHAR(20)
AS 
	BEGIN
		INSERT INTO Tecnicos(Nombre, Especialidad) VALUES (@NOMBRE, @ESPECIALIDAD)
	END
GO

CREATE PROCEDURE INSERTAR_USERROLES
@LOGINUSER VARCHAR(50),
@ROLID INT
AS 
	BEGIN
		INSERT INTO UserRoles(LogInUser, RolID) VALUES (@LOGINUSER, @ROLID)		
	END
GO

CREATE PROCEDURE INSERTAR_SYSTEMUSERS
@LOGINUSER VARCHAR(50),
@CLAVE VARCHAR(50)
AS 
	BEGIN
		INSERT INTO SystemUsers(LogInUser, Clave) VALUES (@LOGINUSER, @CLAVE)
	END
GO

CREATE PROCEDURE INSERTAR_ASIGNACIONES
@REPARACIONID VARCHAR(50),
@TECNICOID VARCHAR(50)
AS 
	BEGIN
		INSERT INTO Asignaciones(ReparacionID, TecnicoID) VALUES (@REPARACIONID, @TECNICOID)
	END
GO

CREATE PROCEDURE INSERTAR_REPARACIONES
@EQUIPOID VARCHAR(50),
@ESTADO VARCHAR(50)
AS 
	BEGIN
		INSERT INTO Reparaciones(EquipoID, Estado) VALUES (@EQUIPOID, @ESTADO)
	END
GO

CREATE PROCEDURE INSERTAR_DETALLESREPARACION
@REPARACIONID VARCHAR(50),
@DESCRIPCION VARCHAR(50),
@FECHAFIN DATETIME
AS 
	BEGIN
		INSERT INTO DetallesReparacion(ReparacionID, Descripcion, FechaFin) VALUES (@REPARACIONID, @DESCRIPCION, @FECHAFIN)
	END
GO


INSERT INTO DetallesReparacion(ReparacionID, Descripcion, FechaFin) VALUES (3, 'Arreglar joycon', '2023-12-14')

GO

CREATE PROCEDURE BORRAR_EQUIPO
@CODIGO INT
 AS
	BEGIN
	  DELETE Equipos WHERE EquipoID = @CODIGO
END
GO

CREATE PROCEDURE BORRAR_USUARIO
@CODIGO INT
 AS
	BEGIN
	  DELETE Usuarios WHERE UsuarioID = @CODIGO
END
GO

CREATE PROCEDURE BORRAR_TECNICO
@CODIGO INT
 AS
	BEGIN
	  DELETE Tecnicos WHERE TecnicoID = @CODIGO
END
GO

CREATE PROCEDURE BORRAR_DETALLESREPARACION
@CODIGO INT
 AS
	BEGIN
	  DELETE DetallesReparacion WHERE DetalleID = @CODIGO
END
GO

CREATE PROCEDURE BORRAR_ASIGNACIONES
@CODIGO INT
 AS
	BEGIN
	  DELETE Asignaciones WHERE AsignacionID = @CODIGO
END
GO

CREATE PROCEDURE BORRAR_USERROLES
@CODIGO VARCHAR(50)
 AS
	BEGIN
	  DELETE UserRoles WHERE LogInUser = @CODIGO
END
GO

CREATE PROCEDURE BORRAR_REPARACIONES
@CODIGO INT
 AS
	BEGIN
	  DELETE Reparaciones WHERE ReparacionID = @CODIGO
END
GO

CREATE PROCEDURE BORRAR_SYSTEMUSERS
@CODIGO VARCHAR(15)
 AS
	BEGIN
	  DELETE SystemUsers WHERE LogInUser = @CODIGO
END
GO


CREATE PROCEDURE ACTUALIZAR_EQUIPOID
@CODIGO INT,
@TIPOEQUIPO VARCHAR(50),
@MODELO VARCHAR(50),
@USUARIOID INT
AS
	BEGIN
		UPDATE Equipos SET TipoEquipo = @TIPOEQUIPO, Modelo = @MODELO, UsuarioID = @USUARIOID WHERE EquipoID=@CODIGO
	END
GO

CREATE PROCEDURE ACTUALIZAR_USUARIOID
@CODIGO INT,
@NOMBRE VARCHAR(50),
@CORREOELECTRONICO VARCHAR(50),
@TELEFONO VARCHAR(15)
AS
	BEGIN
		UPDATE Usuarios SET Nombre = @NOMBRE, CorreoElectronico = @CORREOELECTRONICO, Telefono = @TELEFONO WHERE UsuarioID=@CODIGO
	END
GO

CREATE PROCEDURE ACTUALIZAR_TECNICOID
@CODIGO INT,
@NOMBRE VARCHAR(50),
@ESPECIALIDAD VARCHAR(50)
AS
	BEGIN
		UPDATE Tecnicos SET Nombre = @NOMBRE, Especialidad = @ESPECIALIDAD WHERE TecnicoID=@CODIGO
	END
GO


CREATE PROCEDURE ACTUALIZAR_DETALLESREPARACION
@CODIGO INT,
@REPARACIONID INT,
@DESCRIPCION VARCHAR(50),
@FECHAFIN DATETIME
AS
	BEGIN
		UPDATE DetallesReparacion SET ReparacionID = @REPARACIONID, Descripcion = @DESCRIPCION, FechaFin = @FECHAFIN WHERE DetalleID=@CODIGO
	END
GO


CREATE PROCEDURE ACTUALIZAR_ASIGNACIONES
@CODIGO INT,
@REPARACIONID INT,
@TECNICOID INT
AS
	BEGIN
		UPDATE Asignaciones SET ReparacionID = @REPARACIONID, TecnicoID = @TECNICOID WHERE AsignacionID=@CODIGO
	END
GO


CREATE PROCEDURE ACTUALIZAR_USERROLES
@CODIGO VARCHAR(50),
@ROLID INT
AS
	BEGIN
		UPDATE UserRoles SET RolID = @ROLID WHERE LogInUser=@CODIGO
	END
GO


CREATE PROCEDURE ACTUALIZAR_REPARACIONES
@CODIGO INT,
@EQUIPOID INT,
@ESTADO CHAR(1),
@ROLID INT
AS
	BEGIN
		IF @ROLID = 2
			BEGIN
				UPDATE Reparaciones SET Estado = @ESTADO WHERE ReparacionID=@CODIGO
			END
		ELSE
			BEGIN
				UPDATE Reparaciones SET EquipoID = @EQUIPOID, Estado = @ESTADO WHERE ReparacionID=@CODIGO
			END
		
	END
GO

CREATE PROCEDURE ACTUALIZAR_SYSTEMUSERS
@CODIGO INT,
@CLAVE VARCHAR(15)
AS
	BEGIN
		UPDATE SystemUsers SET Clave = @CLAVE WHERE LogInUser=@CODIGO
	END
GO

CREATE PROCEDURE VALIDAR_USUARIO
@loginuser varchar(15),
@clave varchar(15)

	As
		Begin
			Select SU.LogInUser AS LogInUser, SU.Clave AS Clave, UR.RolID AS RolID, R.nombreRol AS NombreRol  
			FROM SystemUsers SU
			INNER JOIN UserRoles UR ON SU.LogInUser = UR.LogInUser
			INNER JOIN Roles R ON UR.RolID = R.RolID
			WHERE SU.LogInUser = @loginuser and SU.Clave = @clave
		End

GO

SELECT * FROM Roles
SELECT * FROM SystemUsers

SELECT SU.LogInUser AS LogInUser, SU.Clave AS Clave, UR.RolID AS RolID  FROM SystemUsers SU
			INNER JOIN UserRoles UR ON SU.LogInUser = UR.LogInUser
			WHERE SU.LogInUser = 'oscar' and SU.Clave = '123'

INSERT INTO Estados Values ('A', 'Anulado'), ('C', 'Cancelado'), ('I', 'Ingresado'), ('P', 'Pendiente'), ('T', 'Terminado')

GO

CREATE PROCEDURE CONSULTA_ESTADOS
As
	Begin
		SELECT id + ' - ' + Descripcion as Estado, id from Estados
	End 

GO


CREATE PROCEDURE CONSULTA_ROLES
as
	Begin
		SELECT CONVERT(VARCHAR(20), RolID) + ' - ' + NombreRol as Rol, RolID from Roles
	End 

GO

CREATE PROCEDURE CONSULTA_ROLES
as
	Begin
		SELECT CONVERT(VARCHAR(20), RolID) + ' - ' + NombreRol as Rol, RolID from Roles
	End 

GO


CREATE PROCEDURE CONSULTAR_REPARACIONESUSUARIO
@LOGIN VARCHAR(15),
@ROLID INT
AS
	BEGIN
		IF @ROLID = 3
			BEGIN
				SELECT R.ReparacionID AS ReparacionID, E.EquipoID AS EquipoID, E.Modelo AS Modelo, U.Nombre AS Nombre, T.Nombre AS Tecnico, R.FechaSolicitud AS FechaSolicitud, R.Estado + ' - ' + S.Descripcion AS Estado  FROM Reparaciones R 
				LEFT JOIN Asignaciones A ON R.ReparacionID = A.ReparacionID
				LEFT JOIN Tecnicos T ON A.TecnicoID = T.TecnicoID				
				INNER JOIN Equipos E ON R.EquipoID = E.EquipoID
				INNER JOIN Usuarios U ON E.UsuarioID = U.UsuarioID
				LEFT JOIN SystemUUsuarios SU ON U.UsuarioID = SU.UsuarioID
				INNER JOIN Estados S ON R.Estado = S.id
				WHERE SU.LogInUser = @LOGIN
			END
		ELSE IF @ROLID = 2
			BEGIN
				SELECT R.ReparacionID AS ReparacionID, E.EquipoID AS EquipoID, E.Modelo AS Modelo, U.Nombre AS Nombre, T.Nombre AS Tecnico, R.FechaSolicitud AS FechaSolicitud, R.Estado + ' - ' + S.Descripcion AS Estado  FROM Reparaciones R 
				LEFT JOIN Asignaciones A ON R.ReparacionID = A.ReparacionID
				LEFT JOIN Tecnicos T ON A.TecnicoID = T.TecnicoID
				LEFT JOIN SystemUTecnicos SU ON T.TecnicoID = SU.TecnicoID
				INNER JOIN Equipos E ON R.EquipoID = E.EquipoID
				INNER JOIN Usuarios U ON E.UsuarioID = U.UsuarioID
				INNER JOIN Estados S ON R.Estado = S.id
				WHERE SU.LogInUser = @LOGIN
			END
		ELSE
			BEGIN
				SELECT R.ReparacionID AS ReparacionID, E.EquipoID AS EquipoID, E.Modelo AS Modelo, U.Nombre AS Nombre, T.Nombre AS Tecnico, R.FechaSolicitud AS FechaSolicitud, R.Estado + ' - ' + S.Descripcion AS Estado  FROM Reparaciones R 
				LEFT JOIN Asignaciones A ON R.ReparacionID = A.ReparacionID
				LEFT JOIN Tecnicos T ON A.TecnicoID = T.TecnicoID				
				INNER JOIN Equipos E ON R.EquipoID = E.EquipoID
				INNER JOIN Usuarios U ON E.UsuarioID = U.UsuarioID
				INNER JOIN Estados S ON R.Estado = S.id
			END
	END
GO


CREATE PROCEDURE CONSULTAR_ASIGNACIONES
@LOGIN VARCHAR(15),
@ROLID INT
AS
	BEGIN
		IF @ROLID = 2
			BEGIN
				SELECT A.AsignacionID AS AsignacionID, A.ReparacionID AS ReparacionID, A.TecnicoID AS TecnicoID, A.FechaAsignacion AS FechaAsignacion FROM Asignaciones A
				LEFT JOIN SystemUTecnicos SU ON A.TecnicoID = SU.TecnicoID 
				WHERE SU.LogInUser = @LOGIN
			END
		ELSE
			BEGIN
				SELECT A.AsignacionID AS AsignacionID, A.ReparacionID AS ReparacionID, A.TecnicoID AS TecnicoID, A.FechaAsignacion AS FechaAsignacion FROM Asignaciones A
			END
	END








/*WIP*/
SELECT * FROM [dbo].[SystemUTecnicos]
SELECT * FROM [dbo].[SystemUUsuarios]
SELECT * FROM Reparaciones
SELECT * FROM [dbo].[Usuarios]
SELECT * FROM [dbo].[SystemUsers]
SELECT * FROM UserRoles

CREATE PROCEDURE CONSULTAR_REPARACIONESUSUARIO_ID
@ID INT
AS
	BEGIN
		SELECT R.ReparacionID AS ReparacionID, E.EquipoID AS EquipoID, E.Modelo AS Modelo, U.Nombre AS Nombre, R.FechaSolicitud AS FechaSolicitud, R.Estado + ' - ' + S.Descripcion AS Estado  FROM Reparaciones R 
		INNER JOIN Equipos E ON R.EquipoID = E.EquipoID
		INNER JOIN Usuarios U ON E.UsuarioID = U.UsuarioID
		INNER JOIN Estados S ON R.Estado = S.id
		WHERE R.ReparacionID = @ID
	END




CREATE PROCEDURE ReporteGeneral_Filtro
	@CODIGO INT
	AS
		BEGIN
			SELECT CONVERT(VARCHAR(20), U.UsuarioID) + '-' + U.Nombre AS [ID Usuario], U.Telefono, U.CorreoElectronico, CONVERT(VARCHAR(20), E.EquipoID) + '-' + E.Modelo AS [ID Equipo], D.Descripcion AS [Detalle reparacion],
			R.Estado, D.FechaInicio AS [Fecha Inicio], D.FechaFin AS [Fecha Fin], CONVERT(VARCHAR(20), T.TecnicoID) + '-' + T.Nombre AS [ID Tecnico], R.ReparacionID AS [ID Reparacion],
			R.FechaSolicitud
			FROM Usuarios U
			INNER JOIN Equipos E ON U.UsuarioID = E.UsuarioID
			INNER JOIN Reparaciones R ON E.EquipoID = R.EquipoID
			INNER JOIN DetallesReparacion D ON D.ReparacionID = R.ReparacionID
			INNER JOIN Asignaciones A ON R.ReparacionID = A.ReparacionID
			INNER JOIN Tecnicos T ON A.TecnicoID = T.TecnicoID
			WHERE T.TecnicoID = @CODIGO
		END
GO
 

EXEC ReporteGeneral_Filtro @CODIGO = 2

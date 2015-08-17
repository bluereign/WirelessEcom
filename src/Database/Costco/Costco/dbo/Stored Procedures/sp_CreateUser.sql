-- Name: sp_CreateUser
-- Author: Danny Goodisman
-- Date: 5/120/2005
-- Description: This procedure creates a user. It is faster to do this in a stored procedure than in a "naked" query.
--

CREATE PROCEDURE sp_CreateUser
	@IP varchar(50),
	@Host varchar(255),
	@Browser varchar(99),
	@HttpFrom varchar(1500),
	@ST int,
	@ST2 int,
	@ST3 int
AS


INSERT INTO Users (Username, Password, IP, Host, Browser, HttpFrom, ST, ST2, ST3, Country, ShipCountry, timelastsessionbegan, datecreated )
VALUES ('', '', @IP, @Host, @Browser, @HttpFrom, @ST, @ST2, @ST3,  '211', '211', getdate(), getDate() )

return scope_identity()
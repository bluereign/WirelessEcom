CREATE PROCEDURE sUser
@theid int, @st int, @st2 int, @st3 int  AS
BEGIN
SELECT Users.User_ID, Users.FirstName, Users.MiddleInitial, Users.Company, Users.LastName, Users.CarID, Users.TimeLastAuthenticated, Users.ST, 
Users.ST2, Users.ST3, Users.TIMEPREVIOUSSESSIONBEGAN, Users.UserName, Users.SID, Users.ST_ID, Users.AF_ID, Users.zip, Users.password, 
Users.TimeLastAuthenticated, Users.TimeLastSessionBegan, 'Cookies' AS AuthenticatedBy, '' AS ID_String,TimeLastAuthenticated, 
Users.Country, Users.State, Users.Address1, Users.Address2, Users.City, Users.receive_email, Users.email,
Users.ShipCountry, Users.ShipState, Users.ShipAddress1, Users.ShipAddress2, Users.ShipCity, Users.HomePhone, Users.WorkPhone,
(select max(order_id) from orders o where Users.user_id = o.user_id and orderdate is null) as order_id, st, st2, st3, user_id, timeprevioussessionbegan
FROM Users
WHERE users.User_ID= @theid AND
st= @st AND
st2= @st2 AND
st3= @st3


END
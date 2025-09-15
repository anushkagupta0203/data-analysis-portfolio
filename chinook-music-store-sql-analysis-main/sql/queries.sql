
-- 1. List the top 5 customers by total purchase amount
SELECT c.CustomerId, c.FirstName || ' ' || c.LastName AS CustomerName, 
       SUM(i.Total) AS TotalSpent
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalSpent DESC
LIMIT 5;


-- 2. Find the most popular genre in terms of total tracks sold
SELECT g.GenreId, g.Name AS Genre, SUM(ii.Quantity) AS TotalTracksSold
FROM InvoiceLine ii
JOIN Track t ON ii.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.GenreId
ORDER BY TotalTracksSold DESC
LIMIT 1;


-- 3. Retrieve all employees who are managers along with their subordinates
SELECT e1.EmployeeId AS ManagerId, e1.FirstName || ' ' || e1.LastName AS Manager,
       e2.EmployeeId AS EmployeeId, e2.FirstName || ' ' || e2.LastName AS Employee
FROM Employee e1
JOIN Employee e2 ON e1.EmployeeId = e2.ReportsTo
ORDER BY ManagerId, EmployeeId;


-- 4. For each artist, find their most sold album
WITH AlbumSales AS (
    SELECT a.AlbumId, a.Title AS Album, ar.Name AS Artist,
           SUM(ii.Quantity) AS TotalSold
    FROM InvoiceLine ii
    JOIN Track t ON ii.TrackId = t.TrackId
    JOIN Album a ON t.AlbumId = a.AlbumId
    JOIN Artist ar ON a.ArtistId = ar.ArtistId
    GROUP BY a.AlbumId
)
SELECT Artist, Album, TotalSold
FROM AlbumSales
WHERE (Artist, TotalSold) IN (
    SELECT Artist, MAX(TotalSold)
    FROM AlbumSales
    GROUP BY Artist
);


-- 5. Write a query to get monthly sales trends in the year 2013
SELECT strftime('%Y-%m', InvoiceDate) AS Month, 
       SUM(Total) AS MonthlySales
FROM Invoice
WHERE strftime('%Y', InvoiceDate) = '2013'
GROUP BY Month
ORDER BY Month;

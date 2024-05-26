-- 1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
SELECT ProductName, QuantityPerUnit
FROM
Products

-- 2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
SELECT ProductID, ProductName
FROM Products
WHERE Discontinued != 1

-- 3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
SELECT ProductID, ProductName
FROM Products
WHERE Discontinued = 0 -- :)

-- 4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice < 20

-- 5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE UnitPrice > 15 AND UnitPrice < 25

-- 6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
-- Koşulu sağlayan ürünlerin listesi
SELECT ProductName, UnitsOnOrder, UnitsInStock
FROM Products
WHERE UnitsInStock < UnitsOnOrder

-- 7. İsmi `a` ile başlayan ürünleri listeleyeniz.
SELECT *
FROM Products
WHERE ProductName LIKE 'a%' 
-- LIKE keyword is case insensitive in SQL Server and MySQL. It is case sensitive in PostgreSQL.

-- 8. İsmi `i` ile biten ürünleri listeleyeniz.
SELECT *
FROM Products
WHERE ProductName LIKE '%i'

-- 9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
SELECT ProductName, UnitPrice, UnitPrice * 1.18 AS UnitPriceKDV
FROM Products

-- 10. Fiyatı 30 dan büyük kaç ürün var?
SELECT COUNT(*) AS NumberOfProducts
FROM Products
WHERE UnitPrice > 30

-- 11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
SELECT LOWER(ProductName) AS LowerCaseProductName
FROM Products
ORDER BY UnitPrice DESC

-- 12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
SELECT CONCAT(FirstName, ' ' ,LastName) AS FullName
FROM Employees

-- 13. Region alanı NULL olan kaç tedarikçim var?
SELECT COUNT(SupplierID)
FROM Suppliers
WHERE Region IS NULL

-- 14. a.Null olmayanlar?
SELECT COUNT(SupplierID)
FROM Suppliers
WHERE Region IS NOT NULL

-- 15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
SELECT CONCAT('TR ', UPPER(ProductName))
FROM Products

-- 16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
SELECT CONCAT('TR ', UPPER(ProductName))
FROM Products
WHERE UnitPrice < 20

-- 17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
-- en pahalı ürün
SELECT TOP 1 ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

-- 18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT TOP 10 ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC

-- 19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice)
                   FROM Products)

-- 20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
SELECT SUM(UnitPrice * UnitsInStock) AS TotalEarnings
FROM Products
WHERE UnitsInStock > 0

-- 21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
SELECT COUNT(ProductID) AS InStockAndDiscontinuedCount
FROM Products
WHERE Discontinued = 1 AND UnitsInStock > 0

-- 22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
SELECT C.CategoryName, P.*
FROM Products P
LEFT JOIN Categories C
ON P.CategoryID = C.CategoryID

-- 23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
SELECT C.CategoryName, AVG(UnitPrice) AS AveragePrice
FROM Products P
RIGHT JOIN Categories C
ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryID, C.CategoryName

-- 24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
SELECT TOP 1 P.ProductName, P.UnitPrice, C.CategoryName
FROM Products P
LEFT JOIN Categories C
ON C.CategoryID = P.CategoryID
ORDER BY UnitPrice DESC

-- 25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
SELECT TOP 1 P.ProductName, C.CategoryName, S.CompanyName, SUM(OD.Quantity) AS QuantityOfMostSoldProduct
FROM [Order Details] OD
INNER JOIN Products P
ON P.ProductID = OD.ProductID
LEFT JOIN Categories C
ON C.CategoryID = P.CategoryID
LEFT JOIN Suppliers S
ON S.SupplierID = P.SupplierID
GROUP BY OD.ProductID, P.ProductName, C.CategoryName, S.CompanyName
ORDER BY QuantityOfMostSoldProduct DESC

--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
SELECT P.ProductID, ProductName, S.CompanyName, S.Phone
FROM Products P
LEFT JOIN Suppliers S
ON P.SupplierID = S.SupplierID
WHERE UnitsInStock = 0

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT O.ShipAddress, CONCAT(E.FirstName,' ', E.LastName) AS Employee
FROM Orders O
LEFT JOIN Employees E
ON O.EmployeeID = E.EmployeeID
WHERE O.OrderDate BETWEEN '1998-03-01' AND '1998-03-31'

--28. 1997 yılı şubat ayında kaç siparişim var?
SELECT COUNT(*) AS OrderCount
FROM Orders
WHERE OrderDate BETWEEN '1997-02-01' AND '1997-02-28'

--29. London şehrinden 1998 yılında kaç siparişim var?
SELECT COUNT(*) AS OrderCount
FROM Orders
WHERE 
    ShipCity = 'London'
    AND OrderDate BETWEEN '1998-01-01' AND '1998-12-31'

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
SELECT C.ContactName, C.Phone
FROM Orders O
LEFT JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE O.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'

--31. Taşıma ücreti 40 üzeri olan siparişlerim


--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı


--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),


--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )


--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad


--36. Geciken siparişlerim?


--37. Geciken siparişlerimin tarihi, müşterisinin adı


--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi


--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı


--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti


--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID, Ad soyad
--tek siparişte en fazla ciroyu elde eden çalışanı ele alırsak..


--42. 1997 yılında en çok satış yapan çalışanımın ID, Ad soyad ****
--ürün adedine göre


--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?


--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre


--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?


--son 5 siparişin toplam tutarının ortalaması


--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?


--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?


--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı


--49. Kaç ülkeden müşterim var


--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?


--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi


--52. 10248 nolu siparişin ürünlerinin adı, tedarikçi adı


--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti


--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
--ürün adedini baz alırsak..

	 
--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
--satış tutarına göre

						
--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?


--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre


--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?


--son 5 siparişin toplam tutarının ortalaması

		
--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

 
--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?


--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı


--62. Kaç ülkeden müşterim var


--63. Hangi ülkeden kaç müşterimiz var


--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?


--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?


--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?


--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun


--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri


--69. Brezilya’da olmayan müşteriler


--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler


--71. Faks numarasını bilmediğim müşteriler


--72. Londra’da ya da Paris’de bulunan müşterilerim


--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler


--74. C ile başlayan ürünlerimin isimleri ve fiyatları


--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri


--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları


--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları


--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri


--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler


--80. Faks numarasını bilmediğim müşteriler


--81. Müşterilerimi ülkeye göre sıralıyorum:


--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz


--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz


--84. 1 Numaralı kategoride kaç ürün vardır..?


--85. Kaç farklı ülkeye ihracat yapıyorum..?


--86. a.Bu ülkeler hangileri..? (ihracat yaptığımız ülkeler)


--87. En Pahalı 5 ürün


--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?


--89. Ürünlerimin toplam maliyeti


--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?


--91. Ortalama Ürün Fiyatım


--92. En Pahalı Ürünün Adı


--93. En az kazandıran sipariş


--94. Müşterilerimin içinde en uzun isimli müşteri


--95. Çalışanlarımın Ad, Soyad ve Yaşları


--96. Hangi üründen toplam kaç adet alınmış..?


--97. Hangi siparişte toplam ne kadar kazanmışım..?


--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?


--99. 1000 Adetten fazla satılan ürünler?


--100. Hangi Müşterilerim hiç sipariş vermemiş..?


--101. Hangi tedarikçi hangi ürünü sağlıyor ?


--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?


--103. Hangi siparişi hangi müşteri verir..?


--104. Hangi çalışan, toplam kaç sipariş almış..?


--105. En fazla siparişi kim almış..?


--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?


--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?


--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş, hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış


--109. Altında ürün bulunmayan kategoriler


--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.


--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
--for FR


--for Fr


--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.


--113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.


--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)


--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.


--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.


--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.


--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.


--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)


--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)


--121. Konbu adlı üründen kaç adet satılmıştır.

					
--with group by						


--122. Japonyadan kaç farklı ürün tedarik edilmektedir.


--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?


--124. Faks numarası olan tüm müşterileri listeleyiniz.


--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 


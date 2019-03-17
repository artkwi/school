-- KLASA, KT�RA WYPADA NAJLEPIEJ DLA DANYCH ZAJ��


IF OBJECT_ID('NAJLEPSZA_KLASA','P') IS NOT NULL
DROP PROCEDURE NAJLEPSZA_KLASA
GO

CREATE PROCEDURE NAJLEPSZA_KLASA (@zajecia VARCHAR(45))
AS
	SELECT TOP(1) ROUND(AVG(O.OCENA),2) AS SREDNIA, U.KLASA FROM OCENY O INNER JOIN UCZNIOWIE U ON O.UCZEN = U.PESEL INNER JOIN ZAJECIA Z ON O.ZAJECIA = Z.ID WHERE Z.PRZEDMIOT=@zajecia GROUP BY U.KLASA
GO

EXEC NAJLEPSZA_KLASA 'historia'

-- LISTA NAUCZYCIELI, KT�RZY UCZ� UCZNIA, KT�RY MA NAJLEPSZ� �REDNI� ZE WSZYSTKICH UCZNI�W


IF OBJECT_ID('NAUCZYCIELE_NAJLEPSZEGO_UCZNIA','P') IS NOT NULL
DROP PROCEDURE NAUCZYCIELE_NAJLEPSZEGO_UCZNIA
GO

CREATE PROCEDURE NAUCZYCIELE_NAJLEPSZEGO_UCZNIA (@zajecia VARCHAR(45))
AS
	SELECT DISTINCT  N.IMIE + ' ' + N.NAZWISKO AS NAUCZYCIEL, U.IMIE +' ' +U.NAZWISKO AS UCZEN , D.SREDNIA FROM UCZNIOWIE U INNER JOIN (SELECT TOP(1) AVG(O.OCENA) AS SREDNIA , O.UCZEN FROM OCENY O GROUP BY O.UCZEN) AS D  ON U.PESEL = D.UCZEN INNER JOIN KLASY K ON K.KLASA = U.KLASA INNER JOIN ZAJECIA Z ON Z.KLASA = K.KLASA INNER JOIN NAUCZYCIELE N ON N.PESEL = Z.NAUCZYCIEL
GO

EXEC NAUCZYCIELE_NAJLEPSZEGO_UCZNIA 'historia'





-- OCENY PO TERMINIE (2 PARAMETRY), ABY ZOBACZY�, KTO JESZCZE MO�E POPRAWI� PRACE


IF OBJECT_ID('OCENY_PO_TERMINIE','P') IS NOT NULL
DROP PROCEDURE OCENY_PO_TERMINIE
GO

CREATE PROCEDURE OCENY_PO_TERMINIE (@klasa VARCHAR(10),@data DATE)
AS
	SELECT  U.IMIE, U.NAZWISKO, O.OCENA, U.KLASA, O.DATA_W, Z.PRZEDMIOT, O.OPIS FROM OCENY O INNER JOIN UCZNIOWIE U ON O.UCZEN = U.PESEL INNER JOIN ZAJECIA Z ON O.ZAJECIA = Z.ID WHERE O.DATA_W>=@data AND Z.KLASA=@klasa
GO

EXEC OCENY_PO_TERMINIE '1A', '20170118'


-- WY�WIETLENIE PLANU LEKCJI DLA DANEJ KLASY (PROCEDURA 1 PARAMETR)

IF OBJECT_ID('PLAN_KLASY','P') IS NOT NULL
DROP PROCEDURE PLAN_KLASY
GO

CREATE PROCEDURE PLAN_KLASY (@klasa VARCHAR(10))
AS
	SELECT Z.ID AS ID_PRZEDMIOTU, Z.PRZEDMIOT, Z.KLASA, N.IMIE AS IMIE_NAUCZYCIELA, N.NAZWISKO AS NAZWISKO_NAUCZYCIELA, Z.DZIEN, LEFT(Z.GODZINA,5) AS GODZINA FROM ZAJECIA Z INNER JOIN NAUCZYCIELE N ON Z.NAUCZYCIEL = N.PESEL WHERE KLASA=@klasa
 GO

EXEC PLAN_KLASY '1A'




-- WY�WIETL �REDNI� OCEN DLA PODANEJ KLASY I PRACY (2 PARAMETRY)

IF OBJECT_ID('SREDNIA_PRACY','P') IS NOT NULL
DROP PROCEDURE SREDNIA_PRACY
GO

CREATE PROCEDURE SREDNIA_PRACY (@klasa VARCHAR(10), @opis VARCHAR(45))
AS
	SELECT ROUND(AVG(ISNULL(O.OCENA,1)),2) AS SREDNIA FROM OCENY O INNER JOIN UCZNIOWIE U ON O.UCZEN = U.PESEL INNER JOIN ZAJECIA Z ON O.ZAJECIA = Z.ID WHERE U.KLASA=@klasa AND O.OPIS=@opis
GO

EXEC SREDNIA_PRACY '1A', 'sprawdzian geometria'



-- WY�WIETLA WSZYSTKIE OCENY NDST ZE WSZYSTKICH KLAS (WIDOK) - KTO POWINIEN POPRAWI�
IF OBJECT_ID('OCENY_NIEZALICZONE','V') IS NOT NULL
DROP VIEW OCENY_NIEZALICZONE
GO

CREATE VIEW OCENY_NIEZALICZONE
AS
	SELECT  U.IMIE, U.NAZWISKO, O.OCENA, U.KLASA, O.DATA_W, Z.PRZEDMIOT, O.OPIS FROM OCENY O INNER JOIN UCZNIOWIE U ON O.UCZEN = U.PESEL INNER JOIN ZAJECIA Z ON O.ZAJECIA = Z.ID WHERE O.OCENA=1 OR O.OCENA IS NULL
GO

SELECT * FROM OCENY_NIEZALICZONE



-- WY�WIETLA WSZYSTKIE OCENY DLA DANEJ KLASY
IF OBJECT_ID('OCENY_KLASY','P') IS NOT NULL
DROP PROCEDURE OCENY_KLASY
GO


CREATE PROCEDURE OCENY_KLASY (@klasa VARCHAR(10))
AS
	select O.ZAJECIA, U.IMIE, U.NAZWISKO, O.OCENA, O.DATA_W, O.OPIS, U.KLASA from OCENY o inner join UCZNIOWIE u on o.UCZEN = u.PESEL where u.KLASA=@klasa 
GO

EXEC OCENY_KLASY '1A'
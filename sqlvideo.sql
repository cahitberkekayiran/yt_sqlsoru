--Soru 1:
--��renciler tablosuna yeni bir kay�t eklendi�inde, notlar tablosuna vize, final ve ortalama alanlar� NULL olacak �ekilde
--sadece ogrenci_id de�erini ekleyecek bir trigger (tetikleyici) olu�turun.

create trigger notlar_ekle
on ogrenciler
after insert
as
declare @SonOgrenciID int
set @SonOgrenciID=@@IDENTITY
insert into notlar(ogrenci_id,vize,final,ortalama) values (@SonOgrenciID,NULL,NULL,NULL)



--Soru 2:
--A�a��daki i�lemi ger�ekle�tirin:

--ALTER TABLE notlar
--ADD CONSTRAINT notgiris FOREIGN KEY (ogrenci_id) REFERENCES ogrenciler(id);
--Bu k�s�tlay�c�y� olu�turduktan sonra, hata mesaj� verecek bir durum belirtin ve sorgusunu yaz�n.

ALTER TABLE notlar
ADD CONSTRAINT notgiris FOREIGN KEY (ogrenci_id) REFERENCES ogrenciler(id)
delete from ogrenciler where id=1


--Soru 3:
--Notlar tablosundaki ortalama s�tununa, b�t�n ��renciler i�in s�ras�yla ortalama = vize * 0.4 + final * 0.6 hesab�yla ortalama hesaplay�p,
--NULL alanlara aktaracak bir prosed�r olu�turun ve �al��t�racak komut sat�r�n� yaz�n.
create procedure OrtalamaHesapla
as
update notlar set ortalama= (vize*0.4)+(final*0.6) where ortalama IS NULL
exec OrtalamaHesapla

--Soru 4:
--��renci ad�, soyad�, ID�si ve vize, final, ortalama bilgilerini, ��renci ID bilgisine g�re gruplayarak bir VIEW olu�turun.
create view ogrenci
as
select ad,soyad,id,vize,final,ortalama from ogrenciler o inner join notlar n on o.id=n.ogrenciid group by ogrenci_id

--Soru 5:
--Her ��rencinin tc no, ad, ogrenci id, vize, final ve ortalama alanlar�ndaki verileri, her ��renci i�in alt alta yaz�p bir sat�r bo�luk b�rakacak bir sorgu olu�turun.
declare @tc int,@ad nvarchar(max),@ogrenciid int,@vize float, @final float,@ortalama float,@sira int
select @sira=COUNT(*) from ogrenciler
set @ogrenciid=1
while(@ogrenciid<=@sira)
begin
select @tc=tc, @ad=ad,@vize=vize,@final=final,@ortalama=ortalama from ogrenciler o inner join notlar n on o.id=n.ogrenci_id where ogrenci_id=@ogrenciid
print 'Ogrencinin TC no' +cast(@tc as nvarchar) +CHAR(10)
print 'Ogrencinin Ad� :' +cast(@ad as nvarchar) +CHAR(10)
print 'Ogrencinin ID :' +cast(@ogrenciid as nvarchar) +CHAR(10)
print 'Ogrencinin vize' +cast(@vize as nvarchar) +CHAR(10)
print 'Ogrencinin final' +cast(@final as nvarchar) +CHAR(10)
print 'Ogrencinin ortalama' +cast(@ortalama as nvarchar) +CHAR(10)
set @ogrenciid=@ogrenciid+1
end


--Soru 6:
--tblyedek ad�nda bir ge�ici tablo olu�turun.
--Notlar tablosundan, bu tabloya verilerin tamam�n� aktar�n.
--Ard�ndan, tblyedek tablosundaki 60 ortalamas�n�n �zerindeki kay�t say�s�n� ekranda g�sterin.

select * into #tblyedek from notlar
declare @kayitsayisi int 
select * from #tblyedek where ortalama>60
set @kayitsayisi=@@IDENTITY
print ' kay�t sayisi : '+cast(@kayitsayisi as nvarchar)

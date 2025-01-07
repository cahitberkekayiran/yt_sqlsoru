--Soru 1:
--Öðrenciler tablosuna yeni bir kayýt eklendiðinde, notlar tablosuna vize, final ve ortalama alanlarý NULL olacak þekilde
--sadece ogrenci_id deðerini ekleyecek bir trigger (tetikleyici) oluþturun.

create trigger notlar_ekle
on ogrenciler
after insert
as
declare @SonOgrenciID int
set @SonOgrenciID=@@IDENTITY
insert into notlar(ogrenci_id,vize,final,ortalama) values (@SonOgrenciID,NULL,NULL,NULL)



--Soru 2:
--Aþaðýdaki iþlemi gerçekleþtirin:

--ALTER TABLE notlar
--ADD CONSTRAINT notgiris FOREIGN KEY (ogrenci_id) REFERENCES ogrenciler(id);
--Bu kýsýtlayýcýyý oluþturduktan sonra, hata mesajý verecek bir durum belirtin ve sorgusunu yazýn.

ALTER TABLE notlar
ADD CONSTRAINT notgiris FOREIGN KEY (ogrenci_id) REFERENCES ogrenciler(id)
delete from ogrenciler where id=1


--Soru 3:
--Notlar tablosundaki ortalama sütununa, bütün öðrenciler için sýrasýyla ortalama = vize * 0.4 + final * 0.6 hesabýyla ortalama hesaplayýp,
--NULL alanlara aktaracak bir prosedür oluþturun ve çalýþtýracak komut satýrýný yazýn.
create procedure OrtalamaHesapla
as
update notlar set ortalama= (vize*0.4)+(final*0.6) where ortalama IS NULL
exec OrtalamaHesapla

--Soru 4:
--Öðrenci adý, soyadý, ID’si ve vize, final, ortalama bilgilerini, öðrenci ID bilgisine göre gruplayarak bir VIEW oluþturun.
create view ogrenci
as
select ad,soyad,id,vize,final,ortalama from ogrenciler o inner join notlar n on o.id=n.ogrenciid group by ogrenci_id

--Soru 5:
--Her öðrencinin tc no, ad, ogrenci id, vize, final ve ortalama alanlarýndaki verileri, her öðrenci için alt alta yazýp bir satýr boþluk býrakacak bir sorgu oluþturun.
declare @tc int,@ad nvarchar(max),@ogrenciid int,@vize float, @final float,@ortalama float,@sira int
select @sira=COUNT(*) from ogrenciler
set @ogrenciid=1
while(@ogrenciid<=@sira)
begin
select @tc=tc, @ad=ad,@vize=vize,@final=final,@ortalama=ortalama from ogrenciler o inner join notlar n on o.id=n.ogrenci_id where ogrenci_id=@ogrenciid
print 'Ogrencinin TC no' +cast(@tc as nvarchar) +CHAR(10)
print 'Ogrencinin Adý :' +cast(@ad as nvarchar) +CHAR(10)
print 'Ogrencinin ID :' +cast(@ogrenciid as nvarchar) +CHAR(10)
print 'Ogrencinin vize' +cast(@vize as nvarchar) +CHAR(10)
print 'Ogrencinin final' +cast(@final as nvarchar) +CHAR(10)
print 'Ogrencinin ortalama' +cast(@ortalama as nvarchar) +CHAR(10)
set @ogrenciid=@ogrenciid+1
end


--Soru 6:
--tblyedek adýnda bir geçici tablo oluþturun.
--Notlar tablosundan, bu tabloya verilerin tamamýný aktarýn.
--Ardýndan, tblyedek tablosundaki 60 ortalamasýnýn üzerindeki kayýt sayýsýný ekranda gösterin.

select * into #tblyedek from notlar
declare @kayitsayisi int 
select * from #tblyedek where ortalama>60
set @kayitsayisi=@@IDENTITY
print ' kayýt sayisi : '+cast(@kayitsayisi as nvarchar)

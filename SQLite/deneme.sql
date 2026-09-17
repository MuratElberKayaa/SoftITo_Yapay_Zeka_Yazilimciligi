-- Bölüm 1
CREATE TABLE oyuncaklar(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	isim TEXT NOT NULL,
	cesit TEXT,
	fiyat INTEGER CHECK (fiyat > 0),
	renk TEXT IF NULL DEFAULT 'kırmızı'
);
-- Bölüm 2
INSERT INTO oyuncaklar (isim,cesit,fiyat) VALUES ('Şimşek','Araba',50)
INSERT INTO oyuncaklar (isim,cesit,fiyat,renk) VALUES 
('Ayıcık','peluş',80,'kahverengi'),
('Kale Seti','lego',150,'gri'),
('Zıpzıp','top',20,'sarı'),
('Barbi','bebek',90,'pembe');
-- Bölüm 3

SELECT * FROM oyuncaklar;
SELECT isim,fiyat FROM oyuncaklar WHERE fiyat >= 80;
SELECT * FROM oyuncaklar ORDER BY fiyat DESC LIMIT 2;
SELECT * FROM oyuncaklar WHERE isim LIKE 'Z%';
SELECT * FROM oyuncaklar WHERE cesit = 'Araba' OR cesit ='top';
SELECT * FROM oyuncaklar WHERE fiyat BETWEEN 20 AND 60;

--Bölüm 4
UPDATE oyuncaklar SET renk='mavi' WHERE isim = 'Şimşek';
DELETE FROM oyuncaklar WHERE isim = 'Zıpzıp';

--Bölüm 5

ALTER TABLE oyuncaklar ADD COLUMN kimin TEXT;
UPDATE oyuncaklar SET kimin='Ali' WHERE isim = 'Kale Seti';
ALTER TABLE oyuncaklar RENAME cesit TO tur;




-- BOLUM 1 TABLO OLUŞTURMA
PRAGMA foreign_keys = ON;

CREATE TABLE uyeler (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ad TEXT NOT NULL,
    yas INTEGER NOT NULL CHECK (yas > 13),
    sehir TEXT DEFAULT 'Erzincan',
    kayit DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE kitaplar (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
    kitap_adi TEXT NOT NULL UNIQUE
);

CREATE TABLE odunc (
    uye_id INTEGER REFERENCES uyeler(id) ON DELETE CASCADE,
    kitap_id INTEGER REFERENCES kitaplar(id),
    gun INTEGER NOT NULL CHECK (gun > 0),
    PRIMARY KEY (uye_id, kitap_id)
);
-- BOLUM 2 VERİ EKLEME
INSERT INTO kitaplar (kitap_adi) VALUES 
('Roman'),
('Hikaye'),
('Masal'),
('Ansiklopedi'),
('Bilim Kurgu'),
('Yabancı');

INSERT INTO uyeler (ad, yas, sehir) VALUES 
('Ahmet Yılmaz', 15, 'Ankara'),
('Ayşe Demir', 16, 'İstanbul'),
('Mehmet Kaya', 14, 'Erzincan'),
('Fatma Çelik', 17, 'İzmir'),
('Can Şahin', 15, 'Bursa'),
('Zeynep Aydın', 18, 'Erzincan'),
('Ali Koç', 14, 'Antalya'),
('Elif Arslan', 16, 'Trabzon'),
('Mustafa Yıldız', 15, 'Erzincan'),
('İrem Öztürk', 17, 'Adana');

INSERT INTO odunc (uye_id, kitap_id, gun) VALUES 
(1, 1, 10), (1, 2, 35),
(2, 2, 5),  (2, 3, 20),
(3, 1, 42), (3, 4, 18),
(4, 3, 12), (4, 5, 31),
(5, 4, 25), (5, 5, 8),
(6, 1, 14), (6, 3, 40),
(7, 2, 19), (7, 4, 22),
(8, 3, 7),  (8, 5, 33),
(9, 1, 28), (9, 2, 11),
(10, 4, 38), (10, 5, 44);

-- BOLUM 3 TABLO BIRLESTIRME

-- üye kitap gün listesi
SELECT u.ad AS uye_adi, k.kitap_adi, o.gun
FROM odunc o
INNER JOIN uyeler u ON o.uye_id = u.id
INNER JOIN kitaplar k ON o.kitap_id = k.id;

-- 30 günden uzun olanlar
SELECT u.ad AS uye_adi, k.kitap_adi, o.gun
FROM odunc o
INNER JOIN uyeler u ON o.uye_id = u.id
INNER JOIN kitaplar k ON o.kitap_id = k.id
WHERE o.gun > 30;

-- sadece erzincan üyeleri
SELECT u.ad AS uye_adi, u.sehir, k.kitap_adi, o.gun
FROM odunc o
INNER JOIN uyeler u ON o.uye_id = u.id
INNER JOIN kitaplar k ON o.kitap_id = k.id
WHERE u.sehir = 'Erzincan';

-- kitap almayan üyeler
SELECT u.ad AS uye_adi, k.kitap_adi, o.gun
FROM uyeler u
LEFT JOIN odunc o ON u.id = o.uye_id
LEFT JOIN kitaplar k ON o.kitap_id = k.id;

-- Ortalama adet en uzun süre
SELECT 
    u.ad,
    ROUND(AVG(o.gun), 2) AS ortalama_gun,
    COUNT(o.kitap_id) AS alinan_kitap_sayisi,
    MAX(o.gun) AS en_uzun_gun
FROM uyeler u
INNER JOIN odunc o ON u.id = o.uye_id
GROUP BY u.id, u.ad;

-- having kullanımı filtreleme
SELECT 
    u.ad,
    ROUND(AVG(o.gun), 2) AS ortalama_gun
FROM uyeler u
INNER JOIN odunc o ON u.id = o.uye_id
GROUP BY u.id, u.ad
HAVING AVG(o.gun) > 20;

-- kitap odunc sayıları
SELECT 
    k.kitap_adi,
    COUNT(o.kitap_id) AS odunc_sayisi
FROM kitaplar k
LEFT JOIN odunc o ON k.id = o.kitap_id
GROUP BY k.id, k.kitap_adi;

-- şehirlere göre üye sayısı
SELECT 
    sehir,
    COUNT(*) AS uye_sayisi
FROM uyeler
GROUP BY sehir
ORDER BY uye_sayisi DESC;

-- 30 günden uzun tutanlar
SELECT ad 
FROM uyeler 
WHERE id IN (
    SELECT uye_id 
    FROM odunc 
    WHERE gun > 30
);

-- hiç ödünç alınmamış kitaplar 
SELECT kitap_adi 
FROM kitaplar 
WHERE id NOT IN (
    SELECT DISTINCT kitap_id 
    FROM odunc
);

-- Genel ortalama üstü kayıtlar
SELECT 
    u.ad,
    k.kitap_adi,
    o.gun
FROM odunc o
INNER JOIN uyeler u ON o.uye_id = u.id
INNER JOIN kitaplar k ON o.kitap_id = k.id
WHERE o.gun > (SELECT AVG(gun) FROM odunc);

-- Ödünç durum bilgisi
SELECT 
    u.ad,
    k.kitap_adi,
    o.gun,
    CASE 
        WHEN o.gun > 30 THEN 'Gecikmiş'
        WHEN o.gun BETWEEN 15 AND 30 THEN 'Uyarı'
        ELSE 'Normal'
    END AS durum
FROM odunc o
INNER JOIN uyeler u ON o.uye_id = u.id
INNER JOIN kitaplar k ON o.kitap_id = k.id;

-- Yaşa göre gruplandırma
SELECT 
    ad,
    yas,
    CASE 
        WHEN yas <= 18 THEN 'Genç'
        ELSE 'Yetişkin'
    END AS yas_grubu
FROM uyeler;

-- Toplam kayit
SELECT 
    CASE 
        WHEN gun > 30 THEN 'Gecikmiş'
        WHEN gun BETWEEN 15 AND 30 THEN 'Uyarı'
        ELSE 'Normal'
    END AS durum,
    COUNT(*) AS kayit_sayisi
FROM odunc
GROUP BY durum;

-- Ad sutununa index 
CREATE INDEX idx_uyeler_ad ON uyeler(ad);

-- E posta sutunu ve unique index 
ALTER TABLE uyeler ADD COLUMN eposta TEXT;
CREATE UNIQUE INDEX idx_uyeler_eposta ON uyeler(eposta);

-- zaten var olan eposta unique kuralı
CREATE UNIQUE INDEX idx_uyeler_eposta ON uyeler(eposta);
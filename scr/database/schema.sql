CREATE DATABASE IF NOT EXISTS timphongtro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; USE timphongtro;

CREATE TABLE IF NOT EXISTS users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'landlord', 'admin') NOT NULL DEFAULT 'student',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS rooms (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    landlord_id INT UNSIGNED NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    price INT UNSIGNED NOT NULL,
    area DECIMAL(5,1) NOT NULL,
    address VARCHAR(255) NOT NULL,
    district VARCHAR(100) NOT NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    distance_to_school DECIMAL(5,2) NULL,
    max_people TINYINT UNSIGNED NOT NULL,
    status ENUM('pending', 'approved', 'rented', 'hidden') NOT NULL DEFAULT 'pending',
    views INT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_rooms_landlord_id (landlord_id),
    KEY idx_rooms_price (price),
    KEY idx_rooms_district (district),
    KEY idx_rooms_status (status),
    CONSTRAINT fk_rooms_landlord
        FOREIGN KEY (landlord_id) REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS room_images (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    room_id INT UNSIGNED NOT NULL,
    image_path VARCHAR(500) NOT NULL,
    is_primary TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_room_images_room_id (room_id),
    CONSTRAINT fk_room_images_room
        FOREIGN KEY (room_id) REFERENCES rooms (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS amenities (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(100) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_amenities_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS room_amenities (
    room_id INT UNSIGNED NOT NULL,
    amenity_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (room_id, amenity_id),
    KEY idx_room_amenities_amenity_id (amenity_id),
    CONSTRAINT fk_room_amenities_room
        FOREIGN KEY (room_id) REFERENCES rooms (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_room_amenities_amenity
        FOREIGN KEY (amenity_id) REFERENCES amenities (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS favorites (
    user_id INT UNSIGNED NOT NULL,
    room_id INT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, room_id),
    KEY idx_favorites_room_id (room_id),
    CONSTRAINT fk_favorites_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_favorites_room
        FOREIGN KEY (room_id) REFERENCES rooms (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS reviews (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    room_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    rating TINYINT UNSIGNED NOT NULL,
    comment TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_reviews_room_id (room_id),
    KEY idx_reviews_user_id (user_id),
    CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT fk_reviews_room
        FOREIGN KEY (room_id) REFERENCES rooms (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_reviews_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS search_history (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id INT UNSIGNED NULL,
    keyword VARCHAR(255) NULL,
    min_price INT UNSIGNED NULL,
    max_price INT UNSIGNED NULL,
    district VARCHAR(100) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_search_history_user_id (user_id),
    CONSTRAINT fk_search_history_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_preferences (
    user_id INT UNSIGNED NOT NULL,
    budget_min INT UNSIGNED NULL,
    budget_max INT UNSIGNED NULL,
    preferred_district VARCHAR(100) NULL,
    max_distance DECIMAL(5,2) NULL,
    amenity_ids VARCHAR(255) NULL,
    PRIMARY KEY (user_id),
    CONSTRAINT fk_user_preferences_user
        FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (id, full_name, email, phone, password_hash, role) VALUES
    (1, 'Quản trị viên', 'admin@timphongtro.vn', '0900000001', '$2y$12$DLL39F4v0tuVV8bXXC.B8e8p5w3qdB6gLCJ.cQQgcXm.e2ioYQQsa', 'admin'),
    (2, 'Chủ trọ Nguyễn Văn An', 'an.landlord@timphongtro.vn', '0900000002', '$2y$12$DLL39F4v0tuVV8bXXC.B8e8p5w3qdB6gLCJ.cQQgcXm.e2ioYQQsa', 'landlord'),
    (3, 'Chủ trọ Trần Thị Bình', 'binh.landlord@timphongtro.vn', '0900000003', '$2y$12$DLL39F4v0tuVV8bXXC.B8e8p5w3qdB6gLCJ.cQQgcXm.e2ioYQQsa', 'landlord'),
    (4, 'Sinh viên Lê Minh', 'minh.student@timphongtro.vn', '0900000004', '$2y$12$DLL39F4v0tuVV8bXXC.B8e8p5w3qdB6gLCJ.cQQgcXm.e2ioYQQsa', 'student'),
    (5, 'Sinh viên Phạm Hoa', 'hoa.student@timphongtro.vn', '0900000005', '$2y$12$DLL39F4v0tuVV8bXXC.B8e8p5w3qdB6gLCJ.cQQgcXm.e2ioYQQsa', 'student'),
    (6, 'Sinh viên Võ Tuấn', 'tuan.student@timphongtro.vn', '0900000006', '$2y$12$DLL39F4v0tuVV8bXXC.B8e8p5w3qdB6gLCJ.cQQgcXm.e2ioYQQsa', 'student')
ON DUPLICATE KEY UPDATE
    full_name = VALUES(full_name),
    phone = VALUES(phone),
    password_hash = VALUES(password_hash),
    role = VALUES(role);

INSERT INTO amenities (id, name, icon) VALUES
    (1, 'Wifi', 'wifi'),
    (2, 'Máy lạnh', 'snowflake'),
    (3, 'Gác lửng', 'stairs'),
    (4, 'Chỗ để xe', 'motorcycle'),
    (5, 'Nhà vệ sinh riêng', 'bath'),
    (6, 'Nước nóng', 'hot-tub'),
    (7, 'Tủ lạnh', 'refrigerator'),
    (8, 'Camera an ninh', 'camera'),
    (9, 'Giờ giấc tự do', 'clock'),
    (10, 'Cho nấu ăn', 'utensils')
ON DUPLICATE KEY UPDATE
    icon = VALUES(icon);

INSERT INTO rooms (
    id, landlord_id, title, description, price, area, address, district,
    latitude, longitude, distance_to_school, max_people, status, views
) VALUES
    (1, 2, 'Phòng trọ gần cổng Đại học Trà Vinh', 'Phòng sạch sẽ, thuận tiện đi học, khu vực an ninh.', 800000, 16.0, 'Đường Nguyễn Thiện Thành', 'TP. Trà Vinh', 9.9218000, 106.3427000, 0.30, 2, 'approved', 35),
    (2, 2, 'Phòng có gác, gần Đại học Trà Vinh', 'Phòng có gác lửng, thoáng mát, phù hợp sinh viên.', 1000000, 20.0, 'Đường D5', 'TP. Trà Vinh', 9.9230000, 106.3440000, 0.55, 2, 'approved', 42),
    (3, 2, 'Phòng trọ khép kín giá tốt', 'Nhà vệ sinh riêng, có chỗ để xe và giờ giấc tự do.', 1200000, 22.0, 'Đường Võ Văn Kiệt', 'TP. Trà Vinh', 9.9198000, 106.3408000, 0.65, 2, 'approved', 28),
    (4, 2, 'Phòng rộng cho hai sinh viên', 'Không gian rộng rãi, có thể ở ghép hai người.', 1500000, 28.0, 'Đường Sơn Thông', 'TP. Trà Vinh', 9.9242000, 106.3410000, 0.80, 3, 'approved', 51),
    (5, 2, 'Phòng máy lạnh gần trường', 'Phòng đầy đủ máy lạnh, wifi, khu dân cư yên tĩnh.', 1800000, 24.0, 'Đường Nguyễn Đáng', 'TP. Trà Vinh', 9.9185000, 106.3448000, 1.10, 2, 'approved', 67),
    (6, 2, 'Phòng có gác và bếp riêng', 'Có gác lửng và khu vực nấu ăn, phòng đón ánh sáng tự nhiên.', 2000000, 30.0, 'Đường Phạm Ngũ Lão', 'TP. Trà Vinh', 9.9250000, 106.3395000, 1.25, 3, 'approved', 39),
    (7, 3, 'Phòng trọ mới xây gần trường', 'Phòng mới, sạch, có camera an ninh và chỗ để xe.', 2200000, 26.0, 'Đường Nguyễn Thiện Thành', 'TP. Trà Vinh', 9.9205000, 106.3460000, 0.75, 2, 'approved', 58),
    (8, 3, 'Phòng có ban công thoáng mát', 'Phòng thoáng, có máy lạnh và nhà vệ sinh riêng.', 2500000, 32.0, 'Đường D5', 'TP. Trà Vinh', 9.9260000, 106.3430000, 1.15, 3, 'approved', 73),
    (9, 3, 'Phòng tiện nghi cho sinh viên', 'Trang bị tủ lạnh, nước nóng, wifi; khu vực an ninh.', 2700000, 34.0, 'Đường Võ Văn Kiệt', 'TP. Trà Vinh', 9.9172000, 106.3415000, 1.30, 3, 'approved', 46),
    (10, 3, 'Phòng rộng có chỗ để xe', 'Phòng rộng rãi, giờ giấc tự do và có chỗ để xe an toàn.', 3000000, 38.0, 'Đường Sơn Thông', 'TP. Trà Vinh', 9.9270000, 106.3465000, 1.60, 4, 'approved', 81),
    (11, 3, 'Phòng đơn giản gần khuôn viên', 'Phòng giá hợp lý, có wifi và cho nấu ăn.', 900000, 18.0, 'Đường Nguyễn Đáng', 'TP. Trà Vinh', 9.9225000, 106.3388000, 0.95, 2, 'approved', 24),
    (12, 3, 'Phòng trọ tiện nghi, an ninh', 'Có máy lạnh, camera, nước nóng và không gian sinh hoạt thoải mái.', 2800000, 36.0, 'Đường Phạm Ngũ Lão', 'TP. Trà Vinh', 9.9148000, 106.3455000, 1.90, 3, 'approved', 62)
ON DUPLICATE KEY UPDATE
    landlord_id = VALUES(landlord_id),
    title = VALUES(title),
    description = VALUES(description),
    price = VALUES(price),
    area = VALUES(area),
    address = VALUES(address),
    district = VALUES(district),
    latitude = VALUES(latitude),
    longitude = VALUES(longitude),
    distance_to_school = VALUES(distance_to_school),
    max_people = VALUES(max_people),
    status = VALUES(status),
    views = VALUES(views);

INSERT INTO room_amenities (room_id, amenity_id) VALUES
    (1, 1), (1, 4), (1, 5), (1, 9),
    (2, 1), (2, 3), (2, 4), (2, 10),
    (3, 1), (3, 4), (3, 5), (3, 9),
    (4, 1), (4, 3), (4, 4), (4, 10),
    (5, 1), (5, 2), (5, 5), (5, 6), (5, 9),
    (6, 1), (6, 3), (6, 4), (6, 10),
    (7, 1), (7, 4), (7, 5), (7, 8), (7, 9),
    (8, 1), (8, 2), (8, 5), (8, 6), (8, 10),
    (9, 1), (9, 4), (9, 5), (9, 6), (9, 7), (9, 8),
    (10, 1), (10, 2), (10, 4), (10, 8), (10, 9), (10, 10),
    (11, 1), (11, 4), (11, 9), (11, 10),
    (12, 1), (12, 2), (12, 5), (12, 6), (12, 8), (12, 9)
ON DUPLICATE KEY UPDATE
    amenity_id = VALUES(amenity_id);

INSERT INTO reviews (id, room_id, user_id, rating, comment) VALUES
    (1, 1, 4, 5, 'Phòng gần trường, chủ trọ thân thiện.'),
    (2, 2, 5, 4, 'Phòng có gác rộng, phù hợp với sinh viên.'),
    (3, 5, 6, 5, 'Phòng sạch sẽ, máy lạnh hoạt động tốt.'),
    (4, 7, 4, 4, 'Khu vực yên tĩnh, an ninh tốt.'),
    (5, 9, 5, 5, 'Tiện nghi đầy đủ và gần trường.')
ON DUPLICATE KEY UPDATE
    room_id = VALUES(room_id),
    user_id = VALUES(user_id),
    rating = VALUES(rating),
    comment = VALUES(comment);
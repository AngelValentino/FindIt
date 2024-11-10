SET FOREIGN_KEY_CHECKS = 0; -- Disable foreign key checks

-- Drop all tables if they exist
DROP TABLE IF EXISTS user_post_dislikes;
DROP TABLE IF EXISTS user_post_likes;
DROP TABLE IF EXISTS user_post_comments;
DROP TABLE IF EXISTS user_post_interest;
DROP TABLE IF EXISTS user_own_communities;
DROP TABLE IF EXISTS user_community_rating;
DROP TABLE IF EXISTS user_joined_communities;
DROP TABLE IF EXISTS user_friends;
DROP TABLE IF EXISTS post_tags;
DROP TABLE IF EXISTS post_categories;
DROP TABLE IF EXISTS post_images;
DROP TABLE IF EXISTS community_categories;
DROP TABLE IF EXISTS community_posts;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS category_subcategories;
DROP TABLE IF EXISTS subcategories;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS communities;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1; -- Re-enable foreign key checks

-- Create tables
CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    username VARCHAR(32),
    birthdate DATE NOT NULL,
    password_hash VARCHAR(128) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    profile_image_url VARCHAR(512),
    banner_image_url VARCHAR(512),
    bio VARCHAR(250),
    PRIMARY KEY(id)
);

CREATE TABLE communities (
    id INT UNSIGNED AUTO_INCREMENT,
    title VARCHAR(32) NOT NULL UNIQUE,
    bio VARCHAR(250),
    `description` VARCHAR(2000),
    is_verified BOOLEAN NOT NULL DEFAULT 0 CHECK(is_verified IN (0, 1)),
    business_phone VARCHAR(20),
    business_email VARCHAR(255) NOT NULL UNIQUE,
    office_address VARCHAR(255),
    events_location VARCHAR(255) NOT NULL,
    profile_image_url VARCHAR(512),
    banner_image_url VARCHAR(512),
    PRIMARY KEY(id)
    );

CREATE TABLE community_posts (
    id INT UNSIGNED AUTO_INCREMENT,
    community_id INT UNSIGNED,
    title VARCHAR(75),
    `description` VARCHAR(250),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(id),
    FOREIGN KEY(community_id) REFERENCES communities(id) ON DELETE CASCADE
);

CREATE TABLE categories (
    id INT UNSIGNED AUTO_INCREMENT,
    `type` VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY(id)
);

CREATE TABLE subcategories (
    id INT UNSIGNED AUTO_INCREMENT,
    `type` VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY(id)
);

CREATE TABLE category_subcategories (
    category_id INT UNSIGNED,
    subcategory_id INT UNSIGNED,
    PRIMARY KEY(category_id, subcategory_id),
    FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY(subcategory_id) REFERENCES subcategories(id) ON DELETE CASCADE
);

CREATE TABLE tags (
    id INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(25),
    PRIMARY KEY(id)
);

CREATE TABLE user_friends (
    user_id INT UNSIGNED,
    user_friend_id INT UNSIGNED,
    send_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    accepted_at TIMESTAMP,
    `status` ENUM('pending', 'accepted', 'rejected') NOT NULL,
    PRIMARY KEY(user_id, user_friend_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(user_friend_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE user_joined_communities (
    user_id INT UNSIGNED,
    community_id INT UNSIGNED,
    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, community_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(community_id) REFERENCES communities(id) ON DELETE CASCADE
);

CREATE TABLE user_community_rating (
    user_id INT UNSIGNED,
    community_id INT UNSIGNED,
    rating TINYINT UNSIGNED  NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(250),
    rated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_own_communities (
    user_id INT UNSIGNED,
    community_id INT UNSIGNED,
    owned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, community_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(community_id) REFERENCES communities(id) ON DELETE CASCADE
);

CREATE TABLE user_post_interest (
    user_id INT UNSIGNED,
    post_id INT UNSIGNED,
    interested_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, post_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(post_id) REFERENCES community_posts(id) ON DELETE CASCADE
);

CREATE TABLE user_post_comments (
    user_id INT UNSIGNED,
    post_id INT UNSIGNED,
    commented_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    comment VARCHAR(250),
    PRIMARY KEY(user_id, post_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(post_id) REFERENCES community_posts(id) ON DELETE CASCADE
);

CREATE TABLE user_post_likes (
    user_id INT UNSIGNED,
    post_id INT UNSIGNED,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(post_id) REFERENCES community_posts(id) ON DELETE CASCADE
);

CREATE TABLE user_post_dislikes (
    user_id INT UNSIGNED,
    post_id INT UNSIGNED,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(post_id) REFERENCES community_posts(id) ON DELETE CASCADE
);

CREATE TABLE community_categories (
    community_id INT UNSIGNED,
    category_id INT UNSIGNED,
    PRIMARY KEY(community_id, category_id),
    FOREIGN KEY(community_id) REFERENCES communities(id) ON DELETE CASCADE,
    FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE post_images (
    id INT UNSIGNED AUTO_INCREMENT,
    post_id INT UNSIGNED,
    image_url VARCHAR(512) NOT NULL UNIQUE,
    PRIMARY KEY(id),
    FOREIGN KEY(post_id) REFERENCES community_posts(id) ON DELETE CASCADE
);

CREATE TABLE post_categories (
    post_id INT UNSIGNED,
    category_id INT UNSIGNED,
    PRIMARY KEY(post_id, category_id),
    FOREIGN KEY(post_id) REFERENCES community_posts(id) ON DELETE CASCADE,
    FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE post_tags (
    post_id INT UNSIGNED,
    tag_id INT UNSIGNED,
    PRIMARY KEY(post_id, tag_id),
    FOREIGN KEY(post_id) REFERENCES community_posts(id) ON DELETE CASCADE,
    FOREIGN KEY(tag_id) REFERENCES tags(id) ON DELETE CASCADE
);


-- Test data
INSERT INTO users (first_name, last_name, username, birthdate, password_hash, email, profile_image_url, banner_image_url, bio) VALUES
    ('John', 'Doe', 'johndoe', '1990-05-12', 'hashedpassword1', 'johndoe@example.com', 'http://example.com/johndoe_profile.jpg', 'http://example.com/johndoe_banner.jpg', 'A passionate train enthusiast'),
    ('Jane', 'Smith', 'janesmith', '1988-07-24', 'hashedpassword2', 'janesmith@example.com', 'http://example.com/janesmith_profile.jpg', 'http://example.com/janesmith_banner.jpg', 'Classic car lover and restorer'),
    ('Alice', 'Johnson', 'alicejohnson', '1995-11-30', 'hashedpassword3', 'alicejohnson@example.com', 'http://example.com/alicejohnson_profile.jpg', 'http://example.com/alicejohnson_banner.jpg', 'Muscle car enthusiast and mechanic'),
    ('Bob', 'Williams', 'bobwilliams', '1982-04-15', 'hashedpassword4', 'bobwilliams@example.com', 'http://example.com/bobwilliams_profile.jpg', 'http://example.com/bobwilliams_banner.jpg', 'Custom motorcycle builder'),
    ('Charlie', 'Brown', 'charliebrown', '1992-03-03', 'hashedpassword5', 'charliebrown@example.com', 'http://example.com/charliebrown_profile.jpg', 'http://example.com/charliebrown_banner.jpg', 'Restoration expert for vintage motorcycles');
INSERT INTO communities (title, bio, `description`, is_verified, business_phone, business_email, office_address, events_location, profile_image_url, banner_image_url) VALUES
    ('All Aboard Trains', 'For train lovers and railway history buffs', "All Aboard Trains is the go-to community for train enthusiasts. Whether it's vintage locomotives, model trains, or rail travel, we celebrate all things trains with events, tours, and discussions.", 1, '+1222333444', 'contact@allaboardtrains.com', '123 Rail Lane, Chicago', '456 Rail Park, Chicago', 'http://example.com/allaboardtrains_profile.jpg', 'http://example.com/allaboardtrains_banner.jpg'),
    ('Timeless Rides', 'For fans of classic cars and vintage automotive beauty', 'Timeless Rides brings together car lovers who appreciate the craftsmanship of classic automobiles. Join us for car shows, restoration tips, and to connect with fellow vintage car enthusiasts.', 1, '+2333444555', 'contact@timelessrides.com', '456 Vintage Road, Los Angeles', '789 Car Show Arena, LA', 'http://example.com/timelessrides_profile.jpg', 'http://example.com/timelessrides_banner.jpg'),
    ('Muscle Machine Madness', 'For those who thrive on horsepower and power', 'Muscle Machine Madness is the ultimate community for lovers of powerful muscle cars. From high-speed chases to customizing your ride, we share the latest in performance and car culture.', 1, '+3444555666', 'contact@musclemachinemadness.com', '789 Speedway Blvd, Detroit', '101 Muscle Car Track, Detroit', 'http://example.com/musclemachinemadness_profile.jpg', 'http://example.com/musclemachinemadness_banner.jpg'),
    ('Cafe Racer Garage', 'For custom bike builders and cafe racer enthusiasts', 'Cafe Racer Garage is the home for custom bike builders and cafe racer fans. Share your builds, get tips on bike modifications, and connect with others who live the cafe racer lifestyle.', 1, '+4555666777', 'contact@caferacergarage.com', '321 Custom Bikes St, Austin', '654 Racer Meet, Austin', 'http://example.com/caferacergarage_profile.jpg', 'http://example.com/caferacergarage_banner.jpg'),
    ('Revive & Ride', 'For car restoration experts and enthusiasts', "Revive & Ride is the place for automotive restoration aficionados. Whether you're restoring a classic car or motorcycle, we offer tips, showcase your builds, and share restoration success stories.", 1, '+5666777888', 'contact@reviveride.com', '987 Restoration Ave, San Francisco', '234 Auto Restoration Expo, SF', 'http://example.com/reviveride_profile.jpg', 'http://example.com/reviveride_banner.jpg');
INSERT INTO community_posts (community_id, title, `description`) VALUES
    (1, 'The Golden Age of Trains', 'Exploring the history of trains during the 19th century. A fascinating period of development in railway technology and culture.'),
    (2, 'Top 10 Classic Cars of All Time', 'A list of the best and most iconic classic cars that have defined the automotive world over the last century.'),
    (3, 'The Muscle Car Revolution', 'An in-depth look at the history of muscle cars and their impact on automotive performance and culture.'),
    (4, 'Building Your First Cafe Racer', 'A step-by-step guide for beginners interested in building their own cafe racer bike.'),
    (5, 'Restoring a Vintage Motorcycle', 'Tips and tricks for restoring motorcycles from the 1950s and 1960s to their former glory.');
INSERT INTO categories (`type`) VALUES
    ('Trains'),
    ('Cars'),
    ('Motorcycles');
INSERT INTO subcategories (`type`) VALUES
    ('Vintage'),
    ('Modern'),
    ('Electric');
INSERT INTO category_subcategories (category_id, subcategory_id) VALUES
    (1, 1), (2, 2), (3, 1),
    (1, 2), (2, 1), (3, 3);
INSERT INTO tags (`name`) VALUES
    ('history'), ('restoration'), ('performance'), ('classic'), ('modern');
INSERT INTO user_friends (user_id, user_friend_id, `status`) VALUES
    (1, 2, 'accepted'),
    (3, 4, 'accepted'),
    (4, 3, 'accepted'),
    (5, 4, 'pending');
INSERT INTO user_joined_communities (user_id, community_id) VALUES
    (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);
INSERT INTO user_community_rating (user_id, community_id, rating, comment) VALUES
    (1, 1, 5, 'Great community for train lovers'),
    (2, 2, 4, 'Awesome for classic car enthusiasts'),
    (3, 3, 5, 'Love the discussions on muscle cars'),
    (4, 4, 3, 'Good but could have more content on builds'),
    (5, 5, 5, 'Fantastic for restoration tips');
INSERT INTO user_own_communities (user_id, community_id) VALUES
    (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);
INSERT INTO user_post_interest (user_id, post_id) VALUES
    (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (2, 1), (3, 1);
INSERT INTO user_post_comments (user_id, post_id, comment) VALUES
    (1, 1, 'This was a great post, I love learning about the history of trains'),
    (2, 2, 'Amazing list of classic cars!'),
    (3, 3, 'Muscle cars are my passion, loved reading this post'),
    (4, 4, "I'm starting my own cafe racer build, thanks for the tips"),
    (5, 5, 'Restoring a motorcycle is a challenging yet rewarding process');
INSERT INTO user_post_likes (user_id, post_id) VALUES
    (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);
INSERT INTO user_post_dislikes (user_id, post_id) VALUES
    (1, 2), (2, 3), (3, 4), (4, 5), (5, 1);
INSERT INTO community_categories (community_id, category_id) VALUES
    (1, 1), (2, 2), (3, 3);
INSERT INTO post_images (post_id, image_url) VALUES
    (1, 'http://example.com/golden_age_of_trains.jpg'),
    (2, 'http://example.com/classic_cars.jpg'),
    (3, 'http://example.com/muscle_car_revolution.jpg'),
    (4, 'http://example.com/cafe_racer_build.jpg'),
    (5, 'http://example.com/restoring_motorcycle.jpg');
INSERT INTO post_categories (post_id, category_id) VALUES
    (1, 1), (2, 2), (3, 3);
INSERT INTO post_tags (post_id, tag_id) VALUES
    (1, 1), (2, 2), (3, 3);
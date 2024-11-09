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
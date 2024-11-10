-- USER MANAGEMENT

-- Get user profile
SELECT id, first_name, last_name, username, bio, profile_image_url
FROM users
WHERE id = ?;

-- Get user friends
SELECT first_name, last_name, username
FROM users
WHERE id IN (
    SELECT user_friend_id
    FROM user_friends
    WHERE user_id = ?
);

-- Check frienship status
SELECT `status`
FROM user_friends
WHERE user_id = ? AND user_friend_id = ?;

-- Update user bio
UPDATE users
SET bio = ?
WHERE id = ?;

-- END OF USER MANAGEMENT

-- COMMUNITY MANAGEMENT

-- Get community details
SELECT title, `description`, bio, profile_image_url, banner_image_url, business_phone, business_email
FROM communities
WHERE id = ?;

-- Get communities the user has joined
SELECT title, bio
FROM communities
WHERE id IN (SELECT community_id FROM user_joined_communities WHERE user_id = ?);

-- Get the Communities owned by the user
SELECT communities.title, communities.bio, user_own_communities.owned_at
FROM communities
JOIN user_own_communities ON communities.id = user_own_communities.community_id
WHERE user_id = ?;

-- Get community posts
SELECT title, `description`, created_at, updated_at
FROM community_posts
WHERE community_id = ?;

-- END OF COMMUNITY MANAGEMENT

-- POST INTERACTIONS

-- Get post comments
SELECT
    users.first_name,
    users.last_name,
    user_post_comments.comment,
    user_post_comments.commented_at
FROM users
JOIN user_post_comments ON users.id = user_post_comments.user_id
WHERE post_id = ?;

-- Get post likes count
SELECT COUNT(*) AS like_count
FROM user_post_likes
WHERE post_id = ?;

-- Get post dislikes count
SELECT COUNT(*) AS dislike_count
FROM user_post_dislikes
WHERE post_id = ?;

-- Get users interested in post count
SELECT COUNT(*) AS post_interest
FROM users
JOIN user_post_interest ON users.id = user_post_interest.user_id
WHERE user_post_interest.post_id = ?;

-- Get users interested in post
SELECT
    users.first_name,
    users.last_name,
    users.bio,
    user_post_interest.interested_at
FROM users
JOIN user_post_interest ON users.id = user_post_interest.user_id
WHERE user_post_interest.post_id = ?;

-- Add a like to post
INSERT INTO user_post_likes (user_id, post_id)
VALUES (?, ?);

-- Add a dislike to a post
INSERT INTO user_post_dislikes (user_id, post_id)
VALUES (?, ?);

-- END OF POST INTERACTIONS

-- POST CREATION AND CONTENT MANAGEMENT

-- Create a new post
INSERT INTO community_posts (community_id, title, description)
VALUES (?, ?, ?);

-- Add images to post
INSERT INTO post_images (post_id, image_url)
VALUES (?, ?);

-- Add categories to a post
INSERT INTO post_categories (post_id, category_id)
VALUES (?, ?);

-- Add tags to a post
INSERT INTO post_tags (post_id, tag_id)
VALUES (?, ?);

-- END OF POST CREATION AND CONTENT MANAGEMENT

-- COMMUNITY RATING AND REVIEW

-- Get community rating by user
SELECT rating, comment, rated_at
FROM user_community_rating
WHERE user_id = ? AND community_id = ?;

-- Get average community rating
SELECT ROUND(AVG(rating), 2) AS average_rating
FROM user_community_rating
WHERE community_id = ?;

-- END OF COMMUNITY RATING AND REVIEW

-- SEARCH FUNCTIONALITY

-- Search posts by category
SELECT
    community_posts.title,
    community_posts.description,
    community_posts.created_at,
    post_images.image_url
FROM community_posts
JOIN post_images ON community_posts.id = post_images.post_id
JOIN post_categories ON community_posts.id = post_categories.post_id
JOIN categories ON categories.id = post_categories.category_id
WHERE categories.`type` IN (?);

-- Search posts by title
SELECT
    community_posts.title,
    community_posts.description,
    community_posts.created_at,
    post_images.image_url
FROM community_posts
JOIN post_images ON community_posts.id = post_images.post_id
JOIN post_categories ON community_posts.id = post_categories.post_id
WHERE community_posts.title LIKE ?;

-- Search user by first and last name
SELECT first_name, last_name, bio, profile_image_url
FROM users
WHERE first_name LIKE ? AND last_name LIKE ?;

-- END OF SEACH FUNCTIONALITY

-- CATEGORY AND SUBCATEGORY MANAGEMENT

-- Get all categories
SELECT `type` FROM categories;

-- Get all subcategories for a category
SELECT `type`
FROM subcategories
WHERE id IN (
    SELECT subcategory_id
    FROM category_subcategories
    WHERE category_id = ?
);

-- END OF CATEGORY AND SUBCATEGORY MANAGEMENT
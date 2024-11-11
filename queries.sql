-- USER MANAGEMENT

-- Get user profile
SELECT
    first_name,
    last_name,
    username,
    birthdate,
    bio,
    profile_image_url,
    banner_image_url
FROM users
WHERE id = ?;

-- Get user friends list
SELECT first_name, last_name, username, bio, profile_image_url
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
SELECT
    title,
    `description`,
    bio,
    is_verified,
    business_phone,
    business_email,
    office_address,
    events_location,
    profile_image_url,
    banner_image_url
FROM communities
WHERE id = ?;

-- Get communities the user has joined
SELECT title, bio, is_verified, events_location, profile_image_url, banner_image_url
FROM communities
WHERE id IN (SELECT community_id FROM user_joined_communities WHERE user_id = ?);

-- Get the Communities owned by the user
SELECT
    communities.title,
    communities.bio,
    communities.is_verified,
    communities.events_location,
    user_own_communities.owned_at
FROM communities
JOIN user_own_communities ON communities.id = user_own_communities.community_id
WHERE user_own_communities.user_id = ?;

-- Get community post
SELECT
    communities.title,
    communities.profile_image_url,
    community_posts.title,
    community_posts.short_description,
    community_posts.activity_location,
    community_posts.created_at,
    community_posts.updated_at,
    post_images.image_url
FROM communities
JOIN community_posts ON communities.id = community_posts.community_id
JOIN post_images ON community_posts.id = post_images.post_id
WHERE community_posts.community_id = ?;

-- END OF COMMUNITY MANAGEMENT

-- POST INTERACTIONS

-- Get post comments
SELECT
    users.first_name,
    users.last_name,
    users.profile_image_url,
    user_post_comments.comment,
    user_post_comments.commented_at
FROM users
JOIN user_post_comments ON users.id = user_post_comments.user_id
WHERE user_post_comments.post_id = ?;

-- Get post likes count
SELECT COUNT(*) AS like_count
FROM user_post_likes
WHERE post_id = ?;

-- Get post dislikes count
SELECT COUNT(*) AS dislike_count
FROM user_post_dislikes
WHERE post_id = ?;

-- Get users interested in post
SELECT COUNT(*) AS post_interest
FROM user_post_interest
WHERE user_post_interest.post_id = ?;

-- Get users interested in post
SELECT
    users.first_name,
    users.last_name,
    users.bio,
    users.profile_image_url,
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
INSERT INTO community_posts (community_id, title, short_description, activity_location)
VALUES (?, ?, ?, ?);

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
SELECT
    users.first_name,
    users.last_name,
    users.profile_image_url,
    user_community_rating.rating,
    user_community_rating.comment,
    user_community_rating.rated_at
FROM users
JOIN user_community_rating ON users.id = user_community_rating.user_id
WHERE user_community_rating.user_id = ? AND user_community_rating.community_id = ?;

-- Get average community rating
SELECT ROUND(AVG(rating), 2) AS average_rating
FROM user_community_rating
WHERE community_id = ?;

-- END OF COMMUNITY RATING AND REVIEW

-- SEARCH FUNCTIONALITY

-- Search posts by category
SELECT
    community_posts.title,
    community_posts.short_description,
    community_posts.activity_location,
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
    community_posts.short_description,
    community_posts.activity_location,
    community_posts.created_at,
    post_images.image_url
FROM community_posts
JOIN post_images ON community_posts.id = post_images.post_id
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
# Design Document of FindIt

By Angel Valentino

Video overview: <URL HERE>

## Scope

**Findit** is designed to be a social media application where the main objective is to encourage users to **meet others in real life**. It aims to create the opposite experience of current social media apps by not encouraging prolonged time spent on the site. The application provides only the necessary tools to help users find places to go, meet people and connect each other. It is designed to manage user profiles, community interactions and content creation within the platform.

- **Users**: Contains information about the users, including personal details like first name, last name, username, birthdate, email, profile and banner images, and biography.
- **Communities**: Represents groups or forums where users can join, create, and participate. Each community includes details like title, bio, description, business contact information, and event locations. Moreover, a community must be owned by at least one user.
- **Community Posts**: Content created within communities. Which can include titles, descriptions, locations, and the ability to interact with posts (e.g., likes, comments, and interests).
- **Friendships**: Tracks user relationships, including accepted friendships, pending requests, and rejected connections between users.
- **User Interactions with Posts**: Records user interactions on posts, such as liking, disliking, commenting, and expressing interest in specific community posts.
- **Community Ratings**: Users can rate communities and leave comments, providing feedback on their experience within the community.
- **User-Owned Communities**: Keeps track of which users own or manage communities, along with the creation timestamp.
- **Categories and Subcategories**: Categories and subcategories help organize posts and communities by type (e.g., cars, trains, motorcycles) and further classify them into specific subtypes (e.g., vintage, modern, electric).
- **Tags**: Tags are used to describe and categorize posts, helping users find related content.
- **User Activity Logs**: Includes triggers for logging changes in user profiles (such as inserts, updates, or deletes) for tracking and security reasons.

#### Out of Scope

The following elements are **out of scope** for the current social media database design: 

**External integrations** (such as linking with other social media platforms, payment systems, or external APIs), **monetization or advertising** (including payment processing and ad tracking), **notifications** (such as alerts for friend requests, new posts, or community updates), **privacy or legal compliance** (beyond basic user data management), and **file storage** (where only references to file locations are stored, but actual file management is not included).


## Functional Requirements

##### This database will support:

- Creating and managing user profiles, including friendships and joining communities.
- Interacting with community posts by liking, disliking, commenting, and showing interest.
- Managing communities by managing posts, categories, and tags (for community owners).
- Logging user actions (inserts, updates, and deletes) for tracking.

##### Note that this database iteration will not support:

- Direct management or viewing of the database: This is only a sample, not the final product with a fully structured and interlinked backend and frontend.
- Analytics or advanced security measures: Complex security, analytics, and user permissions will be added in future iterations to ensure the database is secure and only accessible by authorized staff.
- Fully developed application: This database represents the foundational structure of a larger application that will be developed in the future.


## Representation

Entities are represented as **MySQL** tables, structured according to the following schema. An **Entity-Relationship (ER) diagram** is also provided for a visual representation of the database structure.


### Entities

The database includes the following entities:

#### users

The `users` table includes:


- `id`: Specifies the unique ID for the user as an `INT UNSIGNED`. This column has the `PRIMARY KEY` constraint.
- `first_name`: Specifies the first name of the user as a `VARCHAR(50)`.This column has the `NOT NULL` constraint.
- `last_name`: Specifies the last name of the user as a `VARCHAR(50)`. This column has the `NOT NULL` constraint.
- `username`: Specifies the username of the user as a `VARCHAR(32)`. This column has the `UNIQUE` and `NOT NULL` constraints to ensure each username is distinct.
- `birthdate`: Specifies the birthdate of the user as a `DATE`. This column has the `NOT NULL` constraint.
- `password_hash`: Specifies the hashed password for the user as a `VARCHAR(128)`. This column has the `NOT NULL` constraint.
- `email`: Specifies the email address of the user as a `VARCHAR(255)`. This column has the `UNIQUE` and `NOT NULL` constraints  to ensure each user's email is distinct.
- `profile_image_url`: Specifies the URL for the user's profile image as a `VARCHAR(512)`. This image is expected to be stored in a CDN. This column is optional and can be `NULL`.
- `banner_image_url`: Specifies the URL for the user's banner image as a `VARCHAR(512)`. This image is expected to be stored in a CDN. This column is optional and can be `NULL`.
- `bio`: Specifies the bio or description of the user as a `VARCHAR(250)`. This column is optional and can be `NULL`.

#### communities

The `communities` table includes:

- `id`: Specifies the unique ID for the community as an `INT UNSIGNED`. This column has the `PRIMARY KEY` constraint.
- `title`: Specifies the title of the community as a `VARCHAR(32)`. This column has the `UNIQUE` and `NOT NULL` constraints to ensure each community's title is distinct.
- `bio`: Specifies a short description for the community as a `VARCHAR(250)`. This column is optional and can be `NULL`.
- `description`: Specifies a detailed description for the community as a `VARCHAR(2000)`. This column is optional and can be `NULL`.
- `is_verified`: Specifies whether the community is verified or not as a `BOOLEAN`. The `DEFAULT` value is 0 (false). Also, it has the `NOT NULL` constraint to ensure reliability.
- `business_phone`: Specifies the business phone number for the community as a `VARCHAR(20)`. This column is optional and can be `NULL`.
- `business_email`: Specifies the business email address for the community as a `VARCHAR(255)`. This column has the `UNIQUE` and `NOT NULL` constraints to ensure each email is distinct.
- `office_address`: Specifies the office address for the community as a `VARCHAR(255)`. This column is optional and can be `NULL`.
- `events_location`: Specifies the general location for events hosted by the community as a `VARCHAR(255)`. This column has the `NOT NULL` constraint.
- `profile_image_url`: Specifies the URL for the community's profile image as a `VARCHAR(512)`. This image is expected to be stored in a CDN. This column is optional and can be `NULL`.
- `banner_image_url`: Specifies the URL for the community's banner image as a `VARCHAR(512)`. This image is expected to be stored in a CDN. This column is optional and can be `NULL`.

#### community_posts

The `community_posts` table includes:

- `id`: Specifies the unique ID for the post as an `INT UNSIGNED`. This column has the `PRIMARY KEY` constraint.
- `community_id`: Specifies the ID of the community that the post belongs to as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `communities` table. Moreover, it has the `ON DELETE CASCADE` action to ensure no outdated records are kept.
- `title`: Specifies the title of the post as a `VARCHAR(75)`. This column has the `NOT NULL` constraint.
- `short_description`: Specifies a brief description of the post as a `VARCHAR(250)`. This column is optional and can be `NULL`.
- `activity_location`: Specifies the location of the activity associated with the post as a `VARCHAR(255)`. This column has the `NOT NULL` constraint.
- `created_at`: Specifies the timestamp when the post was created as a `TIMESTAMP`. The `DEFAULT` value is `CURRENT_TIMESTAMP`. Also, it has the `NOT NULL` constraint to ensure reliability.
- `updated_at`: Specifies the timestamp when the post was last updated as a `TIMESTAMP`. The value is automatically updated with each change as it uses the `ON UPDATE CURRENT_TIMESTAMP` action.

#### categories

The `categories` table includes:

- `id`: Specifies the unique ID for the category as an `INT UNSIGNED`. This column has the `PRIMARY KEY` constraint.
- `type`: Specifies the type or name of the category as a `VARCHAR(50)`. This column has the `UNIQUE` and `NOT NULL` constraints to ensure each category is distinct.

#### subcategories

The `subcategories` table includes:

- `id`: Specifies the unique ID for the subcategory as an `INT UNSIGNED`. This column has the `PRIMARY KEY` constraint.
- `type`: Specifies the type or name of the subcategory as a `VARCHAR(100)`. This column has the `UNIQUE` and `NOT NULL` constraints to ensure each subcategory is distinct.

#### category_subcategories

The `category_subcategories` table includes:

- `category_id`: Specifies the ID of the category as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `categories` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `subcategory_id`: Specifies the ID of the subcategory as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `subcategories` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
The combination of `category_id` and `subcategory_id` forms the `PRIMARY KEY(category_id, subcategory_id)` to ensure each category is linked to a subcategory only once, preventing duplicate records.

#### tags

The `tags` table includes:

- `id`: Specifies the unique ID for the tag as an `INT UNSIGNED`. This column has the `PRIMARY KEY` constraint.
- `name`: Specifies the name of the tag as a `VARCHAR(25)`. This column has the `UNIQUE` and `NOT NULL` constraints to ensure each tag is distinct and to avoid creating duplicate tags if two users type the same one. Instead, we can simply query the existing tag.

#### user_friends

The `user_friends` table includes:

- `user_id`: Specifies the ID of the user as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `users` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `user_friend_id`: Specifies the ID of the user's friend as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `users` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `send_at`: Specifies the timestamp when the friend request was sent as a `TIMESTAMP`. The `DEFAULT` value is `CURRENT_TIMESTAMP`. Also, it has the `NOT NULL` constraint to ensure reliability.
- `accepted_at`: Specifies the timestamp when the friend request was accepted as a `TIMESTAMP`. This column can be `NULL`.
- `status`: Specifies the status of the friend request as an `ENUM('pending', 'accepted', 'rejected')`. This column has the `NOT NULL` constraint.

The combination of `user_id` and `user_friend_id` forms the `PRIMARY KEY(user_id, user_friend_id)` to ensure each user is linked to another user only once, preventing duplicate friendships and allowing two-way connections.

#### user_joined_communities

The `user_joined_communities` table includes:

- `user_id`: Specifies the ID of the user that joined the specified community as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `users` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `community_id`: Specifies the ID of the community that the user has joined as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `communities` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `joined_at`: Specifies the timestamp when the user joined the community as a `TIMESTAMP`. The `DEFAULT` value is `CURRENT_TIMESTAMP`. Also, it has the `NOT NULL` constraint to ensure reliability.

The combination of `user_id` and `community_id` forms the `PRIMARY KEY(user_id, community_id)` to ensure each user is linked to another community only once, preventing duplicate connections.

#### user_community_rating

The `user_community_rating` table includes:

- `user_id`: Specifies the ID of the user that has rated the specified community as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `users` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `community_id`: Specifies the ID of the community that the user has rated as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `communities` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `rating`: Specifies the rating the user gave the community as a `TINYINT UNSIGNED`. The value must be between 1 and 5, enforced by the `CHECK` constraint. Also it has the `NOT NULL` constraint.
- `comment`: Specifies the comment the user left alongside the rating as a `VARCHAR(250)`. This column is optional and can be `NULL`.
- `rated_at`: Specifies the timestamp when the rating was made as a `TIMESTAMP`. The `DEFAULT` value is `CURRENT_TIMESTAMP`. Also, it has the `NOT NULL` constraint to ensure reliability.

The combination of `user_id` and `community_id` forms the `PRIMARY KEY(user_id, community_id)` to ensure each user can rate a community only once, preventing duplicate reviews and biased data.

#### user_own_communities

The `user_own_communities` table includes:

- `user_id`: Specifies the ID of the user that owns the specified community as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `users` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `community_id`: Specifies the ID of the community that the user owns as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `communities` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `owned_at`: Specifies the timestamp when the user started owning the community as a `TIMESTAMP`. The `DEFAULT` value is `CURRENT_TIMESTAMP`. Also, it has the `NOT NULL` constraint to ensure reliability.

The combination of `user_id` and `community_id` forms the `PRIMARY KEY(user_id, community_id)` to ensure each user can own a community only once, preventing duplicate ownership records.

#### user_post_interest

The `user_post_interest` table includes:

- `user_id`: Specifies the ID of the user that was interested in the specified post as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `users` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `post_id`: Specifies the ID of the post that the user was interested in as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `community_posts` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `interested_at`: Specifies the timestamp when the user expressed interest in the post as a `TIMESTAMP`. The `DEFAULT` value is `CURRENT_TIMESTAMP`. Also, it has the `NOT NULL` constraint to ensure reliability.

The combination of `user_id` and `post_id` forms the `PRIMARY KEY(user_id, post_id)` to ensure each user can be interested in a post only once, preventing duplicate records.

#### user_post_comments

The `user_post_comments` table includes:

- `id`: Specifies the unique ID for the comment as an `INT UNSIGNED`. This column has the `PRIMARY KEY` constraint.
- `user_id`: Specifies the ID of the user who commented as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `users` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `post_id`: Specifies the ID of the post that the comment was meant to be in as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `community_posts` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `comment`: Specifies the content of the comment as a `VARCHAR(250)`. This column has the `NOT NULL` constraint.
- `commented_at`: Specifies the timestamp when the comment was made as a `TIMESTAMP`. The `DEFAULT` value is `CURRENT_TIMESTAMP`. Also, it has the `NOT NULL` constraint to ensure reliability.

#### user_post_likes

The `user_post_likes` table includes:

- `user_id`: Specifies the ID of the user who liked the post as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `users` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `post_id`: Specifies the ID of the post the user liked as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `community_posts` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.

The combination of `user_id` and `post_id` forms the `PRIMARY KEY(user_id, post_id)` to ensure each user can like a post only once, preventing duplicate records.


#### user_post_dislikes

The `user_post_dislikes` table includes:

- `user_id`: Specifies the ID of the user who disliked the post as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `users` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `post_id`: Specifies the ID of the post the user disliked as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `community_posts` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.

The combination of `user_id` and `post_id` forms the `PRIMARY KEY(user_id, post_id)` to ensure each user can dislike a post only once, preventing duplicate records

#### community_categories

The `community_categories` table includes:

- `community_id`: Specifies the ID of the community that the category belongs to as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `communities` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `category_id`: Specifies the ID of the category that belongs to the specified community as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `categories` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.

The combination of `community_id` and `category_id` forms the `PRIMARY KEY(community_id, category_id)` to ensure each community can be linked to a category only once, preventing duplicate category records.

#### post_images

The `post_images` table includes:

- `id`: Specifies the unique ID for the specified post image as an `INT UNSIGNED`. This column has the `PRIMARY KEY` constraint.
- `post_id`: Specifies the ID of the post that the image belongs to as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `community_posts` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `image_url`: Specifies the URL of the image as a `VARCHAR(512)`. This image is expected to be stored in a CDN. This column has the `UNIQUE` and `NOT NULL` constraints to ensure each image's URL is distinct.

#### post_categories

The `post_categories` table includes:

- `post_id`: Specifies the ID of the post that the category belongs to as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `community_posts` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `category_id`: Specifies the ID of the category that belongs to the specified post as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `categories` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.

The combination of `post_id` and `category_id` forms the `PRIMARY KEY(post_id, category_id)` to ensure each post can be linked to a category only once, preventing duplicate category records.

#### post_tags

The `post_tags` table includes:

- `post_id`: Specifies the ID of the post that the tag belongs to as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `community_posts` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.
- `tag_id`: Specifies the ID of the tag that belongs to the specified post as an `INT UNSIGNED`. This column is a foreign key that references the `id` in the `tags` table. Additionally, it has the `ON DELETE CASCADE` action to ensure that outdated records are automatically removed.

The combination of `post_id` and `tag_id` forms the `PRIMARY KEY(post_id, tag_id)` to ensure each post can be linked to a tag only once, preventing duplicate tag records.

#### **user_logs**

The `user_logs` table includes:

- `id`: Specifies the unique ID for the log entry as an `INT UNSIGNED`. This column has the `PRIMARY KEY` constraint.
- `type`: Specifies the log action type as an `ENUM('insert', 'update', 'delete')`. This column has the `NOT NULL` constraint.
- `old_username`: Specifies the old username before the update (if applicable) as a `VARCHAR(32)`. This column is optional and can be `NULL`.
- `new_username`: Specifies the new username after the update (if applicable) as a `VARCHAR(32)`. This column is optional and can be `NULL`.
- `old_password`: Specifies the old password hash before the update (if applicable) as a `VARCHAR(128)`. This column is optional and can be `NULL`.
- `new_password`: Specifies the new password hash after the update (if applicable) as a `VARCHAR(128)`. This column is optional and can be `NULL`.
- `action_date`: Specifies the timestamp of the log entry as a `TIMESTAMP`. The `DEFAULT` value is `CURRENT_TIMESTAMP`. Also, it has the `NOT NULL` constraint to ensure reliability.

This table is created through the `log_user_inserts`, `log_user_updates`, and `log_user_deletes` triggers to log changes made to sensitive user information for security purposes.


### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![Entity Relationship Diagram for FindIt, illustrating the relationships between various entities in the database schema.](https://i.imgur.com/PyoE22V.jpeg)

It’s important to keep in mind that only communities can upload and manage posts. Additionally, for a community to exist, it must have at least one owner. However, a user may not own any communities.

## Optimizations

I strongly believe that further and extended optimization should not be implemented before we have a clear understanding of how users interact with the application, particularly with the database. While MySQL and other DBMS provide tools to analyze query performance, I believe the best approach is to wait for real data before optimizing the database. Implementing indexes prematurely can be risky, as it is uncertain whether they will be utilized as expected. Since adding indexes can slow down insertions, deletions, and updates, we must be cautious and avoid implementing them until we have actual user analytics and behavior data.

## Limitations

The current iteration is a prototype of a larger project. While it effectively manages users, posts and communities interactions, it does not yet include features such as a notification system or direct messaging for users.

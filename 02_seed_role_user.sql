-- =====================================================================
-- seed_roles_users.sql  — FCSHD Room Booking System (KMK3393)
-- Seeds: Role, User
-- Run order: schema.sql -> seed_roles_users.sql -> seed_rooms.sql -> seed_bookings.sql
--
-- Demo logins (TEST DATA ONLY — every account shares its role's password):
--   Admin accounts : password  Admin@1234
--   Staff accounts : password  Staff@1234
-- Hashes below were made with password_hash(..., PASSWORD_BCRYPT), so
-- password_verify() in login.php works against them as-is.
--
-- Names, emails (.test domain) and phone numbers are fictional.
-- =====================================================================

-- Start clean so the file can be re-run. Children first, because of RESTRICT.
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM `user`;
ALTER TABLE `user` AUTO_INCREMENT = 1;

-- Do the same if you are clearing `role` or other parent tables:
DELETE FROM `role`;
ALTER TABLE `role` AUTO_INCREMENT = 1;

-- Your INSERT INTO statements go here...

SET FOREIGN_KEY_CHECKS = 1;
-- ---------------------------------------------------------------------
-- Role  (Decided, row 4: Staff and Admin; Head Staff is stretch)
-- Fixed IDs so other seed files and the code can rely on them.
-- ---------------------------------------------------------------------
INSERT INTO `role` (Role_ID, Role_Name, Role_Description) VALUES
  (1, 'Admin', 'Faculty administrator: manages staff accounts and rooms, approves or rejects booking requests'),
  (2, 'Staff', 'Faculty staff member: searches free rooms, submits and manages own booking requests');
-- Stretch (decided, row 5): uncomment when Head Staff is built.
-- INSERT INTO `Role` (Role_ID, Role_Name, Role_Description) VALUES
--   (3, 'Head Staff', 'Staff member who may also book outside working hours (8am-5pm)');

-- ---------------------------------------------------------------------
-- User
-- User_ID 1-2  : Admins
-- User_ID 3-8  : Active staff (use these to test booking, queues, clashes)
-- User_ID 9    : Inactive staff (login must be refused)
-- ---------------------------------------------------------------------
INSERT INTO `user`
  (User_ID, User_Role_ID, User_Email, User_Full_Name, User_Password,
   User_Number_Phone, User_Account_Status, User_Created_At)
VALUES
  -- Admins (password: Admin@1234)
  (1, 1, 'admin.nurul@fcshd.test',   'Nurul Aisyah binti Rahman',  '$2y$10$CxSh/bWYMhrkb4pHrLW81eKo.FZAFvuZq1yRhwhzoPedFYjCtly7u', '012-3456781', 'Active',   '2026-11-01 09:00:00'),
  (2, 1, 'admin.daniel@fcshd.test',  'Daniel Lee Wei Ming',        '$2y$10$CxSh/bWYMhrkb4pHrLW81eKo.FZAFvuZq1yRhwhzoPedFYjCtly7u', '013-4567812', 'Active',   '2026-11-01 09:05:00'),

  -- Staff (password: Staff@1234)
  (3, 2, 'hafiz.osman@fcshd.test',   'Dr. Hafiz bin Osman',        '$2y$10$6vzYzX8lEOo1CagXOG.uyOWXyYwLWutJhM43.9J4v4ECw0xodZXLa', '014-5678123', 'Active',   '2026-11-02 10:00:00'),
  (4, 2, 'chong.meiling@fcshd.test', 'Dr. Chong Mei Ling',         '$2y$10$6vzYzX8lEOo1CagXOG.uyOWXyYwLWutJhM43.9J4v4ECw0xodZXLa', '016-6781234', 'Active',   '2026-11-02 10:10:00'),
  (5, 2, 'jenny.unting@fcshd.test',  'Jenny anak Unting',          '$2y$10$6vzYzX8lEOo1CagXOG.uyOWXyYwLWutJhM43.9J4v4ECw0xodZXLa', '017-7812345', 'Active',   '2026-11-02 10:20:00'),
  (6, 2, 'rajesh.kumar@fcshd.test',  'Dr. Rajesh a/l Kumar',       '$2y$10$6vzYzX8lEOo1CagXOG.uyOWXyYwLWutJhM43.9J4v4ECw0xodZXLa', '018-8123456', 'Active',   '2026-11-02 10:30:00'),
  (7, 2, 'siti.hajar@fcshd.test',    'Siti Hajar binti Ismail',    '$2y$10$6vzYzX8lEOo1CagXOG.uyOWXyYwLWutJhM43.9J4v4ECw0xodZXLa', '019-1234567', 'Active',   '2026-11-03 08:45:00'),
  (8, 2, 'alvin.tan@fcshd.test',     'Alvin Tan Kok Wei',          '$2y$10$6vzYzX8lEOo1CagXOG.uyOWXyYwLWutJhM43.9J4v4ECw0xodZXLa', '011-23456789','Active',   '2026-11-03 09:00:00'),
  (9, 2, 'former.staff@fcshd.test',  'Mohd Faris bin Zulkifli',    '$2y$10$6vzYzX8lEOo1CagXOG.uyOWXyYwLWutJhM43.9J4v4ECw0xodZXLa', '012-9876543', 'Inactive', '2026-10-15 14:00:00');

-- Keep AUTO_INCREMENT ahead of the fixed IDs, so the first account created
-- from the Accounts page doesn't collide.
ALTER TABLE `user` AUTO_INCREMENT = 10;
ALTER TABLE `role` AUTO_INCREMENT = 3;
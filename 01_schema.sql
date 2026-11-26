-- =====================================================================
-- 01_schema.sql — FCSHD Room Booking System (KMK3393)
-- Creates the 5 MVP tables. Run this first, then the seed files in
-- number order (02_seed_roles_users.sql, 03_seed_rooms.sql, ...).
--
-- Do NOT add CREATE DATABASE / USE lines: select the database in
-- phpMyAdmin first (InfinityFree gives it a prefixed name like if0_...).
--
-- "Row N" in the comments = the Locked decisions table in the team guide.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Drop old tables, CHILDREN FIRST, so this file can be re-run.
--    Checks are switched off only while dropping.
-- ---------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Booking_Approval;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS `User`;
DROP TABLE IF EXISTS Role;
SET FOREIGN_KEY_CHECKS = 1;


-- ---------------------------------------------------------------------
-- 2. Create tables, PARENTS FIRST: Role -> User -> Room -> Booking
--    -> Booking_Approval. A table can only point at one that exists.
--    Every table is InnoDB (MyISAM silently ignores foreign keys).
-- ---------------------------------------------------------------------

-- Role: Staff and Admin (row 4). Roles are only ever added (row 7).
CREATE TABLE Role (
  Role_ID          INT AUTO_INCREMENT PRIMARY KEY,
  Role_Name        VARCHAR(50)  NOT NULL UNIQUE,
  Role_Description VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- User: staff and admins. Never deleted; deactivated instead (row 7).
-- Backticks around User because USER is a MySQL keyword.
CREATE TABLE `User` (
  User_ID             INT AUTO_INCREMENT PRIMARY KEY,
  User_Role_ID        INT          NOT NULL,           -- same type as Role.Role_ID
  User_Email          VARCHAR(100) NOT NULL UNIQUE,    -- login name, no duplicates
  User_Full_Name      VARCHAR(100) NOT NULL,
  User_Password       VARCHAR(255) NOT NULL,           -- password_hash() output, never plain text
  User_Number_Phone   VARCHAR(20)  NULL,               -- VARCHAR keeps the leading 0
  User_Account_Status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
  User_Created_At     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_user_role FOREIGN KEY (User_Role_ID)
    REFERENCES Role(Role_ID) ON DELETE RESTRICT        -- can't delete a role that has users
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Room: faculty rooms / venues. Deactivated, never deleted (row 7).
CREATE TABLE Room (
  Room_ID        INT AUTO_INCREMENT PRIMARY KEY,
  Room_Code      VARCHAR(20)  NOT NULL UNIQUE,         -- e.g. the code on the door
  Room_Name      VARCHAR(100) NOT NULL UNIQUE,
  Room_Type      VARCHAR(50)  NOT NULL,                -- free text until the team fixes a type list
  Room_Capacity  INT          NOT NULL,
  Room_Location  VARCHAR(100) NOT NULL,
  Room_Is_Active BOOLEAN      NOT NULL DEFAULT 1,      -- 1 = bookable, 0 = deactivated
  CONSTRAINT chk_room_capacity CHECK (Room_Capacity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Booking: one request for one room, date and time.
-- Only 'Approved' bookings block a slot (row 10); Pending ones queue by
-- Booking_Queued_At (rows 12, 20). Cancelling = status change, not DELETE.
CREATE TABLE Booking (
  Booking_ID               INT AUTO_INCREMENT PRIMARY KEY,
  Booking_Room_ID          INT          NOT NULL,
  Booking_Requester_ID     INT          NOT NULL,
  Booking_Title            VARCHAR(255) NOT NULL,      -- the reason / event name
  Booking_Date             DATE         NOT NULL,
  Booking_Start_Time       TIME         NOT NULL,
  Booking_End_Time         TIME         NOT NULL,
  Booking_Attendee_Count   INT          NOT NULL,
  Booking_Special_Requests TEXT         NULL,          -- optional (row 8)
  Booking_Status           ENUM('Pending','Approved','Rejected','Cancelled')
                           NOT NULL DEFAULT 'Pending', -- rows 2, 15, 16
  Booking_Created_At       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- never changes: request log
  Booking_Updated_At       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP,                     -- changes on every edit
  Booking_Queued_At        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- reset by PHP when date/time/room change (row 21)
  CONSTRAINT fk_booking_room FOREIGN KEY (Booking_Room_ID)
    REFERENCES Room(Room_ID) ON DELETE RESTRICT,                 -- keep booking history
  CONSTRAINT fk_booking_requester FOREIGN KEY (Booking_Requester_ID)
    REFERENCES `User`(User_ID) ON DELETE RESTRICT,               -- keep booking history
  CONSTRAINT chk_booking_times     CHECK (Booking_Start_Time < Booking_End_Time),
  CONSTRAINT chk_booking_attendees CHECK (Booking_Attendee_Count > 0),
  -- Speeds up the clash check and free-rooms search, which always filter
  -- by room + date + status. (AI suggestion; also serves as the FK index.)
  INDEX idx_booking_clash (Booking_Room_ID, Booking_Date, Booking_Status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Booking_Approval: the admin's decision record, at most ONE per booking
-- (row 1 -> UNIQUE). Status and decision are written together in one
-- transaction by the approve/reject handler (row 3).
CREATE TABLE Booking_Approval (
  Booking_Approval_ID          INT AUTO_INCREMENT PRIMARY KEY,
  Booking_Approval_Booking_ID  INT          NOT NULL UNIQUE,  -- one decision per booking
  Booking_Approval_Admin_ID    INT          NOT NULL,         -- PHP checks this user is an Admin
  Booking_Approval_Decision    ENUM('Approved','Rejected') NOT NULL,
  Booking_Approval_Remarks     VARCHAR(255) NULL,
  Booking_Approval_Reviewed_At DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_approval_booking FOREIGN KEY (Booking_Approval_Booking_ID)
    REFERENCES Booking(Booking_ID) ON DELETE CASCADE,          -- no booking = no decision
  CONSTRAINT fk_approval_admin FOREIGN KEY (Booking_Approval_Admin_ID)
    REFERENCES `User`(User_ID) ON DELETE RESTRICT              -- keep who decided
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Stretch A (rows 6 and f6): facilities, drafted now, unused by the MVP
CREATE TABLE Facility (
  Facility_ID          INT AUTO_INCREMENT PRIMARY KEY,
  Facility_Name        VARCHAR(100) NOT NULL UNIQUE,   -- e.g. 'Projector'
  Facility_Type        VARCHAR(100) NOT NULL,          -- e.g. 'AV equipment'
  Facility_Description VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Junction table: which facilities each room has (many-to-many)
CREATE TABLE Room_Facility (
  Room_ID                INT          NOT NULL,
  Facility_ID            INT          NOT NULL,
  Room_Facility_Quantity INT          NOT NULL DEFAULT 1,
  Room_Facility_Notes    VARCHAR(255) NULL,
  PRIMARY KEY (Room_ID, Facility_ID),                  -- the PAIR is unique
  CONSTRAINT fk_rf_room FOREIGN KEY (Room_ID)
    REFERENCES Room(Room_ID) ON DELETE CASCADE,
  CONSTRAINT fk_rf_facility FOREIGN KEY (Facility_ID)
    REFERENCES Facility(Facility_ID) ON DELETE RESTRICT,
  CONSTRAINT chk_rf_quantity CHECK (Room_Facility_Quantity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Notes
-- * CHECK constraints are enforced by MariaDB 10.2+ (XAMPP) and
--   MySQL 8.0.16+. Older MySQL accepts them but ignores them, so PHP
--   must validate the same rules anyway (it has to for friendly errors).
-- * Working hours (8am-5pm, row 14) are checked in PHP, not here,
--   because Head Staff are exempt (row 5).
-- * Stretch tables (Facility, Room_Facility, Venue_Feedback) are added
--   in a later file only if those features are built.
-- =====================================================================
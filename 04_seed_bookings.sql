-- =====================================================================
-- 04_seed_bookings.sql — FCSHD Room Booking System (KMK3393)
-- Seeds: Booking (17), Booking_Approval (11)
-- Needs 02 (users) and 03 (rooms) loaded first.
--
-- Booking_Room_ID / Booking_Requester_ID hold the INTERNAL IDs:
--   rooms  : 1 = TR1, 2 = TR2, 5 = TR5, 11 = CL1, 16 = MT, 17 = SR, 18 = MKB,
--            19 = MIMM, 20 = MRM, 21 = LBY, 24 = DK, 25 = BSW1, 27 = BMU, 28 = BME1
--   users  : 3 = Hafiz (2001), 4 = Chong (2002), 5 = Jenny (2003),
--            6 = Rajesh (2004), 7 = Siti (2005), 8 = Alvin (2006),
--            10 = Grace (2008), 11 = Farhana (2009); admins 1 = Nurul, 2 = Daniel
--
-- Test cases built in (use them when testing Parts 3, 4 and 5):
--   #1        Rejected, with a remark
--   #3 + #4   two Pending requests competing for the SAME slot (SR, 10 Dec)
--             -> #3 was queued first, so it is first in line
--   #5 + #6   #6 is Pending but WAITLISTED behind Approved #5 (DK, 12 Dec)
--   #7 + #8   back-to-back Approved bookings (CL1, 10:00) -> NOT a clash
--   #9        a past booking (20 Nov)
--   #10       Cancelled while still Pending -> no approval row
--   #11       Approved, then Cancelled -> keeps its approval row, slot is free
--   #12       edited Pending request: Queued_At reset to the edit time
--   #15       a plain Pending request
-- All times are within 8am-5pm and attendees <= room capacity.
-- =====================================================================
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM `Booking`;
ALTER TABLE `Booking` AUTO_INCREMENT = 1;

-- Your INSERT INTO statements go here...
DELETE FROM `Booking_Approval`;
ALTER TABLE `Booking_Approval` AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO Booking
  (Booking_ID, Booking_Room_ID, Booking_Requester_ID, Booking_Title,
   Booking_Date, Booking_Start_Time, Booking_End_Time, Booking_Attendee_Count,
   Booking_Special_Requests, Booking_Status,
   Booking_Created_At, Booking_Updated_At, Booking_Queued_At)
VALUES
  ( 1,  1,  3, 'Debate club sparring session #3',     '2026-12-03', '13:00:00', '17:00:00',  20, NULL,
    'Rejected',  '2026-11-25 20:15:00', '2026-11-25 20:23:00', '2026-11-25 20:15:00'),
  ( 2, 16,  4, 'KMK3393 final project presentations', '2026-12-09', '09:00:00', '12:00:00', 120, 'Need two wireless microphones',
    'Approved',  '2026-11-20 10:05:00', '2026-11-21 09:30:00', '2026-11-20 10:05:00'),
  ( 3, 17,  5, 'Postgraduate research colloquium',    '2026-12-10', '14:00:00', '16:00:00',  60, NULL,
    'Pending',   '2026-11-22 11:00:00', '2026-11-22 11:00:00', '2026-11-22 11:00:00'),
  ( 4, 17,  6, 'Industry talk: UX careers',           '2026-12-10', '14:00:00', '16:00:00',  70, 'Projector and mic',
    'Pending',   '2026-11-23 15:40:00', '2026-11-23 15:40:00', '2026-11-23 15:40:00'),
  ( 5, 24,  3, 'FSKPM convocation briefing',          '2026-12-12', '09:00:00', '13:00:00', 180, 'Stage and PA system',
    'Approved',  '2026-11-18 09:00:00', '2026-11-19 10:00:00', '2026-11-18 09:00:00'),
  ( 6, 24,  7, 'Student club orientation',            '2026-12-12', '10:00:00', '12:00:00', 150, NULL,
    'Pending',   '2026-11-24 14:20:00', '2026-11-24 14:20:00', '2026-11-24 14:20:00'),
  ( 7, 11,  8, 'Python workshop (part 1)',            '2026-12-04', '08:00:00', '10:00:00',  35, NULL,
    'Approved',  '2026-11-21 16:30:00', '2026-11-22 11:15:00', '2026-11-21 16:30:00'),
  ( 8, 11,  4, 'SPSS lab session',                    '2026-12-04', '10:00:00', '12:00:00',  30, 'SPSS licence on all PCs',
    'Approved',  '2026-11-21 16:45:00', '2026-11-22 11:20:00', '2026-11-21 16:45:00'),
  ( 9,  5,  3, 'Tutorial replacement class',          '2026-11-20', '10:00:00', '12:00:00',  30, NULL,
    'Approved',  '2026-11-10 08:30:00', '2026-11-11 09:00:00', '2026-11-10 08:30:00'),
  (10, 18,  6, 'AI reading group',                    '2026-12-05', '15:00:00', '17:00:00',  12, NULL,
    'Cancelled', '2026-11-19 13:10:00', '2026-11-21 08:30:00', '2026-11-19 13:10:00'),
  (11, 27,  5, 'Department meeting',                  '2026-12-08', '09:00:00', '11:00:00',  20, 'Coffee break setup',
    'Cancelled', '2026-11-19 10:00:00', '2026-11-24 17:05:00', '2026-11-19 10:00:00'),
  (12, 19,  7, 'HCI usability testing session',       '2026-12-11', '13:00:00', '16:00:00',  15, 'Eye trackers set up before 1pm',
    'Pending',   '2026-11-21 10:00:00', '2026-11-24 16:00:00', '2026-11-24 16:00:00'),
  (13, 28,  8, 'Robotics club AGM',                   '2026-12-02', '15:00:00', '17:00:00',  18, NULL,
    'Rejected',  '2026-11-22 09:00:00', '2026-11-23 10:10:00', '2026-11-22 09:00:00'),
  (14, 20, 9, 'VR demo for school visit',            '2026-12-07', '10:00:00', '12:00:00',  20, 'Charge all 10 headsets',
    'Approved',  '2026-11-23 08:50:00', '2026-11-24 09:45:00', '2026-11-23 08:50:00'),
  (15,  2, 8, 'Group consultation hour',             '2026-12-14', '14:00:00', '15:00:00',  10, NULL,
    'Pending',   '2026-11-25 10:30:00', '2026-11-25 10:30:00', '2026-11-25 10:30:00'),
  (16, 25, 7, 'Thesis defence rehearsal',            '2026-12-16', '09:00:00', '10:30:00',   8, NULL,
    'Approved',  '2026-11-24 15:00:00', '2026-11-25 11:00:00', '2026-11-24 15:00:00'),
  (17, 21,  6, 'Charity bake sale',                   '2026-12-04', '08:00:00', '17:00:00',  80, 'Two folding tables',
    'Rejected',  '2026-11-24 12:00:00', '2026-11-25 15:30:00', '2026-11-24 12:00:00');

-- One decision per decided booking (Approved / Rejected, plus #11 which was
-- Approved and later cancelled by the staff member). Pending bookings and
-- #10 (cancelled before any decision) have no row here.
INSERT INTO Booking_Approval
  (Booking_Approval_ID, Booking_Approval_Booking_ID, Booking_Approval_Admin_ID,
   Booking_Approval_Decision, Booking_Approval_Remarks, Booking_Approval_Reviewed_At)
VALUES
  ( 1,  1, 2, 'Rejected', 'Ongoing class scheduled for KMK3019 Philosophy of Mind', '2026-11-25 20:23:00'),
  ( 2,  2, 1, 'Approved', 'Approved. AV technician informed.',                     '2026-11-21 09:30:00'),
  ( 3,  5, 1, 'Approved', 'Approved for convocation briefing.',                    '2026-11-19 10:00:00'),
  ( 4,  7, 2, 'Approved', NULL,                                                    '2026-11-22 11:15:00'),
  ( 5,  8, 2, 'Approved', NULL,                                                    '2026-11-22 11:20:00'),
  ( 6,  9, 1, 'Approved', 'Replacement class approved.',                           '2026-11-11 09:00:00'),
  ( 7, 11, 2, 'Approved', 'Approved.',                                             '2026-11-20 14:00:00'),
  ( 8, 13, 1, 'Rejected', 'Room reserved for faculty board meeting.',              '2026-11-23 10:10:00'),
  ( 9, 14, 2, 'Approved', 'Please return headsets to the lab cabinet.',            '2026-11-24 09:45:00'),
  (10, 16, 1, 'Approved', NULL,                                                    '2026-11-25 11:00:00'),
  (11, 17, 2, 'Rejected', 'Lobby must stay clear during exam week.',               '2026-11-25 15:30:00');

ALTER TABLE Booking          AUTO_INCREMENT = 18;
ALTER TABLE Booking_Approval AUTO_INCREMENT = 12;

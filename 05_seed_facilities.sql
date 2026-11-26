-- =====================================================================
-- 05_seed_facilities.sql — FCSHD Room Booking System (KMK3393)
-- Seeds: Facility (12), Room_Facility (18)   [Stretch A]
-- Needs 03 (rooms) loaded first.
-- Room_ID values: 1 = TR1, 11 = CL1, 16 = MT, 17 = SR, 19 = MIMM,
--                 20 = MRM, 24 = DK, 27 = BMU, 33 = BPC
-- Dates in notes are written YYYY-MM-DD so nobody misreads 11/12 as
-- 12 November vs 11 December.
-- =====================================================================
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM `Facility`;
ALTER TABLE `Facility` AUTO_INCREMENT = 1;

-- Your INSERT INTO statements go here...
DELETE FROM `Room_Facility`;
ALTER TABLE `Room_Facility` AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO Facility (Facility_ID, Facility_Name, Facility_Type, Facility_Description) VALUES
  ( 1, 'Projector',              'Electronics',          'Ceiling-mounted LCD projector with HDMI input'),
  ( 2, 'Wireless microphone',    'Electronics',          'Handheld wireless microphone'),
  ( 3, 'PA speaker system',      'Electronics',          'Two speakers with mixer'),
  ( 4, 'Smart TV',               'Electronics',          '65-inch display for presentations'),
  ( 5, 'Whiteboard',             'Furniture',            'Wall-mounted magnetic whiteboard'),
  ( 6, 'Conference table',       'Furniture',            'Seats up to 20 people'),
  ( 7, 'Desktop PC',             'Computing',            'Lab PC with SPSS and Python installed'),
  ( 8, 'VR headset',             'Specialist equipment', 'Standalone VR headset'),
  ( 9, 'Eye tracker',            'Specialist equipment', 'Screen-based eye tracker for usability studies'),
  (10, 'Printer',                'Electronics',          'Epson L3250 ink tank printer'),
  (11, 'Air conditioner',        'Building',             'Split-unit air conditioner'),
  (12, 'Video conferencing kit', 'Electronics',          'Webcam and speakerphone for hybrid meetings');

INSERT INTO Room_Facility (Room_ID, Facility_ID, Room_Facility_Quantity, Room_Facility_Notes) VALUES
  ( 1,  1,  1, 'Last maintained 2025-12-11'),
  ( 1,  5,  1, NULL),
  (11,  7, 40, NULL),
  (11,  1,  1, NULL),
  (16,  1,  2, 'Dual projectors'),
  (16,  2,  4, NULL),
  (16,  3,  1, NULL),
  (17,  1,  1, NULL),
  (17,  2,  2, NULL),
  (19,  9,  2, 'Calibrate before each session'),
  (19,  7, 10, NULL),
  (20,  8, 10, NULL),
  (24,  3,  1, NULL),
  (24,  2,  4, NULL),
  (27,  6,  1, NULL),
  (27, 12,  1, NULL),
  (27,  4,  1, NULL),
  (33, 10,  2, NULL);

ALTER TABLE Facility AUTO_INCREMENT = 13;


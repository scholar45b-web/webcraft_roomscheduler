-- =====================================================================
-- 03_seed_rooms.sql — FCSHD Room Booking System (KMK3393)
-- Seeds: Room (33 rooms, from fskpm_rooms_breakdown-v2.csv)
--
-- Room_ID   = internal key (1-33) that bookings point to.
-- Room_Code = the room's initials, shown to people (TR1, CL1, MT ...).
-- Room_Type = the category from the CSV.
--
-- TO CHECK BEFORE THE DEMO:
--  * Capacities are PLACEHOLDERS (the CSV has none): replace with real numbers.
--  * The CSV floor for Tutorial Rooms is "Floor G & Floor 1 (partially
--    unreadable)": TR1-5 are put on Floor G and TR6-10 on Floor 1 as a guess.
--  * Bilik Sumber FSKPM is "Floor G / Floor 1 (unreadable)": put on Floor G.
--  * The four "Other" rooms (rest room, waiting room, office, printing room)
--    are seeded as INACTIVE (not bookable). Change to 1 if they should be.
--  * Initials that clashed were made unique: Bilik Siswazah = BSW (Bilik
--    Sumber is BS), Bilik Percetakan = BPC (Bilik Perundangan is BP),
--    Lobby = LBY.
-- =====================================================================

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM `Room`;
ALTER TABLE `Room` AUTO_INCREMENT = 1;

-- Your INSERT INTO statements go here...

SET FOREIGN_KEY_CHECKS = 1;


INSERT INTO Room
  (Room_ID, Room_Code, Room_Name, Room_Type, Room_Capacity, Room_Location, Room_Is_Active)
VALUES
  -- Lecture Room
  ( 1, 'TR1',  'Tutorial Room 1',                'Lecture Room',              40, 'Floor G',  1),
  ( 2, 'TR2',  'Tutorial Room 2',                'Lecture Room',              40, 'Floor G',  1),
  ( 3, 'TR3',  'Tutorial Room 3',                'Lecture Room',              40, 'Floor G',  1),
  ( 4, 'TR4',  'Tutorial Room 4',                'Lecture Room',              40, 'Floor G',  1),
  ( 5, 'TR5',  'Tutorial Room 5',                'Lecture Room',              40, 'Floor G',  1),
  ( 6, 'TR6',  'Tutorial Room 6',                'Lecture Room',              40, 'Floor 1',  1),
  ( 7, 'TR7',  'Tutorial Room 7',                'Lecture Room',              40, 'Floor 1',  1),
  ( 8, 'TR8',  'Tutorial Room 8',                'Lecture Room',              40, 'Floor 1',  1),
  ( 9, 'TR9',  'Tutorial Room 9',                'Lecture Room',              40, 'Floor 1',  1),
  (10, 'TR10', 'Tutorial Room 10',               'Lecture Room',              40, 'Floor 1',  1),
  (11, 'CL1',  'Computer Lab 1',                 'Lecture Room',              40, 'Floor LG', 1),
  (12, 'CL2',  'Computer Lab 2',                 'Lecture Room',              40, 'Floor LG', 1),
  (13, 'CL3',  'Computer Lab 3',                 'Lecture Room',              40, 'Floor LG', 1),
  (14, 'CL4',  'Computer Lab 4',                 'Lecture Room',              40, 'Floor LG', 1),
  (15, 'CL5',  'Computer Lab 5',                 'Lecture Room',              40, 'Floor LG', 1),
  -- Hall
  (16, 'MT',   'Multimedia Theater',             'Hall',                     150, 'Floor 1',  1),
  (17, 'SR',   'Seminar Room',                   'Hall',                      80, 'Floor G',  1),
  -- Technical / Professional
  (18, 'MKB',  'Makmal Kepintaran Buatan',       'Technical / Professional',  30, 'Floor 1',  1),
  (19, 'MIMM', 'Makmal Interaksi Mesin Manusia', 'Technical / Professional',  30, 'Floor 1',  1),
  (20, 'MRM',  'Makmal Realiti Maya',            'Technical / Professional',  25, 'Floor 1',  1),
  -- Casual / Gathering
  (21, 'LBY',  'Lobby',                          'Casual / Gathering',       100, 'Floor G',  1),
  (22, 'BP',   'Bilik Perundangan',              'Casual / Gathering',        15, 'Floor G',  1),
  (23, 'BS',   'Bilik Sumber FSKPM',             'Casual / Gathering',        30, 'Floor G',  1),
  -- Formal Events
  (24, 'DK',   'Dewan Ketibaan FSKPM',           'Formal Events',            200, 'Floor G',  1),
  (25, 'BSW1', 'Bilik Siswazah FSKPM 1',         'Formal Events',             25, 'Floor 1',  1),
  (26, 'BSW2', 'Bilik Siswazah FSKPM 2',         'Formal Events',             25, 'Floor 1',  1),
  (27, 'BMU',  'Bilik Mesyuarat Utama',          'Formal Events',             30, 'Floor 1',  1),
  (28, 'BME1', 'Bilik Mesyuarat Event 1',        'Formal Events',             20, 'Floor 2',  1),
  (29, 'BME2', 'Bilik Mesyuarat Event 2',        'Formal Events',             20, 'Floor 2',  1),
  -- Other (seeded as not bookable)
  (30, 'BI',   'Bilik Istirehat',                'Other',                     10, 'Floor 1',  0),
  (31, 'BM',   'Bilik Menunggu',                 'Other',                     10, 'Floor 2',  0),
  (32, 'PAF',  'Pejabat Am Fakulti',             'Other',                     15, 'Floor 2',  0),
  (33, 'BPC',  'Bilik Percetakan',               'Other',                      5, 'Floor 2',  0);

ALTER TABLE Room AUTO_INCREMENT = 34;

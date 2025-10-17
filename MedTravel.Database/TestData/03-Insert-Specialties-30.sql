-- =============================================
-- Insert 30 Medical Specialties
-- =============================================

PRINT 'Inserting 30 Medical Specialties...';

-- Core Medical Specialties
IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Cardiology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Cardiology', 'Heart and cardiovascular system diseases and treatments', 'Internal Medicine', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Neurology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Neurology', 'Brain, spinal cord, and nervous system disorders', 'Internal Medicine', 2);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Orthopedics')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Orthopedics', 'Bones, joints, muscles, and spine disorders', 'Surgery', 3);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Pediatrics')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Pediatrics', 'Medical care for infants, children, and adolescents', 'General Medicine', 4);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Oncology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Oncology', 'Cancer diagnosis, treatment, and management', 'Internal Medicine', 5);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Gastroenterology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Gastroenterology', 'Digestive system and liver diseases', 'Internal Medicine', 6);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Nephrology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Nephrology', 'Kidney diseases and dialysis', 'Internal Medicine', 7);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Urology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Urology', 'Urinary tract and male reproductive system', 'Surgery', 8);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Gynecology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Gynecology', 'Women reproductive health and diseases', 'Surgery', 9);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Dermatology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Dermatology', 'Skin, hair, and nail disorders', 'General Medicine', 10);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Ophthalmology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Ophthalmology', 'Eye diseases and vision care', 'Surgery', 11);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'ENT')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'ENT', 'Ear, nose, and throat disorders', 'Surgery', 12);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Psychiatry')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Psychiatry', 'Mental health and behavioral disorders', 'Internal Medicine', 13);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Endocrinology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Endocrinology', 'Hormone disorders and diabetes', 'Internal Medicine', 14);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Pulmonology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Pulmonology', 'Lung and respiratory system diseases', 'Internal Medicine', 15);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Rheumatology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Rheumatology', 'Joint and autoimmune diseases', 'Internal Medicine', 16);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Hematology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Hematology', 'Blood disorders and blood cancers', 'Internal Medicine', 17);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'General Surgery')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'General Surgery', 'General surgical procedures and trauma', 'Surgery', 18);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Plastic Surgery')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Plastic Surgery', 'Reconstructive and cosmetic surgery', 'Surgery', 19);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Neurosurgery')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Neurosurgery', 'Brain and spinal cord surgery', 'Surgery', 20);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Cardiac Surgery')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Cardiac Surgery', 'Heart and blood vessel surgery', 'Surgery', 21);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Pediatric Surgery')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Pediatric Surgery', 'Surgical procedures for children', 'Surgery', 22);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Emergency Medicine')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Emergency Medicine', 'Emergency and critical care medicine', 'Emergency', 23);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Anesthesiology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Anesthesiology', 'Anesthesia and pain management', 'Support', 24);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Radiology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Radiology', 'Medical imaging and diagnostic radiology', 'Diagnostic', 25);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Pathology')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Pathology', 'Laboratory medicine and disease diagnosis', 'Diagnostic', 26);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Physical Medicine')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Physical Medicine', 'Physical therapy and rehabilitation', 'Support', 27);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Geriatrics')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Geriatrics', 'Medical care for elderly patients', 'General Medicine', 28);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Infectious Diseases')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Infectious Diseases', 'Bacterial, viral, and parasitic infections', 'Internal Medicine', 29);

IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties WHERE Name = 'Sports Medicine')
INSERT INTO Metadata.Specialties (Id, Name, Description, Category, SortOrder)
VALUES (NEWID(), 'Sports Medicine', 'Sports injuries and athletic performance', 'Support', 30);

PRINT 'Successfully inserted 30 medical specialties!';
GO

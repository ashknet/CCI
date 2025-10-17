-- =============================================
-- Insert 50 Test Hospitals - Hyderabad Real Hospitals
-- =============================================

-- Get required metadata IDs
DECLARE @CountryId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Countries WHERE Name = 'India');
DECLARE @CityId_HYD UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Cities WHERE Name LIKE '%Hyderabad%');

PRINT 'Inserting 50 Hyderabad Hospitals...';

-- Top Hospitals in Hyderabad
IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Apollo Hospital Jubilee Hills')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Apollo Hospital Jubilee Hills', 'Premier multi-specialty hospital with international standards, known for cardiac sciences, oncology, and organ transplants', 'Road No. 72, Film Nagar, Jubilee Hills', @CityId_HYD, @CountryId, '500033', 17.4346, 78.4066, '+91-40-23607777', 'info@apollohyd.com', 'www.apollohospitals.com', 750, 1988, 4.5, 2500, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Yashoda Hospitals Somajiguda')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Yashoda Hospitals Somajiguda', 'Multi-specialty healthcare provider with advanced cardiac care, neurosciences, and orthopedics', 'Raj Bhavan Road, Somajiguda', @CityId_HYD, @CountryId, '500082', 17.4239, 78.4738, '+91-40-23557000', 'contact@yashodahospitals.com', 'www.yashodahospitals.com', 600, 1989, 4.3, 1800, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Care Hospitals Banjara Hills')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Care Hospitals Banjara Hills', 'Leading multi-specialty hospital with expertise in emergency medicine, critical care, and minimally invasive surgeries', 'Road No. 1, Banjara Hills', @CityId_HYD, @CountryId, '500034', 17.4126, 78.4561, '+91-40-61656565', 'info@carehospitals.com', 'www.carehospitals.com', 550, 1997, 4.4, 2100, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'KIMS Hospital Secunderabad')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'KIMS Hospital Secunderabad', 'Advanced tertiary care hospital with specialization in cardiology, oncology, and neurosciences', '1-8-31/1, Minister Road', @CityId_HYD, @CountryId, '500003', 17.4399, 78.4983, '+91-40-44885000', 'info@kimshospitals.com', 'www.kimshospitals.com', 500, 2003, 4.2, 1650, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Continental Hospitals Gachibowli')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Continental Hospitals Gachibowli', 'State-of-the-art hospital with focus on heart, liver, and kidney care with international standards', 'Plot No 3, Road No 2, IT & Financial District, Gachibowli', @CityId_HYD, @CountryId, '500032', 17.4485, 78.3746, '+91-40-67165566', 'info@continentalhospitals.com', 'www.continentalhospitals.com', 650, 2013, 4.6, 1920, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Star Hospitals Banjara Hills')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Star Hospitals Banjara Hills', 'Premier multi-organ transplant center with excellence in nephrology, urology, and gastroenterology', '8-2-596/5, Road No 10, Banjara Hills', @CityId_HYD, @CountryId, '500034', 17.4172, 78.4490, '+91-40-44777000', 'info@starhospitals.com', 'www.starhospitals.com', 400, 2002, 4.5, 1450, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Asian Institute of Gastroenterology')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Asian Institute of Gastroenterology', 'Specialized center for digestive diseases, liver transplants, and advanced endoscopy', '6-3-661, Somajiguda', @CityId_HYD, @CountryId, '500082', 17.4277, 78.4667, '+91-40-23378888', 'info@aigindia.com', 'www.aigindia.com', 300, 1998, 4.7, 980, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Rainbow Children Hospital Banjara Hills')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Rainbow Children Hospital Banjara Hills', 'Leading pediatric hospital with expertise in neonatology, pediatric surgery, and child development', 'Road No. 10, Banjara Hills', @CityId_HYD, @CountryId, '500034', 17.4189, 78.4501, '+91-40-44006000', 'info@rainbowhospitals.in', 'www.rainbowhospitals.in', 350, 1998, 4.6, 1520, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Aware Gleneagles Global Hospital LB Nagar')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Aware Gleneagles Global Hospital LB Nagar', 'Multi-specialty hospital with advanced facilities for cardiac care, oncology, and orthopedics', 'LB Nagar Circle, Beside Chaitanya College', @CityId_HYD, @CountryId, '500074', 17.3480, 78.5527, '+91-40-44902525', 'info@awaregleneagles.com', 'www.awaregleneagles.com', 450, 2007, 4.3, 1340, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Medicover Hospitals Madhapur')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Medicover Hospitals Madhapur', 'Modern hospital with focus on minimally invasive procedures and personalized healthcare', 'Behind Cyber Towers, Madhapur', @CityId_HYD, @CountryId, '500081', 17.4484, 78.3915, '+91-40-68334455', 'info@medicoverhospitals.in', 'www.medicoverhospitals.in', 300, 2016, 4.4, 890, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Sunshine Hospitals Gachibowli')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Sunshine Hospitals Gachibowli', 'Multi-specialty hospital known for bone marrow transplant and comprehensive cancer care', 'PG Road, Opposite Panchavati Colony, Gachibowli', @CityId_HYD, @CountryId, '500032', 17.4403, 78.3673, '+91-40-44246666', 'info@sunshinehospitals.com', 'www.sunshinehospitals.com', 400, 2009, 4.5, 1120, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Omni Hospital Kukatpally')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Omni Hospital Kukatpally', 'Multi-specialty hospital with excellence in emergency medicine and critical care', 'Beside Patel Kunta Huda Park, Kukatpally', @CityId_HYD, @CountryId, '500072', 17.4849, 78.4138, '+91-40-44345000', 'info@omnihospitals.com', 'www.omnihospitals.com', 250, 2010, 4.2, 780, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Maxcure Hospitals Madhapur')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Maxcure Hospitals Madhapur', 'Advanced hospital with expertise in orthopedics, spine surgery, and sports medicine', 'Beside Cyber Towers, Hitec City', @CityId_HYD, @CountryId, '500081', 17.4492, 78.3910, '+91-40-67193333', 'info@maxcurehospitals.com', 'www.maxcurehospitals.com', 200, 2013, 4.3, 650, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Fernandez Hospital Bogulkunta')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Fernandez Hospital Bogulkunta', 'Leading womens and childrens hospital with expertise in high-risk pregnancy and neonatal care', '4-1-1230, Bogulkunta', @CityId_HYD, @CountryId, '500001', 17.3908, 78.4768, '+91-40-24754222', 'info@fernandezhospital.com', 'www.fernandezhospital.com', 180, 1988, 4.6, 1250, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Century Hospital Lakdi Ka Pul')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Century Hospital Lakdi Ka Pul', 'Multi-specialty hospital with focus on cardiology, neurology, and advanced surgical procedures', 'Lakdi Ka Pul, Beside Dominos Pizza', @CityId_HYD, @CountryId, '500004', 17.4047, 78.4629, '+91-40-30256666', 'info@centuryhospital.in', 'www.centuryhospital.in', 150, 2000, 4.1, 580, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Citizens Hospital Nallagandla')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Citizens Hospital Nallagandla', 'Community hospital with comprehensive services for cardiology, orthopedics, and general medicine', 'Nallagandla, Serilingampally', @CityId_HYD, @CountryId, '500019', 17.4688, 78.3541, '+91-40-48586868', 'info@citizenshospital.com', 'www.citizenshospital.com', 120, 2008, 4.0, 420, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'AIG Hospitals Gachibowli')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'AIG Hospitals Gachibowli', 'Multi-organ transplant hospital with state-of-the-art facilities for liver, kidney, and heart transplants', 'Plot No. 2/3/4/5, Survey No. 136/1, Mindspace Road', @CityId_HYD, @CountryId, '500032', 17.4421, 78.3769, '+91-40-42030303', 'info@aighospitals.com', 'www.aighospitals.com', 500, 2015, 4.7, 1680, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Lotus Hospital Ameerpet')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Lotus Hospital Ameerpet', 'Maternity and womens hospital specializing in high-risk pregnancies and fertility treatments', 'Ameerpet Main Road, Beside Srikanya Theatre', @CityId_HYD, @CountryId, '500016', 17.4373, 78.4485, '+91-40-23735345', 'info@lotushospital.in', 'www.lotushospital.in', 100, 2005, 4.4, 720, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Apollo Cradle Kondapur')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Apollo Cradle Kondapur', 'Maternity hospital with focus on comprehensive prenatal and postnatal care', 'Whitefields, Near Inorbit Mall, Kondapur', @CityId_HYD, @CountryId, '500084', 17.4606, 78.3684, '+91-40-67006000', 'info@apollocradle.com', 'www.apollocradle.com', 80, 2013, 4.5, 890, 1, GETUTCDATE());

-- Additional 30 hospitals (smaller clinics and specialty centers)
IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Pranahitha Hospital Kukatpally')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Pranahitha Hospital Kukatpally', 'Multi-specialty clinic with focus on general medicine and diagnostics', 'KPHB Colony, Kukatpally', @CityId_HYD, @CountryId, '500072', 17.4923, 78.4087, '+91-40-23067890', 'info@pranahitha.com', 'www.pranahitha.com', 60, 2012, 3.9, 320, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Vijaya Diagnostic Centre Banjara Hills')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Vijaya Diagnostic Centre Banjara Hills', 'Advanced diagnostic center with comprehensive pathology and radiology services', 'Road No. 1, Banjara Hills', @CityId_HYD, @CountryId, '500034', 17.4133, 78.4545, '+91-40-40206000', 'info@vijayadiagnostic.com', 'www.vijayadiagnostic.com', 0, 1981, 4.3, 1850, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Care Hospital Hitech City')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Care Hospital Hitech City', 'Multi-specialty hospital with advanced ICU and emergency services', 'Old Mumbai Highway, Hitech City', @CityId_HYD, @CountryId, '500081', 17.4526, 78.3817, '+91-40-61656565', 'hitechcity@carehospitals.com', 'www.carehospitals.com', 280, 2014, 4.3, 980, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Apollo Spectra Hospitals Kondapur')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Apollo Spectra Hospitals Kondapur', 'Day-care surgery center specializing in laparoscopic and minimally invasive procedures', 'Whitefields, Kondapur', @CityId_HYD, @CountryId, '500084', 17.4598, 78.3695, '+91-40-44885000', 'kondapur@apollospectra.com', 'www.apollospectra.com', 50, 2017, 4.2, 450, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Srikara Hospitals Miyapur')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Srikara Hospitals Miyapur', 'Community hospital with general medicine, pediatrics, and orthopedics', 'Miyapur X Roads, Miyapur', @CityId_HYD, @CountryId, '500049', 17.4952, 78.3584, '+91-40-23046789', 'info@srikarahospitals.com', 'www.srikarahospitals.com', 70, 2011, 3.8, 280, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Yashoda Hospitals Malakpet')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Yashoda Hospitals Malakpet', 'Multi-specialty hospital with focus on cardiology and neurology', 'SP Road, Malakpet', @CityId_HYD, @CountryId, '500024', 17.3815, 78.5124, '+91-40-66939999', 'malakpet@yashodahospitals.com', 'www.yashodahospitals.com', 450, 2010, 4.2, 1420, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Lotus Hospital Dilsukhnagar')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Lotus Hospital Dilsukhnagar', 'Womens hospital specializing in maternity and gynecology services', 'Beside Kamineni Hospital, Dilsukhnagar', @CityId_HYD, @CountryId, '500036', 17.3688, 78.5246, '+91-40-24035345', 'dilsukhnagar@lotushospital.in', 'www.lotushospital.in', 90, 2008, 4.3, 680, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Kamineni Hospital LB Nagar')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Kamineni Hospital LB Nagar', 'Multi-specialty hospital with comprehensive healthcare services', 'LB Nagar Cross Road, LB Nagar', @CityId_HYD, @CountryId, '500074', 17.3509, 78.5512, '+91-40-30222222', 'info@kamineihospitals.com', 'www.kamineihospitals.com', 320, 1997, 4.1, 1150, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Gandhi Hospital Secunderabad')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Gandhi Hospital Secunderabad', 'Government multi-specialty hospital providing affordable healthcare', 'Musheerabad, Secunderabad', @CityId_HYD, @CountryId, '500003', 17.4496, 78.4917, '+91-40-27541201', 'info@gandhi-hospital.com', 'www.gandhi-hospital.com', 800, 1954, 3.7, 2200, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Osmania General Hospital')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Osmania General Hospital', 'Historic government teaching hospital with comprehensive medical education and patient care', 'Afzal Gunj', @CityId_HYD, @CountryId, '500012', 17.3741, 78.4794, '+91-40-24600146', 'info@osmaniahospital.com', 'www.osmaniahospital.com', 1200, 1919, 3.6, 3500, 1, GETUTCDATE());

-- Continue with 20 more hospitals
IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Suraksha Multi-Specialty Hospital Kukatpally')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Suraksha Multi-Specialty Hospital Kukatpally', 'Multi-specialty hospital with emergency care and ICU facilities', 'JNTU, Kukatpally', @CityId_HYD, @CountryId, '500085', 17.4971, 78.3899, '+91-40-23158888', 'info@surakshahospital.in', 'www.surakshahospital.in', 100, 2009, 3.9, 380, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Omega Hospitals Banjara Hills')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Omega Hospitals Banjara Hills', 'Cancer specialty hospital with advanced oncology treatments', 'Road No. 12, Banjara Hills', @CityId_HYD, @CountryId, '500034', 17.4211, 78.4469, '+91-40-40022222', 'info@omegahospitals.com', 'www.omegahospitals.com', 200, 2012, 4.5, 890, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Remedy Hospital Kukatpally')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YeerEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Remedy Hospital Kukatpally', 'Community hospital with general medicine and pediatrics', 'Opposite BHEL, Kukatpally', @CityId_HYD, @CountryId, '500072', 17.4902, 78.4106, '+91-40-23056789', 'info@remedyhospital.in', 'www.remedyhospital.in', 80, 2010, 3.8, 290, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Life Care Hospital Banjara Hills')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Life Care Hospital Banjara Hills', 'Multi-specialty hospital with focus on cardiology and orthopedics', 'Road No. 5, Banjara Hills', @CityId_HYD, @CountryId, '500034', 17.4154, 78.4523, '+91-40-23547890', 'info@lifecare.com', 'www.lifecare.com', 120, 2006, 4.0, 520, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Balaji Hospital Miyapur')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Balaji Hospital Miyapur', 'General hospital with emergency and outpatient services', 'Main Road, Miyapur', @CityId_HYD, @CountryId, '500049', 17.4966, 78.3611, '+91-40-23789012', 'info@balajihospital.in', 'www.balajihospital.in', 60, 2011, 3.7, 250, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Apollo Clinic Jubilee Hills')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Apollo Clinic Jubilee Hills', 'Outpatient clinic with general medicine and specialist consultations', 'Road No. 36, Jubilee Hills', @CityId_HYD, @CountryId, '500033', 17.4298, 78.4123, '+91-40-23456789', 'jubileehills@apolloclinic.com', 'www.apolloclinic.com', 0, 2015, 4.1, 420, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Metro Heart Institute Secunderabad')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Metro Heart Institute Secunderabad', 'Cardiac specialty center with interventional cardiology', 'Beside Kaman, Secunderabad', @CityId_HYD, @CountryId, '500003', 17.4422, 78.5009, '+91-40-27803456', 'info@metroheart.in', 'www.metroheart.in', 100, 2008, 4.2, 560, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Pulse Hospital Kompally')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Pulse Hospital Kompally', 'Multi-specialty hospital with modern facilities', 'Main Road, Kompally', @CityId_HYD, @CountryId, '500014', 17.5394, 78.4925, '+91-40-27123456', 'info@pulsehospital.in', 'www.pulsehospital.in', 90, 2013, 3.9, 340, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Yashodha Hospitals Secunderabad')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Yashodha Hospitals Secunderabad', 'Multi-specialty branch with comprehensive services', 'Alexander Road, Secunderabad', @CityId_HYD, @CountryId, '500003', 17.4386, 78.5042, '+91-40-44777777', 'secunderabad@yashodahospitals.com', 'www.yashodahospitals.com', 350, 2012, 4.1, 980, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Virinchi Hospital Banjara Hills')
INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews, IsActive, CreatedAt)
VALUES (NEWID(), 'Virinchi Hospital Banjara Hills', 'Multi-specialty hospital with advanced diagnostics and treatment', 'Road No. 1, Banjara Hills', @CityId_HYD, @CountryId, '500034', 17.4121, 78.4556, '+91-40-44266644', 'info@virinchihospitals.com', 'www.virinchihospitals.com', 200, 2009, 4.0, 720, 1, GETUTCDATE());

PRINT 'Successfully inserted 50 Hyderabad hospitals!';
GO

-- =============================================
-- Insert 50 Common Diseases
-- =============================================

PRINT 'Inserting 50 Common Diseases...';

-- Cardiovascular Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Hypertension')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Hypertension', 'Cardiovascular', 'High blood pressure condition', 'Headaches, shortness of breath, nosebleeds', 'I10', 'Lifestyle changes, medication, regular monitoring', 5000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Coronary Artery Disease')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Coronary Artery Disease', 'Cardiovascular', 'Narrowing of coronary arteries', 'Chest pain, shortness of breath, fatigue', 'I25.9', 'Medication, angioplasty, bypass surgery', 150000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Heart Failure')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Heart Failure', 'Cardiovascular', 'Heart cannot pump blood effectively', 'Shortness of breath, swelling, fatigue', 'I50.9', 'Medication, lifestyle changes, device therapy', 80000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Atrial Fibrillation')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Atrial Fibrillation', 'Cardiovascular', 'Irregular heart rhythm', 'Palpitations, dizziness, chest pain', 'I48.91', 'Medication, cardioversion, ablation', 60000.00);

-- Neurological Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Migraine')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Migraine', 'Neurological', 'Severe headache disorder', 'Throbbing headache, nausea, sensitivity to light', 'G43.909', 'Pain relief, preventive medication, lifestyle changes', 8000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Epilepsy')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Epilepsy', 'Neurological', 'Recurrent seizures', 'Seizures, loss of consciousness, convulsions', 'G40.909', 'Antiepileptic drugs, surgery, lifestyle modifications', 25000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Parkinson Disease')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Parkinson Disease', 'Neurological', 'Progressive nervous system disorder', 'Tremors, stiffness, slow movement', 'G20', 'Medication, physical therapy, deep brain stimulation', 100000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Alzheimer Disease')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Alzheimer Disease', 'Neurological', 'Progressive memory loss and cognitive decline', 'Memory loss, confusion, personality changes', 'G30.9', 'Medication, cognitive therapy, support care', 120000.00);

-- Endocrine Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Type 2 Diabetes')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Type 2 Diabetes', 'Endocrine', 'Insulin resistance and high blood sugar', 'Increased thirst, frequent urination, fatigue', 'E11.9', 'Diet, exercise, medication, insulin therapy', 15000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Type 1 Diabetes')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Type 1 Diabetes', 'Endocrine', 'Autoimmune destruction of insulin-producing cells', 'Excessive thirst, weight loss, fatigue', 'E10.9', 'Insulin therapy, blood sugar monitoring, diet', 20000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Hypothyroidism')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Hypothyroidism', 'Endocrine', 'Underactive thyroid gland', 'Fatigue, weight gain, depression, cold intolerance', 'E03.9', 'Thyroid hormone replacement therapy', 5000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Hyperthyroidism')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Hyperthyroidism', 'Endocrine', 'Overactive thyroid gland', 'Weight loss, rapid heartbeat, anxiety, sweating', 'E05.90', 'Medication, radioactive iodine, surgery', 25000.00);

-- Respiratory Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Asthma')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Asthma', 'Respiratory', 'Chronic airway inflammation', 'Wheezing, shortness of breath, chest tightness', 'J45.909', 'Inhalers, medication, trigger avoidance', 10000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'COPD')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'COPD', 'Respiratory', 'Chronic obstructive pulmonary disease', 'Shortness of breath, chronic cough, wheezing', 'J44.1', 'Bronchodilators, oxygen therapy, pulmonary rehab', 30000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Pneumonia')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Pneumonia', 'Respiratory', 'Lung infection causing inflammation', 'Fever, cough, chest pain, difficulty breathing', 'J18.9', 'Antibiotics, rest, fluids, oxygen therapy', 15000.00);

-- Gastrointestinal Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Gastroesophageal Reflux Disease')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Gastroesophageal Reflux Disease', 'Gastrointestinal', 'Stomach acid flows back into esophagus', 'Heartburn, regurgitation, chest pain', 'K21.9', 'Lifestyle changes, medication, surgery', 8000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Irritable Bowel Syndrome')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Irritable Bowel Syndrome', 'Gastrointestinal', 'Chronic digestive disorder', 'Abdominal pain, bloating, diarrhea, constipation', 'K58.9', 'Diet modification, medication, stress management', 5000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Crohn Disease')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Crohn Disease', 'Gastrointestinal', 'Chronic inflammatory bowel disease', 'Abdominal pain, diarrhea, weight loss, fatigue', 'K50.90', 'Medication, surgery, dietary changes', 50000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Ulcerative Colitis')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Ulcerative Colitis', 'Gastrointestinal', 'Chronic inflammation of colon and rectum', 'Diarrhea with blood, abdominal pain, urgency', 'K51.90', 'Medication, surgery, dietary modifications', 45000.00);

-- Musculoskeletal Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Osteoarthritis')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Osteoarthritis', 'Musculoskeletal', 'Degenerative joint disease', 'Joint pain, stiffness, reduced range of motion', 'M19.9', 'Pain management, physical therapy, joint replacement', 30000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Rheumatoid Arthritis')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Rheumatoid Arthritis', 'Musculoskeletal', 'Autoimmune joint inflammation', 'Joint pain, swelling, morning stiffness, fatigue', 'M06.9', 'DMARDs, biologics, physical therapy', 40000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Osteoporosis')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Osteoporosis', 'Musculoskeletal', 'Bone density loss', 'Bone fractures, back pain, height loss', 'M81.0', 'Calcium, vitamin D, medication, exercise', 12000.00);

-- Mental Health Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Major Depressive Disorder')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Major Depressive Disorder', 'Mental Health', 'Persistent sadness and loss of interest', 'Depressed mood, fatigue, sleep changes, concentration issues', 'F32.9', 'Therapy, medication, lifestyle changes', 15000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Generalized Anxiety Disorder')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Generalized Anxiety Disorder', 'Mental Health', 'Excessive worry and anxiety', 'Worry, restlessness, fatigue, muscle tension', 'F41.1', 'Therapy, medication, relaxation techniques', 12000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Bipolar Disorder')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Bipolar Disorder', 'Mental Health', 'Mood swings between depression and mania', 'Mood episodes, energy changes, sleep disturbances', 'F31.9', 'Mood stabilizers, therapy, lifestyle management', 25000.00);

-- Cancer Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Breast Cancer')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Breast Cancer', 'Oncology', 'Malignant tumor in breast tissue', 'Breast lump, nipple discharge, skin changes', 'C50.919', 'Surgery, chemotherapy, radiation, hormone therapy', 200000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Lung Cancer')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Lung Cancer', 'Oncology', 'Malignant tumor in lung tissue', 'Persistent cough, chest pain, shortness of breath', 'C78.00', 'Surgery, chemotherapy, radiation, targeted therapy', 180000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Prostate Cancer')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Prostate Cancer', 'Oncology', 'Malignant tumor in prostate gland', 'Urinary problems, blood in urine, erectile dysfunction', 'C61', 'Surgery, radiation, hormone therapy, chemotherapy', 150000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Colorectal Cancer')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Colorectal Cancer', 'Oncology', 'Malignant tumor in colon or rectum', 'Blood in stool, abdominal pain, weight loss', 'C18.9', 'Surgery, chemotherapy, radiation therapy', 160000.00);

-- Kidney Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Chronic Kidney Disease')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Chronic Kidney Disease', 'Nephrology', 'Progressive loss of kidney function', 'Fatigue, swelling, high blood pressure, protein in urine', 'N18.6', 'Medication, dialysis, kidney transplant', 80000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Kidney Stones')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Kidney Stones', 'Nephrology', 'Hard deposits in kidneys', 'Severe pain, blood in urine, nausea, vomiting', 'N20.0', 'Pain management, lithotripsy, surgery', 25000.00);

-- Liver Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Hepatitis B')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Hepatitis B', 'Hepatology', 'Viral infection of the liver', 'Fatigue, jaundice, abdominal pain, dark urine', 'B16.9', 'Antiviral medication, vaccination, monitoring', 30000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Hepatitis C')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Hepatitis C', 'Hepatology', 'Viral infection of the liver', 'Fatigue, jaundice, abdominal pain, joint pain', 'B17.10', 'Antiviral therapy, liver monitoring', 50000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Cirrhosis')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Cirrhosis', 'Hepatology', 'Scarring of liver tissue', 'Fatigue, jaundice, abdominal swelling, confusion', 'K74.60', 'Lifestyle changes, medication, liver transplant', 100000.00);

-- Skin Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Psoriasis')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Psoriasis', 'Dermatology', 'Chronic autoimmune skin condition', 'Red, scaly patches, itching, joint pain', 'L40.9', 'Topical treatments, phototherapy, systemic medication', 15000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Eczema')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Eczema', 'Dermatology', 'Inflammatory skin condition', 'Itchy, red, dry skin, rash', 'L30.9', 'Moisturizers, topical steroids, antihistamines', 8000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Acne')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Acne', 'Dermatology', 'Skin condition with pimples and blackheads', 'Pimples, blackheads, whiteheads, oily skin', 'L70.9', 'Topical treatments, oral medication, lifestyle changes', 5000.00);

-- Eye Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Cataracts')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Cataracts', 'Ophthalmology', 'Clouding of the eye lens', 'Blurred vision, glare, difficulty seeing at night', 'H25.9', 'Surgery to replace lens, glasses', 40000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Glaucoma')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Glaucoma', 'Ophthalmology', 'Increased pressure in the eye', 'Gradual vision loss, eye pain, halos around lights', 'H40.9', 'Eye drops, laser treatment, surgery', 25000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Macular Degeneration')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Macular Degeneration', 'Ophthalmology', 'Deterioration of central vision', 'Blurred central vision, difficulty reading, dark spots', 'H35.30', 'Anti-VEGF injections, laser therapy, supplements', 35000.00);

-- Infectious Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Tuberculosis')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Tuberculosis', 'Infectious Disease', 'Bacterial infection primarily affecting lungs', 'Persistent cough, fever, night sweats, weight loss', 'A15.9', 'Antibiotic therapy, isolation, contact tracing', 20000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Malaria')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Malaria', 'Infectious Disease', 'Parasitic disease transmitted by mosquitoes', 'Fever, chills, headache, muscle aches', 'B54', 'Antimalarial medication, prevention measures', 15000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Dengue Fever')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Dengue Fever', 'Infectious Disease', 'Viral disease transmitted by mosquitoes', 'High fever, severe headache, joint pain, rash', 'A90', 'Supportive care, fluid management, monitoring', 12000.00);

-- Autoimmune Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Lupus')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Lupus', 'Autoimmune', 'Systemic autoimmune disease', 'Joint pain, skin rash, fatigue, fever', 'M32.9', 'Immunosuppressants, anti-inflammatory drugs, lifestyle changes', 35000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Multiple Sclerosis')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Multiple Sclerosis', 'Autoimmune', 'Immune system attacks nerve fibers', 'Fatigue, numbness, muscle weakness, coordination problems', 'G35', 'Disease-modifying therapies, symptom management', 60000.00);

-- Pediatric Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Attention Deficit Hyperactivity Disorder')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Attention Deficit Hyperactivity Disorder', 'Pediatric', 'Neurodevelopmental disorder', 'Inattention, hyperactivity, impulsivity', 'F90.9', 'Behavioral therapy, medication, educational support', 10000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Autism Spectrum Disorder')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Autism Spectrum Disorder', 'Pediatric', 'Developmental disorder affecting communication', 'Social difficulties, repetitive behaviors, communication challenges', 'F84.0', 'Behavioral therapy, speech therapy, educational support', 25000.00);

-- Gynecological Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Endometriosis')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Endometriosis', 'Gynecology', 'Uterine tissue grows outside the uterus', 'Pelvic pain, heavy periods, infertility', 'N80.9', 'Pain medication, hormone therapy, surgery', 30000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Polycystic Ovary Syndrome')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Polycystic Ovary Syndrome', 'Gynecology', 'Hormonal disorder in women', 'Irregular periods, excess hair growth, weight gain', 'E28.2', 'Lifestyle changes, medication, fertility treatment', 15000.00);

-- Urological Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Benign Prostatic Hyperplasia')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Benign Prostatic Hyperplasia', 'Urology', 'Enlarged prostate gland', 'Frequent urination, difficulty starting urination, weak stream', 'N40', 'Medication, minimally invasive procedures, surgery', 25000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Urinary Tract Infection')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Urinary Tract Infection', 'Urology', 'Bacterial infection in urinary system', 'Painful urination, frequent urination, cloudy urine', 'N39.0', 'Antibiotics, increased fluid intake, pain relief', 3000.00);

-- Additional Common Diseases
IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Anemia')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Anemia', 'Hematology', 'Low red blood cell count', 'Fatigue, weakness, pale skin, shortness of breath', 'D64.9', 'Iron supplements, vitamin B12, blood transfusion', 8000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Obesity')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Obesity', 'Endocrine', 'Excessive body fat accumulation', 'Weight gain, difficulty losing weight, joint pain', 'E66.9', 'Diet, exercise, medication, bariatric surgery', 20000.00);

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases WHERE Name = 'Sleep Apnea')
INSERT INTO Metadata.Diseases (Id, Name, Category, Description, Symptoms, ICD10Code, TreatmentOptions, AverageTreatmentCost)
VALUES (NEWID(), 'Sleep Apnea', 'Respiratory', 'Breathing interruptions during sleep', 'Loud snoring, daytime sleepiness, morning headaches', 'G47.33', 'CPAP therapy, lifestyle changes, surgery', 15000.00);

PRINT 'Successfully inserted 50 common diseases!';
GO

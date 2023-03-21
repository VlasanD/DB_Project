INSERT INTO UnitateMedicala (adresa,denumire)VALUES
("Oasului 7","Sfanta Maria"),
("Borza 15","Pasteur"),
("Libertatii 19","MedLink"),
("Indepententei 77","MedSave");

INSERT INTO Program (idClinica,zi,oraDeschidere,oraInchidere) VALUES
(1,6,'09:00','17:00'),
(1,2,'09:00','17:00'),
(1,3,'09:00','17:00'),
(1,4,'09:00','17:00'),
(1,5,'09:00','17:00'),
(2,6,'09:00','17:00'),
(2,2,'09:00','17:00'),
(2,3,'09:00','17:00'),
(2,4,'09:00','17:00'),
(2,5,'09:00','17:00');

INSERT INTO Servicii (idClinica,nume,descriereServiciu,specialitate,gradMedic,competenta,pret,durata) VALUES
(1,'ecografie','procedura','imagistica','specialist','imagistica',100,'00:30:00'),
(1,'endoscopie digestivă','procedura','urologie','specialist','certificare urologie',200,'01:05:00'),
(1,'ecocardiografie','procedura','cardiologie','specialist','cardiologie',150,'00:10:00'),
(1,'cardiologie intervențională','procedura','cardiologie','specialist','intervventionala',200,'00:35:00'),
(1,'bronhoscopie','procedura','pneumologie','specialist','pneumologie',200,'00:10:00'),
(1,'EEG','procedura','cardiologie','specialist','cardiologie',200,'00:10:00'),
(1,'EMG','procedura','cardiologie','specialist','cardiologie',200,'00:10:00'),
(2,'ecografie','procedura','imagistica','specialist','imagistica',100,'00:30:00'),
(2,'endoscopie digestivă','procedura','urologie','specialist','certificare urologie',200,'01:05:00'),
(2,'ecocardiografie','procedura','cardiologie','specialist','cardiologie',150,'00:10:00'),
(2,'cardiologie intervențională','procedura','cardiologie','specialist','intervventionala',200,'00:35:00'),
(2,'bronhoscopie','procedura','pneumologie','specialist','pneumologie',200,'00:10:00'),
(2,'EEG','procedura','cardiologie','specialist','cardiologie',200,'00:10:00'),
(2,'EMG','procedura','cardiologie','specialist','cardiologie',200,'00:10:00'),
(3,'ecografie','procedura','imagistica','specialist','imagistica',100,'00:30:00'),
(4,'endoscopie digestivă','procedura','urologie','specialist','certificare urologie',200,'01:05:00'),
(4,'ecocardiografie','procedura','cardiologie','specialist','cardiologie',150,'00:10:00'),
(4,'cardiologie intervențională','procedura','cardiologie','specialist','intervventionala',200,'00:35:00'),
(4,'bronhoscopie','procedura','pneumologie','specialist','pneumologie',200,'00:10:00'),
(4,'EEG','procedura','cardiologie','specialist','cardiologie',200,'00:10:00'),
(4,'EMG','procedura','cardiologie','specialist','cardiologie',200,'00:10:00');

INSERT INTO Cabinete(idClinica,idCamera,idServiciu) VALUES
(1,1,1),
(1,2,1),
(1,3,1),
(1,4,2),
(1,5,2),
(1,6,6),
(1,7,7);

INSERT INTO Utilizator(idClinica,nr_contract,functie,departament,nume,prenume,IBAN,CNP,email,adresa,telefon,dataAngajarii,username,parola) VALUES
(1,1,'administrator','administratie','pop','george','RO123456789A','5010227314020','popgeorge@yahoo.com','Oas 22','0773640285',CURDATE(),"popgeorge","parola"),
(2,1,'administrator','administratie','pop','george','RO123456789A','5010227314020','popgeorge@yahoo.com','Oas 22','0773640285',CURDATE(),"1","parola"),
(1,2,'superadministrator','administratie','pop','ion','RO123456789B','5010227314020','popion@yahoo.com','Oas 22','0773640285',CURDATE(),"popion","parola"),
(2,2,'superadministrator','administratie','pop','ion','RO123456789B','5010227314020','popion@yahoo.com','Oas 22','0773640285',CURDATE(),"1","parola"),
(3,1,'administrator','administratie','pop','george','RO123456789A','5010227314020','popgeorge@yahoo.com','Oas 22','0773640285',CURDATE(),"1","parola"),
(4,1,'administrator','administratie','pop','george','RO123456789A','5010227314020','popgeorge@yahoo.com','Oas 22','0773640285',CURDATE(),"1","parola"),
(3,2,'superadministrator','administratie','pop','ion','RO123456789B','5010227314020','popion@yahoo.com','Oas 22','0773640285',CURDATE(),"1","parola"),
(4,2,'superadministrator','administratie','pop','ion','RO123456789B','5010227314020','popion@yahoo.com','Oas 22','0773640285',CURDATE(),"1","parola"),
(1,3,'receptioner','medical','popa','alina','RO123456789A','6010227314020','popalina@yahoo.com','Cehei 42','0773640285',CURDATE(),"popalina","parola"),
(2,4,'receptioner','medical','tot','alina','RO123456789A','6010227314020','totalina@yahoo.com','Cehei 42','0773640285',CURDATE(),"1","parola"),
(3,5,'receptioner','medical','traub','alina','RO123456789A','6010227314020','traubalina@yahoo.com','Cehei 45','0773640285',CURDATE(),"1","parola"),
(4,6,'receptioner','medical','popas','alina','RO123456789A','6010227314020','popaslina@yahoo.com','Cehei 46','0773640285',CURDATE(),"1","parola"),
(1,7,'inspector','resurse umane','tot','darius','RO123456789A','6010227314020','totdarius@yahoo.com','Cehei 46','0773640285',CURDATE(),"totalina","parola"),
(2,8,'inspector','resurse umane','tot','david','RO123456789A','6010227314020','totdavid@yahoo.com','Cehei 46','0773640285',CURDATE(),"1","parola"),
(3,9,'inspector','resurse umane','tot','andrei','RO123456789A','6010227314020','totandrei@yahoo.com','Cehei 46','0773640285',CURDATE(),"1","parola"),
(4,10,'inspector','resurse umane','tot','andreea','RO123456789A','6010227314020','totandreea@yahoo.com','Cehei 46','0773640285',CURDATE(),"1","parola"),
(1,11,'expert','economic','bledea','maria','RO123456789A','6010227314020','bledeamaria@yahoo.com','Cehei 46','0773640285',CURDATE(),"bledeamaria","parola"),
(2,12,'expert','economic','bledeab','maria','RO123456789A','6010227314020','bledeabmaria@yahoo.com','Cehei 46','0773640285',CURDATE(),"1","parola"),
(3,13,'expert','economic','bledeac','maria','RO123456789A','6010227314020','bledeacmaria@yahoo.com','Cehei 46','0773640285',CURDATE(),"1","parola"),
(4,14,'expert','economic','bledead','maria','RO123456789A','6010227314020','bledeadmaria@yahoo.com','Cehei 46','0773640285',CURDATE(),"1","parola"),
(1,15,'medic','medical','gurza','roland','RO123456789A','6010227314020','gurzaroland@yahoo.com','Cehei 46','0773640285',CURDATE(),"gurzaroland","parola"),
(2,15,'medic','medical','gurza','roland','RO123456789A','6010227314020','gurzaroland@yahoo.com','Cehei 46','0773640285',CURDATE(),"1","parola"),
(1,16,'asistenta','medical','tetis','geanina','RO123456789A','6010227314020','geaninatetis@yahoo.com','Cehei 46','0773640285',CURDATE(),"geaninatetis","parola"),
(1,17,'medic','medical','john','lennon','RO123456789A','6010227314020','jlen@yahoo.com','Cehei 46','0773640285',CURDATE(),"1","parola");

INSERT INTO Angajat (idClinica,nr_contract,salariuNegociat,nrOre) VALUES
(1,1,3.1,10),
(1,2,6,10),
(1,7,6.2,10),
(1,3,5.5,50),
(1,11,2,100),
(1,15,5,100),
(2,15,6,30),
(1,16,6,20),
(2,4,10,10),
(1,17,5,100);

INSERT INTO AsistentMedical VALUES
(16,'principal','generalist');

INSERT INTO Medic VALUES
(1,15,100,'doctorand','profesor',10),
(1,17,100,'doctorand','profesor',10);

INSERT INTO Competente VALUES
(15,'imagistica','specialist','ecografie'),
(15,'urologie','specialist','endoscopie digestivă');

INSERT INTO ExceptieOrar(nr_contract,oraInceput,oraSfarsit,ziExceptionala) VALUES
(15,'09:00:00','11:00:00','2023-01-30');

INSERT INTO Concedii VALUES
(15,'2023-01-22','2023-01-28'),
(16,'2023-01-22','2023-01-25');

INSERT INTO Pacienti(nume,prenume,CNP,adresa) VALUES
('doe','john','6030493241018','Vervely Bulls 66'),
('johanna','andre','6030493241018','Vervely Bulls 26');

INSERT INTO RaportConsultatie(idPacient,nr_contract_medic,nr_contract_medic_recomandare,nr_contract_asistent,dataConsultatie,simptome,diagnostic,recomandari,Parafare) VALUES
(1,15,15,16,'2023-01-09','epidema','roseata','epideral 100mg',100),
(2,15,15,16,'2023-01-09','limfoma','roseata','epidermatratol 50mg',100);


INSERT INTO ServiciiPersonalizate (idServiciu,pret,durata,nr_contract) VALUES
(2,150,'00:30:00',15),
(1,200,'0:45:00',17);

INSERT INTO Programare(idPacient,nr_contract_receptioner,nr_contract_medic,dataProgramarii,oraProgramarii,idServiciu,idCamera) VALUES
(1,3,15,'2023-01-09','09:00:00',1,1),
(1,3,15,'2023-01-09','11:00:00',1,1),
(1,3,15,'2023-01-09','13:00:00',2,4),
(2,4,15,'2023-01-09','18:00:00',1,4),
(2,4,17,'2023-01-09','18:00:00',1,1);


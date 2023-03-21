DROP DATABASE IF EXISTS ProiectReteaClinica;

CREATE DATABASE ProiectReteaClinica;

USE ProiectReteaClinica;

CREATE TABLE IF NOT EXISTS UnitateMedicala(
	id INTEGER NOT NULL PRIMARY KEY auto_increment,
	denumire VARCHAR(50),
	adresa VARCHAR(50),
    nrCabinete INTEGER
);

CREATE TABLE IF NOT EXISTS Program(
	idClinica INTEGER,
	zi INTEGER,
	oraDeschidere TIME,
	oraInchidere TIME,
CONSTRAINT FK_UNITATE_MEDICALE_PROGRAM FOREIGN KEY (idClinica) REFERENCES UnitateMedicala(id),
CONSTRAINT PK_Program PRIMARY KEY (idClinica,zi)
);

CREATE TABLE IF NOT EXISTS Servicii(
	idServiciu INTEGER PRIMARY KEY auto_increment,
	idClinica INTEGER,
	nume VARCHAR(50) NOT NULL,
	descriereServiciu VARCHAR(500),
	specialitate VARCHAR(50),
	gradMedic VARCHAR(50),
	competenta VARCHAR(50),
	pret FLOAT(6,2),
	durata TIME,
CONSTRAINT FK_UNITATE_MEDICALE_SERVICII FOREIGN KEY (idClinica) REFERENCES UnitateMedicala(id)
);

CREATE TABLE IF NOT EXISTS Cabinete(
	idCamera INTEGER NOT NULL,
	idClinica INTEGER NOT NULL,
    idServiciu INTEGER NOT NULL,
    echipament VARCHAR(50),
CONSTRAINT FK_Cabinete_UnitateMedicala FOREIGN KEY (idClinica) REFERENCES UnitateMedicala(id),
CONSTRAINT FK_Cabinete_Servicii FOREIGN KEY (idServiciu) REFERENCES Servicii(idServiciu),
CONSTRAINT PK_C PRIMARY KEY (idCamera,idServiciu)
);

CREATE TABLE IF NOT EXISTS Utilizator(
	nr_contract INTEGER NOT NULL,
	CNP VARCHAR(13),
	nume VARCHAR(50),
	prenume VARCHAR(50),
	adresa VARCHAR(50),
	telefon VARCHAR(10),
	email VARCHAR(50),
	IBAN VARCHAR(50),
	dataAngajarii date,
	functie VARCHAR(50),
	idClinica INTEGER NOT NULL,
	departament varchar(50),
    username VARCHAR(50),
    parola VARCHAR(50),
CONSTRAINT FK_UNITATE_MEDICALE_UTILIZATOR FOREIGN KEY (idClinica) REFERENCES UnitateMedicala(id),
CONSTRAINT PK_Utilizator PRIMARY KEY (nr_contract,idClinica)
);

CREATE TABLE IF NOT EXISTS Angajat(
	nr_contract INTEGER NOT NULL,
    idClinica INTEGER NOT NULL,
	salariuNegociat FLOAT(5,2),
	nrOre INTEGER,
CONSTRAINT FK_UTILIZATOR_ANGAJAT FOREIGN KEY (nr_contract) REFERENCES Utilizator(nr_contract) ON DELETE CASCADE,
CONSTRAINT FK__UTILIZATOR_Angajat FOREIGN KEY (idClinica) REFERENCES Utilizator(idClinica)  ON DELETE CASCADE,
CONSTRAINT PK_Angajat PRIMARY KEY (nr_contract,idClinica)
);

CREATE TABLE IF NOT EXISTS AsistentMedical(
	nr_contract INTEGER,
	grad varchar(50),
	tip varchar(50),
CONSTRAINT FK_ANGAJAT_ASMED FOREIGN KEY(nr_contract) REFERENCES Angajat(nr_contract)  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Medic(
	idClinica INTEGER NOT NULL,
	nr_contract INTEGER PRIMARY KEY,
	codDeParafa INT,
	titlulStiintific VARCHAR(50),
	postDidactic VARCHAR(50),
	procent float(4,2),
CONSTRAINT FK_ANGAJAT_MEDIC FOREIGN KEY(nr_contract) REFERENCES Angajat(nr_contract)  ON DELETE CASCADE,
CONSTRAINT FK_UTILIZATOR_Medic FOREIGN KEY (idClinica) REFERENCES Angajat(idClinica)  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ServiciiPersonalizate(
	idServiciu INTEGER,
    pret FLOAT(6,2),
	durata TIME,
    nr_contract INTEGER,
CONSTRAINT FK_ServiciiPersonalizate_Servicii FOREIGN KEY (idServiciu) REFERENCES Servicii(idServiciu)  ON DELETE CASCADE,
CONSTRAINT FK_ServiciiPersonalizate_Medic FOREIGN KEY(nr_contract) REFERENCES Medic(nr_contract)  ON DELETE CASCADE,
CONSTRAINT PK_ServiciiPersonalizate PRIMARY KEY (idServiciu,nr_contract)
);

CREATE TABLE IF NOT EXISTS Competente(
	idMedic INTEGER,
    specialitatea VARCHAR(50),
	grad VARCHAR(50),
	competenta VARCHAR(50),
CONSTRAINT FK_Medic_Competente FOREIGN KEY(idMedic) REFERENCES Medic(nr_contract)  ON DELETE CASCADE,
CONSTRAINT PK_Competente PRIMARY KEY(idMedic,specialitatea,competenta)
);

CREATE TABLE IF NOT EXISTS ExceptieOrar(
	idExceptie Integer NOT NULL PRIMARY KEY auto_increment,
	nr_contract INTEGER NOT NULL,
	oraInceput TIME,
	oraSfarsit TIME,
	ziExceptionala DATE,
CONSTRAINT FK_ANGAJAT_ORAR FOREIGN KEY(nr_contract) REFERENCES Angajat(nr_contract)  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Concedii(
	nr_contract INTEGER NOT NULL,
	dataInceputConcediu DATE,
	dataSfarsitConcediu DATE,
CONSTRAINT FK_Angajat_Concedii FOREIGN KEY(nr_contract) REFERENCES Angajat(nr_contract)  ON DELETE CASCADE,
CONSTRAINT PK_Concedii PRIMARY KEY (nr_contract,dataInceputConcediu) 
);

CREATE TABLE IF NOT EXISTS Pacienti(
	idPacient INTEGER PRIMARY KEY NOT NULL auto_increment,
	nume VARCHAR(50),
	prenume VARCHAR(50),
	CNP VARCHAR(13),
	adresa VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS RaportConsultatie(
	idRaport INTEGER NOT NULL PRIMARY KEY auto_increment,
	idPacient INTEGER NOT NULL,
	nr_contract_medic INTEGER NOT NULL,
	nr_contract_medic_recomandare INTEGER NOT NULL,
	nr_contract_asistent INTEGER NOT NULL,
	dataConsultatie DATE,
	simptome VARCHAR(50),
	diagnostic VARCHAR(50),
	recomandari VARCHAR(100),
	Parafare INT,
CONSTRAINT FK_PACIENT_Consultatie FOREIGN KEY (idPacient) REFERENCES Pacienti(idPacient)  ON DELETE CASCADE,
CONSTRAINT FK_MEDIC_Consultatie FOREIGN KEY (nr_contract_medic) REFERENCES Medic(nr_contract)  ON DELETE CASCADE,
CONSTRAINT FK_ASISTENT_Consultatie FOREIGN KEY (nr_contract_asistent) REFERENCES AsistentMedical(nr_contract)  ON DELETE CASCADE,
CONSTRAINT FK_MEDIC_Consultatie_Recomandare FOREIGN KEY (nr_contract_medic_recomandare) REFERENCES Medic(nr_contract)  ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Programare(
	idProgramare INTEGER NOT NULL auto_increment,
    idPacient INTEGER NOT NULL,
	nr_contract_receptioner INTEGER NOT NULL,
    nr_contract_medic INTEGER NOT NULL,
    dataProgramarii DATE,
    oraProgramarii TIME,
    idCamera INTEGER NOT NULL,
    idServiciu INTEGER,  
CONSTRAINT FK_Angajat_Programare FOREIGN KEY (nr_contract_receptioner) REFERENCES Angajat(nr_contract)  ON DELETE CASCADE,
CONSTRAINT FK_Medic_Programare FOREIGN KEY (nr_contract_medic) REFERENCES Medic(nr_contract)  ON DELETE CASCADE,
CONSTRAINT FK_Pacient_Programare FOREIGN KEY (idPacient) REFERENCES Pacienti(idPacient)  ON DELETE CASCADE,
CONSTRAINT FK_Servicii_Programare FOREIGN KEY (idServiciu) REFERENCES Servicii(idServiciu)  ON DELETE CASCADE,
CONSTRAINT FK_Cabinete_Programare FOREIGN KEY(idCamera) REFERENCES cabinete(idCamera),
CONSTRAINT PK_Programare PRIMARY KEY (idProgramare,idServiciu)
);

CREATE TABLE IF NOT EXISTS RaportAnalize(
	idPacient INTEGER NOT NULL,
	dataAnalize DATE,
	tipAnalize VARCHAR(500),
	valoare NUMERIC,
	valoareReferinta NUMERIC,
	pozitiv boolean,
CONSTRAINT FK_Pacient_Analize FOREIGN KEY (idPacient) REFERENCES Pacienti(idPacient)  ON DELETE CASCADE
);

-- ------------------------------------------------------------------------------------------
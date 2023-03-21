DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `adaugaConcediu`(
	IN ziuaInceput DATE,
    IN ziuaSfarsit DATE,
    IN num VARCHAR(50),
    In prenum VARCHAR(50),
    IN functia VARCHAR(50)
)
BEGIN
	SET @id=(
		SELECT nr_contract
        From Utilizator
        Where Utilizator.nume=num AND Utilizator.prenume=prenum AND Utilizator.functie=functia
        LIMIT 1
    );
    INSERT INTO Concedii(nr_contract,dataInceputConcediu,dataSfarsitConcediu) VALUES
    (@id,ziuaInceput,ziuaSfarsit);

END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `modificaOrar`(
	IN ziua DATE,
    IN oraInc TIME,
    IN oraSf TIME,
    IN num VARCHAR(50),
    In prenum VARCHAR(50)
)
BEGIN
	SET @id=(
		SELECT nr_contract
        From Utilizator
        Where Utilizator.nume=num AND Utilizator.prenume=prenum
        LIMIT 1
    );
    if exists(Select * FROM ExceptieOrar where ExceptieOrar.nr_contract=@id and ExceptieOrar.ziExceptionala=ziua)=1 then
		update ExceptieOrar
        set oraInceput=oraInc,oraSfarsit=oraSf
        where nr_contract=@id and ziExceptionala=ziua;
    
    else
		INSERT INTO ExceptieOrar(nr_contract,oraInceput,oraSfarsit,ziExceptionala) VALUES
		(@id,oraInc,oraSf,ziua);
    end if;

END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `modificaConcediu`(
	IN ziuaInceput DATE,
    IN ziuaSfarsit DATE,
    IN num VARCHAR(50),
    In prenum VARCHAR(50),
    IN functia VARCHAR(50)
)
BEGIN
	SET @id=(
		SELECT nr_contract
        From Utilizator
        Where Utilizator.nume=num AND Utilizator.prenume=prenum AND Utilizator.functie=functia
        LIMIT 1
    );
    Update Concedii
    set dataInceputConcediu=ziuaInceput,dataSfarsitConcediu=ziuaSfarsit
    where nr_contract=@id;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `stergeConcediu`(
	IN ziuaInceput DATE,
    IN ziuaSfarsit DATE,
    IN num VARCHAR(50),
    In prenum VARCHAR(50),
    IN functia VARCHAR(50)
)
BEGIN
	SET @id=(
		SELECT nr_contract
        From Utilizator
        Where Utilizator.nume=num AND Utilizator.prenume=prenum AND Utilizator.functie=functia
        LIMIT 1
    );
    Delete from Concedii
    where nr_contract=@id;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `vizualizareConcediu`(
	IN num VARCHAR(50),
    In prenum VARCHAR(50)
)
BEGIN
	SET @id=(
		SELECT nr_contract
        From Utilizator
        Where Utilizator.nume=num AND Utilizator.prenume=prenum
        LIMIT 1
    );
    Select dataInceputConcediu AS PrimaZi,dataSfarsitConcediu AS UltimaZi
    FROM Concedii
    where @id=nr_contract;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `vizualizareOrar`(
	IN num VARCHAR(50),
    IN prenum VARCHAR(50),
    IN dataIntrare DATE
)
BEGIN
	SET @id=(
		SELECT nr_contract
        From Utilizator
        Where Utilizator.nume=num AND Utilizator.prenume=prenum
        LIMIT 1
    );
    if exists(SELECT* FROM Concedii where @id=nr_contract and dataIntrare>=dataInceputConcediu and dataIntrare<=dataSfarsitConcediu)=0 then
			if exists(Select * FROM ExceptieOrar where ExceptieOrar.nr_contract=@id and ExceptieOrar.ziExceptionala=dataIntrare)=1 then
				Select  DISTINCT UnitateMedicala.denumire,ziExceptionala as zi,oraInceput,oraSfarsit
					FROM ExceptieOrar
				inner join Angajat 
				on  ExceptieOrar.nr_contract=Angajat.nr_contract
				inner join Utilizator
				on  Angajat.nr_contract=Utilizator.nr_contract
				inner join UnitateMedicala
				on Utilizator.idClinica=UnitateMedicala.id
				where ExceptieOrar.nr_contract=@id and ExceptieOrar.ziExceptionala=dataIntrare;
			else 
				Select distinct UnitateMedicala.denumire,oraDeschidere as oraInceput,oraInchidere as oraSfarsit,zi
				From Utilizator
				inner join UnitateMedicala
				on Utilizator.idClinica=UnitateMedicala.id
				inner join Program
				on UnitateMedicala.id=Program.idClinica
				where Utilizator.nr_contract=@id and dayofweek(dataIntrare)=zi;
			end if;
    end if;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `orarDoctor`(
	IN idMedic INTEGER,
    IN dataIntrare DATE
)
BEGIN
	SELECT UnitateMedicala.denumire as Clinica,dataProgramarii as zi,oraProgramarii as inceputProgramare,TIME(oraProgramarii+ServiciiPersonalizate.durata) as sfarsitProgramare,Servicii.nume as DenumireServiciu,idCamera
    FROM Programare
    INNER JOIN Angajat ON
    Programare.nr_contract_receptioner=Angajat.nr_contract
    INNER JOIN Utilizator ON
    Angajat.nr_contract=Utilizator.nr_contract
    INNER JOIN UnitateMedicala ON
    Utilizator.idClinica=UnitateMedicala.id
    INNER JOIN Servicii ON
    Programare.idServiciu=Servicii.idServiciu
    INNER JOIN ServiciiPersonalizate ON
    Servicii.idServiciu=ServiciiPersonalizate.idServiciu
    WHERE nr_contract_medic=idMedic AND dataProgramarii=dataIntrare and ServiciiPersonalizate.nr_contract=idMedic
    -- ORDER BY oraProgramarii
    
    UNION
    
    SELECT UnitateMedicala.denumire as Clinica,dataProgramarii as zi,oraProgramarii as inceputProgramare,TIME(oraProgramarii+Servicii.durata) as sfarsitProgramare,Servicii.nume as DenumireServiciu,idCamera
    FROM Programare
    INNER JOIN Angajat ON
    Programare.nr_contract_receptioner=Angajat.nr_contract
    INNER JOIN Utilizator ON
    Angajat.nr_contract=Utilizator.nr_contract
    INNER JOIN UnitateMedicala ON
    Utilizator.idClinica=UnitateMedicala.id
    INNER JOIN Servicii ON
    Programare.idServiciu=Servicii.idServiciu
    LEFT OUTER JOIN ServiciiPersonalizate sp1 ON
    Servicii.idServiciu=sp1.idServiciu
    LEFT OUTER JOIN ServiciiPersonalizate ON
    Servicii.idServiciu=ServiciiPersonalizate.idServiciu
    WHERE nr_contract_medic=idMedic AND dataProgramarii=dataIntrare AND (ServiciiPersonalizate.idServiciu is null or ServiciiPersonalizate.nr_contract<>Programare.nr_contract_medic)
    ORDER BY inceputProgramare;
    
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `afisareSalariuNonDoctor`(
	IN id INTEGER
)
BEGIN
	SELECT salariuNegociat*nrOre as Salariu
    FROM Angajat
    Where nr_contract=id;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `profitSpecialitate`(
	IN specialitate VARCHAR(50)
)
BEGIN
	
    SET @venitSpecialitatePersonalizat=(
		SELECT SUM(ServiciiPersonalizate.pret)
		FROM Programare
		INNER JOIN Servicii
		ON Programare.idServiciu=Servicii.idServiciu
		INNER JOIN ServiciiPersonalizate
		ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
		WHERE Servicii.specialitate=specialitate and Programare.nr_contract_medic=ServiciiPersonalizate.nr_contract
        );
    
    SET @cheltuieliSpecialitatePersonalizat=(
		SELECT SUM(ServiciiPersonalizate.pret*Medic.procent/100)
        FROM Programare
        INNER JOIN Medic
        ON Programare.nr_contract_medic=Medic.nr_contract
		INNER JOIN Servicii
		ON Programare.idServiciu=Servicii.idServiciu
		INNER JOIN ServiciiPersonalizate
		ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
		WHERE Servicii.specialitate=specialitate and Programare.nr_contract_medic=ServiciiPersonalizate.nr_contract
        );
        
	SET @venitSpecialitate=(
		SELECT SUM(Servicii.pret)
		FROM Programare
		INNER JOIN Servicii
		ON Programare.idServiciu=Servicii.idServiciu
		INNER JOIN ServiciiPersonalizate
		ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
		WHERE Servicii.specialitate=specialitate and (ServiciiPersonalizate.idServiciu is null or Programare.nr_contract_medic<>ServiciiPersonalizate.nr_contract)
    );
    
    SET @cheltuieliSpecialitate=(
		SELECT SUM(Servicii.pret*Medic.procent/100)
		FROM Programare
        INNER JOIN Medic
        ON Programare.nr_contract_medic=Medic.nr_contract
		INNER JOIN Servicii
		ON Programare.idServiciu=Servicii.idServiciu
		INNER JOIN ServiciiPersonalizate
		ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
		WHERE Servicii.specialitate=specialitate and (ServiciiPersonalizate.idServiciu is null or Programare.nr_contract_medic<>ServiciiPersonalizate.nr_contract)
    );
    
    SELECT @venitSpecialitate AS Venit,
			@cheltuieliSpecialitate as Cheltuieli,
            @venitSpecialitatePersonalizat as VenitServiciiPersonalizate,
            @cheltuieliSpecialitatePersonalizat as CheltuieliServiciiPersonalizate;
    
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `profitClinica`(
	IN numeClinica varchar(50)
)
BEGIN
	SET @idClinica=(
		SELECT id
        FROM UnitateMedicala
        WHERE denumire=numeClinica
    );
    SET @venitClinicaPersonalizat=(
		SELECT SUM(ServiciiPersonalizate.pret)
		FROM Programare
		INNER JOIN Servicii
		ON Programare.idServiciu=Servicii.idServiciu
		INNER JOIN ServiciiPersonalizate
		ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
        INNER JOIN Angajat
        ON Programare.nr_contract_receptioner=Angajat.nr_contract
		WHERE Angajat.idClinica=@idClinica and Programare.nr_contract_medic=ServiciiPersonalizate.nr_contract
    );
    SET @cheltuieliClinicaPersonalizat=(
		SELECT SUM(ServiciiPersonalizate.pret*Medic.procent/100)
        FROM Programare
        INNER JOIN Medic
        ON Programare.nr_contract_medic=Medic.nr_contract
		INNER JOIN Servicii
		ON Programare.idServiciu=Servicii.idServiciu
		INNER JOIN ServiciiPersonalizate
		ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
        INNER JOIN Angajat
        ON Programare.nr_contract_receptioner=Angajat.nr_contract
		WHERE Angajat.idClinica=@idClinica  and Programare.nr_contract_medic=ServiciiPersonalizate.nr_contract
        );
	SET @cheltuieliSalarii=(
		SELECT SUM(Angajat.salariuNegociat*nrOre)
        FROM Angajat
        Where idClinica=@idClinica
    );
    SET @venitClinica=(
		SELECT SUM(Servicii.pret)
		FROM Programare
		INNER JOIN Servicii
		ON Programare.idServiciu=Servicii.idServiciu
		INNER JOIN ServiciiPersonalizate
		ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
		INNER JOIN Angajat
        ON Programare.nr_contract_receptioner=Angajat.nr_contract
		WHERE Angajat.idClinica=@idClinica and (ServiciiPersonalizate.idServiciu is null or Programare.nr_contract_medic<>ServiciiPersonalizate.nr_contract)
    );
    SET @cheltuieliProcente=(
		SELECT SUM(Servicii.pret*Medic.procent/100)
		FROM Programare
        INNER JOIN Medic
        ON Programare.nr_contract_medic=Medic.nr_contract
		INNER JOIN Servicii
		ON Programare.idServiciu=Servicii.idServiciu
		INNER JOIN ServiciiPersonalizate
		ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
		INNER JOIN Angajat
        ON Programare.nr_contract_receptioner=Angajat.nr_contract
		WHERE Angajat.idClinica=@idClinica and (ServiciiPersonalizate.idServiciu is null or Programare.nr_contract_medic<>ServiciiPersonalizate.nr_contract)
    );
    SELECT 
			@venitClinica as Venit,
			@cheltuieliProcente+@cheltuieliSalarii as Cheltuieli,
            @venitClinicaPersonalizat as VenitServiciiPersonalizate,
            @cheltuieliClinicaPersonalizat as CheltuieliServiciiPersonalizate;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `AfisareSalariuDoctor`(
	IN id INTEGER,
    In luna INTEGER
)
BEGIN
	SET @salariuFaraComision=(
		SELECT SUM(salariuNegociat*nrOre)
        FROM Angajat
		WHERE nr_contract=id
    );
    SET @comisioaneSpeciale=(
		SELECT SUM(Medic.procent*ServiciiPersonalizate.pret)/100
        FROM Programare
        INNER JOIN Medic
        ON Programare.nr_contract_medic=Medic.nr_contract
        INNER JOIN Servicii
        ON Programare.idServiciu=Servicii.idServiciu
        INNER JOIN ServiciiPersonalizate
        ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
        where MONTH(Programare.dataProgramarii)=luna and Programare.nr_contract_medic=id and ServiciiPersonalizate.nr_contract=id
    );
    
    SET @comisioane=(
		SELECT SUM(procent*Servicii.pret)/100
        FROM Programare
        INNER JOIN Medic
        ON Programare.nr_contract_medic=Medic.nr_contract
        INNER JOIN Servicii
        ON Programare.idServiciu=Servicii.idServiciu
        LEFT OUTER JOIN ServiciiPersonalizate
        ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
        where MONTH(Programare.dataProgramarii)=luna and Programare.nr_contract_medic=id and (ServiciiPersonalizate.idServiciu is null or ServiciiPersonalizate.nr_contract<>id)
    );
    SELECT @salariuFaraComision as SalariuDeBaza,@comisioane as ComisioneServicii,@comisioaneSpeciale as ComisioneServiciiPersonalizate;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `parafareRaport`(
	IN id INTEGER,
    IN idMedic INTEGER
)
BEGIN
	SET @parafa=(
		SELECT codDeParafa
        FROM medic
        WHERE idMedic=id
        LIMIT 1
    );
	UPDATE RaportConsultatie
    SET Parafare=@parafa
    WHERE idRaport=id;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `creareRaportMedical`(
	IN numePacient varchar(50),
    IN prenumePacient varchar(50),
    IN numeMedic varchar(50),
    IN prenumeMedic varchar(50),
    IN numeMedicRecomandare varchar(50),
    IN prenumeMedicRecomandare varchar(50),
    IN asis INTEGER,
    IN dataConsultatie DATE
)
BEGIN
	SET @idDoctor=(
		SELECT nr_contract
        FROM Utilizator
        WHERE nume=numeMedic and prenume=prenumeMedic
        LIMIT 1
    );
    SET @idDoctor2=(
		SELECT nr_contract
        FROM Utilizator
        WHERE nume=numeMedicRecomandare and prenume=prenumeMedicRecomandare
        LIMIT 1
    );
    SET @idAs=asis;
    SET @idPacient=(
		SELECT idPacient
        FROM pacienti
        WHERE nume=numePacient and prenume=prenumePacient
    );
    INSERT INTO RaportConsultatie(idPacient,nr_contract_medic,nr_contract_asistent,dataConsultatie,nr_contract_medic_recomandare) VALUES
    (@idPacient,@idDoctor,@idAs,dataConsultatie,@idDoctor2);
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRaportMedical`(
	IN idRap INTEGER,
    IN simpt VARCHAR(50),
    IN diag VARCHAR(50),
    IN recom VARCHAR(100)
)
BEGIN
	if (SELECT RaportConsultatie.Parafare FROM RaportConsultatie WHERE RaportConsultatie.idRaport=idRap) is null then
	UPDATE RaportConsultatie
    SET simptome=simpt,diagnostic=diag,recomandari=recom
    WHERE idRaport=idRap;
    end if;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `BonFiscal`(
	IN nume VARCHAR(50),
    IN prenume VARCHAR(50),
    IN dataProgramarii DATE,
    IN nr_contract_medic INTEGER
)
BEGIN
	SET @idPacient=(
		Select idPacient
        FROM Pacienti
        Where Pacienti.nume=nume and Pacienti.prenume=prenume
    );
	SELECT Servicii.nume as NumeServiciu, Servicii.pret as Pret
    FROM Programare
    INNER JOIN Servicii
    ON Programare.idServiciu=Servicii.idServiciu
    LEFT OUTER JOIN ServiciiPersonalizate
    ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
    WHERE Programare.idPacient=@idPacient and Programare.dataProgramarii=dataProgramarii and (ServiciiPersonalizate.idServiciu is null or ServiciiPersonalizate.nr_contract<>nr_contract_medic)
    UNION ALL
	SELECT Servicii.nume as NumeServiciu, Servicii.pret as Pret
    FROM Programare
    INNER JOIN Servicii
    ON Programare.idServiciu=Servicii.idServiciu
    INNER JOIN ServiciiPersonalizate
    ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
    WHERE Programare.idPacient=@idPacient and Programare.dataProgramarii=dataProgramarii and ServiciiPersonalizate.nr_contract=nr_contract_medic;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `vizualizareIstoric`(
	IN nume VARCHAR(50),
    IN prenume VARCHAR(50)
)
BEGIN
	SET @idPacient=(
		Select idPacient
        FROM Pacienti
        Where Pacienti.nume=nume and Pacienti.prenume=prenume
    );
    SELECT idRaport as numarRaport,Parafare,dataConsultatie,simptome,diagnostic,recomandari
    FROM RaportConsultatie
    Where idPacient=@idPacient;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `adaugaAnalize`(
	IN nume VARCHAR(50),
    IN prenume VARCHAR(50),
    IN dataAnaliz DATE,
	IN tip VARCHAR(50),
    IN val DECIMAL,
    IN ref DECIMAL,
    IN poz TINYINT
)
BEGIN
	SET @idPacient=(
		Select idPacient
        FROM Pacienti
        Where Pacienti.nume=nume and Pacienti.prenume=prenume
    );
    INSERT INTO raportanalize VALUES(
		@idPacient,
        dataAnaliz,
        tip,
        val,
        ref,
        poz
    );
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `vizualizareAnalize`(
	IN nume VARCHAR(50),
    IN prenume VARCHAR(50)
)
BEGIN
	SET @idPacient=(
		Select idPacient
        FROM Pacienti
        Where Pacienti.nume=nume and Pacienti.prenume=prenume
    );
    SELECT dataAnalize,tipAnalize,valoare,valoareReferinta,pozitiv
    FROM raportanalize
    WHERE idPacient=@idPacient;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `createUser`(
	In nr_contract integer,
	IN nume VARCHAR(50),
    IN prenume VARCHAR(50),
    IN CNP VARCHAR(13),
    IN telefon VARCHAR(10),
    In email VARCHAR(50),
    IN IBAN VARCHAR(50),
    IN dataAngajarii DATE,
    IN departament VARCHAR(50),
    IN functie VARCHAR(50),
    IN adresa VARCHAR(50),
    IN idAdmin INTEGER
)
BEGIN
	SET @idClinica=(
		SELECT idClinica
        From Utilizator
        where  Utilizator.nr_contract=idAdmin
        LIMIT 1
    );
    INSERT INTO Utilizator(idClinica,nr_contract,functie,departament,nume,prenume,IBAN,CNP,email,adresa,telefon,dataAngajarii) VALUES(
        @idClinica,nr_contract,functie,departament,nume,prenume,IBAN,CNP,email,adresa,telefon,dataAngajarii
    ); 
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUser`(
	IN nr_contract INTEGER
)
BEGIN
	DELETE FROM Utilizator
    WHERE Utilizator.nr_contract=nr_contract;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUser`(
	In nr_contract integer,
	IN nume VARCHAR(50),
    IN prenume VARCHAR(50),
    IN telefon VARCHAR(10),
    In email VARCHAR(50),
    IN IBAN VARCHAR(50),
	IN adresa VARCHAR(50)
)
BEGIN
	Update Utilizator
    SET Utilizator.nume=nume,Utilizator.prenume=prenume,Utilizator.telefon=telefon,Utilizator.email=email,Utilizator.IBAN=IBAN,Utilizator.adresa=adresa
    WHERE Utilizator.nr_contract=nr_contract;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `OrarNonDoctor`(
	IN nr_contract INTEGER,
    IN dataIntrare DATE
)
BEGIN
	SET @id=nr_contract;
    if exists(SELECT* FROM Concedii where @id=nr_contract and dataIntrare>=dataInceputConcediu and dataIntrare<=dataSfarsitConcediu)=0 then
			if exists(Select * FROM ExceptieOrar where ExceptieOrar.nr_contract=@id and ExceptieOrar.ziExceptionala=dataIntrare)=1 then
				Select  DISTINCT UnitateMedicala.denumire,ziExceptionala as zi,oraInceput,oraSfarsit
					FROM ExceptieOrar
				inner join Angajat 
				on  ExceptieOrar.nr_contract=Angajat.nr_contract
				inner join Utilizator
				on  Angajat.nr_contract=Utilizator.nr_contract
				inner join UnitateMedicala
				on Utilizator.idClinica=UnitateMedicala.id
				where ExceptieOrar.nr_contract=@id and ExceptieOrar.ziExceptionala=dataIntrare;
			else 
				Select distinct UnitateMedicala.denumire,oraDeschidere as oraInceput,oraInchidere as oraSfarsit,zi
				From Utilizator
				inner join UnitateMedicala
				on Utilizator.idClinica=UnitateMedicala.id
				inner join Program
				on UnitateMedicala.id=Program.idClinica
				where Utilizator.nr_contract=@id and dayofweek(dataIntrare)=zi;
			end if;
    end if;
END//
DELIMITER ;

DROP procedure IF EXISTS `proiectreteaclinica`.`parafareRaport`;

DELIMITER $$
USE `proiectreteaclinica`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `parafareRaport`(
	IN id INTEGER,
    IN idMedic INTEGER
)
BEGIN
	SET @parafa=(
		SELECT medic.codDeParafa
        FROM medic
        WHERE idMedic=medic.nr_contract
        LIMIT 1
    );
	UPDATE RaportConsultatie
    SET Parafare=@parafa
    WHERE idRaport=id;
END$$

DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `orarDinHR`(
    IN num VARCHAR(50),
    In prenum VARCHAR(50),
	IN dataIntrare DATE
)
BEGIN
	SET @id=(
		SELECT nr_contract
        From Utilizator
        Where Utilizator.nume=num AND Utilizator.prenume=prenum
        LIMIT 1
    );
    if exists(SELECT* FROM Concedii where @id=nr_contract and dataIntrare>=dataInceputConcediu and dataIntrare<=dataSfarsitConcediu)=0 then
			if exists(Select * FROM ExceptieOrar where ExceptieOrar.nr_contract=@id and ExceptieOrar.ziExceptionala=dataIntrare)=1 then
				Select  DISTINCT UnitateMedicala.denumire,ziExceptionala as zi,oraInceput,oraSfarsit
					FROM ExceptieOrar
				inner join Angajat 
				on  ExceptieOrar.nr_contract=Angajat.nr_contract
				inner join Utilizator
				on  Angajat.nr_contract=Utilizator.nr_contract
				inner join UnitateMedicala
				on Utilizator.idClinica=UnitateMedicala.id
				where ExceptieOrar.nr_contract=@id and ExceptieOrar.ziExceptionala=dataIntrare;
			else 
				Select distinct UnitateMedicala.denumire,oraDeschidere as oraInceput,oraInchidere as oraSfarsit,zi
				From Utilizator
				inner join UnitateMedicala
				on Utilizator.idClinica=UnitateMedicala.id
				inner join Program
				on UnitateMedicala.id=Program.idClinica
				where Utilizator.nr_contract=@id and dayofweek(dataIntrare)=zi;
			end if;
    end if;
END//
DELIMITER ;


DROP procedure IF EXISTS `proiectreteaclinica`.`profitMedic`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `profitMedic`(
	IN id INTEGER
)
BEGIN
	SET @salariuFaraComision=(
		SELECT SUM(salariuNegociat*nrOre)
        FROM Angajat
		WHERE nr_contract=id
    );
    SET @comisioaneSpeciale=(
		SELECT SUM(Medic.procent*ServiciiPersonalizate.pret)/100
        FROM Programare
        INNER JOIN Medic
        ON Programare.nr_contract_medic=Medic.nr_contract
        INNER JOIN Servicii
        ON Programare.idServiciu=Servicii.idServiciu
        INNER JOIN ServiciiPersonalizate
        ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
        where Programare.nr_contract_medic=id and ServiciiPersonalizate.nr_contract=id
    );
    
    SET @comisioane=(
		SELECT SUM(procent*Servicii.pret)/100
        FROM Programare
        INNER JOIN Medic
        ON Programare.nr_contract_medic=Medic.nr_contract
        INNER JOIN Servicii
        ON Programare.idServiciu=Servicii.idServiciu
        LEFT OUTER JOIN ServiciiPersonalizate
        ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
        where Programare.nr_contract_medic=id and (ServiciiPersonalizate.idServiciu is null or ServiciiPersonalizate.nr_contract<>id)
    );
    SET @profitSpeciale=(
		SELECT SUM(ServiciiPersonalizate.pret)
        FROM Programare
        INNER JOIN Medic
        ON Programare.nr_contract_medic=Medic.nr_contract
        INNER JOIN Servicii
        ON Programare.idServiciu=Servicii.idServiciu
        INNER JOIN ServiciiPersonalizate
        ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
        where Programare.nr_contract_medic=id and ServiciiPersonalizate.nr_contract=id
    );
    
    SET @profitSimple=(
		SELECT SUM(Servicii.pret)
        FROM Programare
        INNER JOIN Medic
        ON Programare.nr_contract_medic=Medic.nr_contract
        INNER JOIN Servicii
        ON Programare.idServiciu=Servicii.idServiciu
        LEFT OUTER JOIN ServiciiPersonalizate
        ON Servicii.idServiciu=ServiciiPersonalizate.idServiciu
        where Programare.nr_contract_medic=id and (ServiciiPersonalizate.idServiciu is null or ServiciiPersonalizate.nr_contract<>id)
    );
    SELECT @profitSpeciale as VenitServiciiPersonalizate,@profitSimple as VenitServiciiNormale,@salariuFaraComision as CheltuieliSalariuLunar,@comisioane as ComisioneServicii,@comisioaneSpeciale as ComisioneServiciiPersonalizate;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Programare`(
	IN numeP VARCHAR(50),
    IN prenumeP VARCHAR(50),
    IN numeD VARCHAR(50),
    IN prenumeD VARCHAR(50),
    IN serviciu VARCHAR(50),
    IN dataP DATE,
    IN oraP TIME,
    In recept INTEGER
)
BEGIN
	SET @idClinica=(
		SELECT idClinica
        FROM utilizator
        WHERE utilizator.nr_contract=recept
    );
	SET @idServiciu=(
		Select servicii.idServiciu
        From servicii
        where servicii.nume=serviciu
        LIMIT 1
    );
	SET @idPacient=(
		Select idPacient
        FROM Pacienti
        Where Pacienti.nume=numeP and Pacienti.prenume=prenumeP
		LIMIT 1
    );
    SET @idDoctor=(
		SELECT nr_contract
        FROM Utilizator
        WHERE nume=numeD and prenume=prenumeD
        LIMIT 1
    );
    SET @oraS=(
		SELECT TIME(oraP+ServiciiPersonalizate.durata)
        FROM Servicii
        INNER JOIN ServiciiPersonalizate ON
		Servicii.idServiciu=ServiciiPersonalizate.idServiciu
        where Servicii.idServiciu=@idServiciu and ServiciiPersonalizate.nr_contract=@idDoctor
        
        UNION
        
        SELECT TIME(oraP+Servicii.durata)
        FROM Servicii
        LEFT OUTER JOIN ServiciiPersonalizate ON
	 	 Servicii.idServiciu=ServiciiPersonalizate.idServiciu
        where Servicii.idServiciu=@idServiciu and ServiciiPersonalizate.idServiciu is null or ServiciiPersonalizate.nr_contract<>@idDoctor
    );
    if exists(SELECT Cabinete.idCamera
        FROM Cabinete
		LEFT OUTER JOIN Programare ON
        Cabinete.idCamera=Programare.idCamera
        AND Programare.dataProgramarii=dataP 
        INNER JOIN Servicii ON
		Programare.idServiciu=Servicii.idServiciu
        inner join serviciipersonalizate on
		servicii.idServiciu=serviciipersonalizate.idServiciu
        WHERE @idClinica=Cabinete.idClinica AND @idServiciu=Cabinete.idServiciu and 
        Programare.idCamera is null or (
        programare.oraProgramarii not between oraP and @oraS and
		programare.oraProgramarii+serviciipersonalizate.durata not between oraP and @oraS))=1 then
    SET @idCamera=(
		SELECT Cabinete.idCamera
        FROM Cabinete
		LEFT OUTER JOIN Programare ON
        Cabinete.idCamera=Programare.idCamera
		AND Programare.dataProgramarii=dataP
        INNER JOIN Servicii ON
		Programare.idServiciu=Servicii.idServiciu
        inner join serviciipersonalizate on
		servicii.idServiciu=serviciipersonalizate.idServiciu
        WHERE @idClinica=Cabinete.idClinica AND @idServiciu=Cabinete.idServiciu and 
        Programare.idCamera is null or (
        programare.oraProgramarii not between oraP and @oraS and
		programare.oraProgramarii+serviciipersonalizate.durata not between oraP and @oraS)
        LIMIT 1
    );
    else if exists(SELECT Cabinete.idCamera
        FROM Cabinete
		LEFT OUTER JOIN Programare ON
        Cabinete.idCamera=Programare.idCamera
        AND Programare.dataProgramarii=dataP
        INNER JOIN Servicii ON
		Programare.idServiciu=Servicii.idServiciu
        WHERE @idClinica=Cabinete.idClinica AND @idServiciu=Cabinete.idServiciu and 
        Programare.idCamera is null or (
        programare.oraProgramarii not between oraP and @oraS and
		programare.oraProgramarii+servicii.durata not between oraP and @oraS)
        )=1 then
    SET @idCamera=(
		SELECT Cabinete.idCamera
        FROM Cabinete
		LEFT OUTER JOIN Programare ON
        Cabinete.idCamera=Programare.idCamera
        AND Programare.dataProgramarii=dataP
        INNER JOIN Servicii ON
		Programare.idServiciu=Servicii.idServiciu
        WHERE @idClinica=Cabinete.idClinica AND @idServiciu=Cabinete.idServiciu and 
        Programare.idCamera is null or (
        programare.oraProgramarii not between oraP and @oraS and
		programare.oraProgramarii+servicii.durata not between oraP and @oraS)
        LIMIT 1
    );
		else
	SET @idCamera=(
        SELECT Cabinete.idCamera
        FROM Cabinete 
        WHERE @idServiciu=Cabinete.idServiciu AND @idClinica=Cabinete.idClinica
        LIMIT 1
        );
		end if;
    end if;
    
    SELECT Cabinete.idCamera
        FROM Cabinete
        WHERE @idServiciu=Cabinete.idServiciu AND @idClinica=Cabinete.idClinica
        LIMIT 1;
    
    -- verificare inafara concediului
    if exists(
    Select nr_contract
    from concedii
    where dataP between concedii.dataInceputConcediu and concedii.dataSfarsitConcediu
    )=0 then
    -- verificare zi exceptionala
		if exists(
    SELECT idExceptie
    From exceptieorar
    Where exceptieorar.nr_contract=@idDoctor and exceptieorar.ziExceptionala=dataP)=1 then
    
    SET @oraInceputZi=(
    SELECT oraInceput
    From exceptieorar
    Where exceptieorar.nr_contract=@idDoctor and exceptieorar.ziExceptionala=dataP
    );
    SET @oraSfarsitZi=(
    SELECT oraSfarsit
    From exceptieorar
    Where exceptieorar.nr_contract=@idDoctor and exceptieorar.ziExceptionala=dataP
    );
			if (oraP between @oraInceputZi and @oraSfarsitZi) and (@oraS between @oraInceputZi and @oraSfarsitZi) then 
    -- algoritm verificare daca doctorul are vreo programare care se intercaleaza cu cea care se face
				if (
    SELECT idProgramare
    FROM Programare
    INNER JOIN Servicii ON
    Programare.idServiciu=Servicii.idServiciu
    INNER JOIN ServiciiPersonalizate ON
    Servicii.idServiciu=ServiciiPersonalizate.idServiciu
    WHERE nr_contract_medic=@idDoctor AND 
		Programare.dataProgramarii=dataP AND
        ServiciiPersonalizate.nr_contract=@idDoctor AND
        (oraP between Programare.oraProgramarii and Programare.oraProgramarii+ServiciiPersonalizate.durata or
        @oraS between Programare.oraProgramarii and Programare.oraProgramarii+ServiciiPersonalizate.durata
        )
        
	UNION
    
    SELECT idProgramare
    FROM Programare
    INNER JOIN Servicii ON
    Programare.idServiciu=Servicii.idServiciu
    INNER JOIN ServiciiPersonalizate ON
    Servicii.idServiciu=ServiciiPersonalizate.idServiciu
    WHERE nr_contract_medic=@idDoctor AND 
		Programare.dataProgramarii=dataP AND
        (ServiciiPersonalizate.idServiciu is null or ServiciiPersonalizate.nr_contract<>@idDoctor) AND
        (oraP between Programare.oraProgramarii and Programare.oraProgramarii+ServiciiPersonalizate.durata or
        @oraS between Programare.oraProgramarii and Programare.oraProgramarii+ServiciiPersonalizate.durata
        )
	) is null then
        
        
	INSERT INTO Programare(idPacient,nr_contract_receptioner,nr_contract_medic,dataProgramarii,oraProgramarii,idServiciu,idCamera) VALUES
	(@idPacient,recept,@idDoctor,dataP,oraP,@idServiciu,@idCamera);
				end if;
			end if;
		else
			if (
    SELECT idProgramare
    FROM Programare
    INNER JOIN Servicii ON
    Programare.idServiciu=Servicii.idServiciu
    INNER JOIN ServiciiPersonalizate ON
    Servicii.idServiciu=ServiciiPersonalizate.idServiciu
    WHERE nr_contract_medic=@idDoctor AND 
		Programare.dataProgramarii=dataP AND
        ServiciiPersonalizate.nr_contract=@idDoctor AND
        (oraP between Programare.oraProgramarii and Programare.oraProgramarii+ServiciiPersonalizate.durata or
        @oraS between Programare.oraProgramarii and Programare.oraProgramarii+ServiciiPersonalizate.durata
        )
        
	UNION
    
    SELECT idProgramare
    FROM Programare
    INNER JOIN Servicii ON
    Programare.idServiciu=Servicii.idServiciu
    INNER JOIN ServiciiPersonalizate ON
    Servicii.idServiciu=ServiciiPersonalizate.idServiciu
    WHERE nr_contract_medic=@idDoctor AND 
		Programare.dataProgramarii=dataP AND
        (ServiciiPersonalizate.idServiciu is null or ServiciiPersonalizate.nr_contract<>@idDoctor) AND
        (oraP between Programare.oraProgramarii and Programare.oraProgramarii+ServiciiPersonalizate.durata or
        @oraS between Programare.oraProgramarii and Programare.oraProgramarii+ServiciiPersonalizate.durata
        )
	) is null then
        
     
	INSERT INTO Programare(idPacient,nr_contract_receptioner,nr_contract_medic,dataProgramarii,oraProgramarii,idServiciu,idCamera) VALUES
	(@idPacient,recept,@idDoctor,dataP,oraP,@idServiciu,@idCamera);
			end if;
		end if;
    end if;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `adaugaPacient`(
	IN nume VARCHAR(50),
    IN prenume VARCHAR(50),
    IN CNP VARCHAR(13),
    IN adresa VARCHAR(50)
)
BEGIN
	if exists(
		SELECT idPacient
        FROM Pacienti
        WHERE Pacienti.CNP=CNP
    )=0 then 
		INSERT INTO Pacienti(nume,prenume,CNP,adresa) VALUES
        (
        nume,prenume,CNP,adresa
        );
    end if;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `programariReceptioner`(
	IN id INTEGER,
    IN dataIntrare date
)
BEGIN
	SET @id=(
		SELECT idClinica
        FROM utilizator
        WHERE id=utilizator.nr_contract
    );

	SELECT UnitateMedicala.denumire as Clinica,dataProgramarii as zi,oraProgramarii as inceputProgramare,TIME(oraProgramarii+ServiciiPersonalizate.durata) as sfarsitProgramare,Servicii.nume as DenumireServiciu,idCamera
    FROM Programare
    INNER JOIN Angajat ON
    Programare.nr_contract_receptioner=Angajat.nr_contract
    INNER JOIN Utilizator ON
    Angajat.nr_contract=Utilizator.nr_contract
    INNER JOIN UnitateMedicala ON
    Utilizator.idClinica=UnitateMedicala.id
    INNER JOIN Servicii ON
    Programare.idServiciu=Servicii.idServiciu
    INNER JOIN ServiciiPersonalizate ON
    Servicii.idServiciu=ServiciiPersonalizate.idServiciu
    WHERE Utilizator.idClinica=@id AND dataProgramarii=dataIntrare and ServiciiPersonalizate.nr_contract=Programare.nr_contract_medic
    -- ORDER BY oraProgramarii
    
    UNION
    
    SELECT UnitateMedicala.denumire as Clinica,dataProgramarii as zi,oraProgramarii as inceputProgramare,TIME(oraProgramarii+Servicii.durata) as sfarsitProgramare,Servicii.nume as DenumireServiciu,idCamera
    FROM Programare
    INNER JOIN Angajat ON
    Programare.nr_contract_receptioner=Angajat.nr_contract
    INNER JOIN Utilizator ON
    Angajat.nr_contract=Utilizator.nr_contract
    INNER JOIN UnitateMedicala ON
    Utilizator.idClinica=UnitateMedicala.id
    INNER JOIN Servicii ON
    Programare.idServiciu=Servicii.idServiciu
    LEFT OUTER JOIN ServiciiPersonalizate sp1 ON
    Servicii.idServiciu=sp1.idServiciu
    LEFT OUTER JOIN ServiciiPersonalizate ON
    Servicii.idServiciu=ServiciiPersonalizate.idServiciu
    WHERE Utilizator.idClinica=@id AND dataProgramarii=dataIntrare AND (ServiciiPersonalizate.idServiciu is null or ServiciiPersonalizate.nr_contract<>Programare.nr_contract_medic)
    ORDER BY inceputProgramare;
END//
DELIMITER ;
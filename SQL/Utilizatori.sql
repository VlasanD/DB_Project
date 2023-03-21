CREATE USER IF NOT EXISTS resurseumane@localhost
IDENTIFIED BY 'root';

-- date personale
GRANT SELECT 
ON proiectreteaclinica.utilizator
TO resurseumane@localhost;

GRANT SELECT, INSERT, UPDATE, DELETE 
ON proiectreteaclinica.serviciipersonalizate
TO resurseumane@localhost;

-- salariu
GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.afisareSalariuNonDoctor
TO resurseumane@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.vizualizareConcediu
TO resurseumane@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.modificaOrar
TO resurseumane@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.orarDinHR
TO resurseumane@localhost;

-- ----------------------------------------------------------------------

CREATE USER IF NOT EXISTS financiar@localhost
IDENTIFIED BY 'root';

-- date personale
GRANT SELECT 
ON proiectreteaclinica.utilizator
TO financiar@localhost;

-- salariu
GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.afisareSalariuNonDoctor
TO financiar@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.vizualizareConcediu
TO financiar@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.orarDinHR
TO financiar@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.profitMedic
TO financiar@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.profitClinica
TO financiar@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.profitSpecialitate
TO financiar@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.afisareSalariuNonDoctor
TO financiar@localhost;

-- ------------------------------------------------------------

CREATE USER IF NOT EXISTS doctor@localhost
IDENTIFIED BY 'root';

GRANT SELECT 
ON proiectreteaclinica.utilizator
TO doctor@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.profitMedic
TO doctor@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.AfisareSalariuDoctor
TO doctor@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.vizualizareAnalize
TO doctor@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.parafareRaport
TO doctor@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.updateRaportMedical
TO doctor@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.vizualizareIstoric
TO doctor@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.orarDoctor
TO doctor@localhost;

-- --------------------------------------------------------
CREATE USER IF NOT EXISTS asistent@localhost
IDENTIFIED BY 'root';

GRANT SELECT 
ON proiectreteaclinica.utilizator
TO asistent@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.afisareSalariuNonDoctor
TO asistent@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.vizualizareAnalize
TO asistent@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.vizualizareIstoric
TO asistent@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.creareRaportMedical
TO asistent@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.adaugaAnalize
TO asistent@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.OrarNonDoctor
TO asistent@localhost;

-- ------------------------------------------------------
CREATE USER IF NOT EXISTS receptionist@localhost
IDENTIFIED BY 'root';

GRANT SELECT 
ON proiectreteaclinica.utilizator
TO receptionist@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.afisareSalariuNonDoctor
TO receptionist@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.OrarNonDoctor
TO receptionist@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.BonFiscal
TO receptionist@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.Programare
TO receptionist@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.adaugaPacient
TO receptionist@localhost;

GRANT EXECUTE
ON PROCEDURE proiectreteaclinica.programariReceptioner
TO receptionist@localhost;
-- ***************************************************************
-- * File Name:                  dbs_query.sql                   *
-- * File Creator:               Knolle                          *
-- * CreationDate:               06. December 2016               *
-- *                                                             *
-- * <ChangeLogDate>             <ChangeLogText>                 *
-- ***************************************************************
--
-- ***************************************************************
-- * Datenbanksysteme WS 2016/2017
-- * Uebungen 6 und 7 
--
-- ***************************************************************
-- * SQL*plus Job Control Section
--
set 	echo 		on
set 	linesize 	128
set 	pagesize 	50
--
-- Spaltenformatierung (nur fuer die Ausgabe)
--
column 	lv_name     format A35 WORD_WRAPPED
column 	beruf       format A30 WORD_WRAPPED
column 	fb_name     format A35 WORD_WRAPPED
column 	institution format A20 WORD_WRAPPED
column 	strasse     format A20 WORD_WRAPPED
column 	ort         format A20 WORD_WRAPPED
column 	lv_name     format A30 WORD_WRAPPED
column 	titel       format A20 WORD_WRAPPED
column 	vorname     format A20 WORD_WRAPPED
column 	ort         format A20 WORD_WRAPPED
column 	fachgebiet  format A20 WORD_WRAPPED
column 	pers_nr     format A15 WORD_WRAPPED
column 	ho_name     format A20 WORD_WRAPPED
--
-- Protokolldatei
--
spool ./dbs_query.log
--
-- Systemdatum
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
-- ***************************************************************
-- * S Q L - B E I S P I E L A N F R A G E N
--
-- 	1	Projektion
--
-- 	1.1	Auswaehlen von Eigenschaften (Spalten)
--
--	Wie lauten die Namen aller Lehrveranstaltungen?
--
SELECT lv_name
FROM dbs_tab_lehrveranstaltung
;
--
--	Welche Berufe haben die Mitarbeiter und wie hoch ist ihr 
--	Gehalt? 
SELECT	'Beruf: ', beruf,
		'Gehalt: ', gehalt 
FROM dbs_tab_mitarbeiter
;
--
--	Wie lauten die Daten der Tabelle 'Professor'?
--
SELECT *
FROM dbs_tab_professor
;
--
-- 	1.2	Umbenennen von Spalten
--
--	Die Daten der Tabelle 'Gebaeude' sollen ausgegeben werden, 
-- 	wobei die Spalte 'haus_nr' in 'Hausnummer' umzubenennen ist.
--
SELECT Gebaeude,
		strasse,
	haus_nr AS Hausnummer
FROM dbs_tab_gebaeude
;
--
-- 	1.3	Berechnen bzw. Ableiten von neuen Eigenschaften (Spalten)
--
--	Die Orte sollen mit der Landeskennung '(D)' ausgegeben werden 
--	(kuenstliche Spalte mit konstantem Wert).
--
SELECT DISTINCT ort, '(D)'
FROM dbs_tab_anschrift
;
--
--	Zu jeder Personalnummer soll der Stundenlohn ausgegeben und als 
--	solcher benannt werden (Monat = 20 Tage zu je 8 Stunden).
--
SELECT pers_nr, 'Stundenlohn', gehalt / (20 * 8)
FROM dbs_tab_mitarbeiter
;
--
--	2	Selektion
--
--	2.1	Ausblenden identischer Zeilen
--
--	In welchen unterschiedlichen Orten leben die 
--	Hochschulangehoerigen?
--
SELECT	DISTINCT ort
From dbs_tab_anschrift
;
--
--	Zu welchen Zeiten wird in der Woche gelehrt?
--
SELECT DISTINCT tag, zeit
FROM dbs_tab_lv_ort
;
--
--	2.2	Sortierung der Ausgabe
--
--	Die Personalnummern sind absteigend nach ihrem zugehoerigen 
--	Gehalt auszugeben.
--
SELECT pers_nr, gehalt
FROM dbs_tab_mitarbeiter
ORDER BY gehalt DESC
;
--
--	Die Orte und Strassen sind aufsteigend sortiert nach Ort und bei 
--	gleichen Orten dann absteigend nach Strasse auszugeben.
--
SELECT DISTINCT ort, strasse
FROM dbs_tab_anschrift
ORDER BY ort ASC, strasse DESC
;
--
--	2.3	Auswahl bestimmter Tupel (Zeilen, Informationstraeger)
--
--	Welche Gebaeude werden am Freitag belegt?
--
SELECT DISTINCT Gebaeude
FROM dbs_tab_lv_ort
WHERE tag = 'Fr'
;
--
--	Wie lauten die Personalnummern derjenigen Mitarbeiter, die mehr 
--	als 20 � in der Stunde verdienen?
--
SELECT pers_nr
FROM dbs_tab_mitarbeiter
WHERE gehalt / (20*8) > 20 
;
--
--	2.4	Auswahl von Tupeln, die mehreren Bedingungen genuegen
--
--	Es sollen die Nummern der Lehrveranstaltungen ausgegeben 
--	werden, die im Gebaeude 'C' oder Dienstags abgehalten werden.
--
SELECT DISTINCT lv_nr
FROM dbs_tab_lv_ort
WHERE Gebaeude = 'C'
OR tag = 'Di'
;
--
--	Welche Mitarbeiter des Fachbereichs 2 verdienen mehr als 
--	5.000 �?
--
SELECT pers_nr
FROM dbs_tab_mitarbeiter
WHERE gehalt > 5000
AND fb_nr = '2'
;
--
--	2.5	Vergleich mit einem Muster
--
--	Wie viele Hochschulangehoerige mit einem Namen, der wie 'Meier' 
--	ausgesprochen wird, werden im System verwaltet?
--
SELECT ho_name, ho_nr
FROM dbs_tab_hochschulangehoeriger
WHERE ho_name LIKE 'M__er'
;
--
--	Welche unterschiedlichen Vornamen, die mit 'M' beginnen, 
--	existieren im System?
--
SELECT DISTINCT vorname
FROM dbs_tab_vorname
WHERE vorname LIKE 'M%'
;
--
--	Welche Fachgebiete von Professoren enthalten das Wort 
--	'system'?
--
SELECT fachgebiet
FROM dbs_tab_professor
WHERE fachgebiet LIKE '%system%'
;
--
--	2.6	Vergleich mit NULL-Werten
--
--	Gebe die Matrikelnummern solcher Studenten aus, die einen Job 
--	haben?
--
SELECT matr_nr
FROM dbs_tab_student
WHERE pers_nr IS NOT NULL
;
--
--	Gebe die Daten der Studenten aus, deren Personalnummer nicht dem Wert 
--	507263 entsprechen.
--
SELECT *
FROM dbs_tab_student
WHERE pers_nr != 507263
OR pers_nr IS NULL 
;
--
--	3	Verbund von Tabellen
--
--	3.1	Equi-Join
--
--	Gebe eine Liste aller Fachbereichsnamen mit den Namen ihrer 
--	zugehoerigen Lehrveranstaltungen aus.
--
SELECT f.fb_name,
	l.lv_name
FROM dbs_tab_fachbereich f,
	dbs_tab_lehrveranstaltung l
WHERE f.fb_nr = l.fb_nr
;
--
--	neue Syntax:
--
SELECT f.fb_name,
	l.lv_name
FROM dbs_tab_fachbereich f
INNER JOIN	dbs_tab_lehrveranstaltung l
ON f.fb_nr = l.fb_nr
;
--
--	In welchen unterschiedlichen Strassen finden am Freitag 
--	Lehrveranstaltungen statt?
--
SELECT DISTINCT g.strasse
FROM dbs_tab_gebaeude g,
dbs_tab_lv_ort lo
WHERE g.gebaeude = lo.gebaeude AND lo.tag = 'Fr'
;


--
--	neue Syntax:
--
SELECT DISTINCT g.strasse
FROM dbs_tab_gebaeude g
INNER JOIN dbs_tab_lv_ort lo
ON g.gebaeude = lo.gebaeude 
WHERE lo.tag = 'Fr'
;

--
--	Welche Studenten arbeiten nicht am Fachbereich, an dem 
--	sie eingeschrieben sind?
--
SELECT s.ho_nr
FROM dbs_tab_student s,
dbs_tab_mitarbeiter m
WHERE s.pers_nr = m.pers_nr AND s.fb_nr != m.fb_nr
;
--	
--	neue Syntax:
--
SELECT s.ho_nr
FROM dbs_tab_student s
INNER JOIN dbs_tab_mitarbeiter m
ON s.pers_nr = m.pers_nr 
WHERE s.fb_nr != m.fb_nr
;
--
--	Wie lautet die Adresse des Professors des Fachgebiets 
--	'Mathematik'?
-- 	
SELECT a.plz, a.ort, a.strasse, a.haus_nr
FROM dbs_tab_anschrift a,
	dbs_tab_mitarbeiter m,
	dbs_tab_professor p
WHERE a.ho_nr = m.ho_nr AND m.pers_nr = p.pers_nr
AND m.beruf = 'Professor' AND p.fachgebiet = 'Mathematik'
;
--
--	neue Syntax:
--
SELECT a.plz, a.ort, a.strasse, a.haus_nr
FROM (dbs_tab_anschrift a
INNER JOIN dbs_tab_mitarbeiter m
ON a.ho_nr = m.ho_nr)
INNER JOIN dbs_tab_professor p
ON m.pers_nr = p.pers_nr
WHERE m.beruf = 'Professor' AND p.fachgebiet = 'Mathematik'
;
--
--	3.2	Equi-Join mit NULL-Werten (Outer Equi-Join)
--
--	In welchen Institutionen arbeiten Studenten. Zeige auch solche 
--	Studenten an, die nicht arbeiten.
--
--	spezielle Oracle Syntax (+):
--

--
--	neue Syntax:
--

--
--	3.3	Theta-Join
--
--	Gebe eine Namensliste mit Spielpaarungen aus, in der die 
--	Personalnummer des ersten Spielers kleiner ist als die des 
--	zweiten Spielers wobei alle Personalnummern groesser 
-- 	als 506000 sein sollen.
--

--
--	neue Syntax:
--

--
--	4	Mengenoperationen
--
--	4.1	Vereinigung von Tabellen
--
--	Wie lautet die Menge der Personalnummer, die Professoren oder 
--	Studenten gehoeren?
--
 
--
--	4.2	Schneiden von Tabellen
--
--	Finde die Personalnummern der Mitarbeiter heraus, die Professor 
--	sind und mehr als 5.000 � verdienen.
--

--
--	... auch formulierbar als join:
--

--
--	4.3	Differenz von Tabellen
--
--	Wie lauten die Personalnummern solcher Mitarbeiter, die nicht 
--	Student sind?
--

--
--	5	Aggregatfunktionen
--
--	5.1	Vollstaendige Verdichtung
--
--	Wieviele Mitarbeiter werden beschaeftigt?
--	

--
--	Wie lautet das hoechste, das niedrigste und das 
--	durchschnittliche Gehalt sowie die Summe der Gehaelter der 
--	Mitarbeiter?
--

--
--	5.2	Gruppierung von Verdichtungen
--
--	Wie lauten die Durchschnittsgehaelter der Mitarbeiter 
--	fuer jeden Fachbereiche?
--

--
--	Wie lauten die Durchschnittsgehaelter der Mitarbeiter 
--	fuer jeden Fachbereiche, wenn diese ueber 5.000 � liegen?
--
 
--
--	6	Unterabfragen
--
--	6.1	'IN'-Operator
--
--	Wie lauten die Namen der Mitarbeiter, die nicht in Bonn 
--	wohnen?
--
 
--
--	... auch allgemeiner formulierbar als Join:
--
 
--
--	6.2	Vergleichsoperatoren
--
--	Welcher (!) Hochschulangehoerige wohnt im Auerweg?
--	Achtung: warum "darf" bei "=" in dieser Anfrage nur eine  
--	Person im Auerweg wohnen?
--
 
--					
--	... auch formulierbar als Join (hier d�rfen jedoch auch 
--	mehrere Personen im Auerweg wohnen):
--

--
--	Wie lauten die Namen der Studenten, die zeitlich spaeter 
--	(mit groesserer ho_nr) als Meyer erfasst worden sind ?
--
  
--					
--	6.3	Existenzabfragen
--
--	Welche Fachbereiche bieten keine Lehrveranstaltungen an?
--
 
--
--	Welche Professoren (Personalnummer) halten 
--	Lehrveranstaltungen(mindestens eine)?
--
 
--
--	6.4	All-Quantor
--
--	Welche Mitarbeiter erhalten das groesste Gehalt?
--
 
--
--	Welche Mitarbeiter verdienen weniger als andere?
--
  
--
-- Systemdatum
--
  SELECT user,
         TO_CHAR(SYSDATE, 'dd-mm-yy hh24:mi:ss') 
  FROM   dual
  ;  
--
spool off
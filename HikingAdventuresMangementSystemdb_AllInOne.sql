-- HikingAdventuresMangementSystemdb_AllInOne.sql
-- Run this script in SQL*Plus or SQLcl under the HikingAdventuresMangementSystemdb schema.
-- Example: CONNECT your_user@HikingAdventuresMangementSystemdb

SET ECHO ON
SET SERVEROUTPUT ON

-- Clean up prior objects if they exist
BEGIN
  EXECUTE IMMEDIATE 'DROP VIEW "Trail Event_View"';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE NOT IN (-942) THEN
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP PROCEDURE Client_Details';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE NOT IN (-4043) THEN
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP FUNCTION fnClientReport';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE NOT IN (-4043) THEN
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE TRAIL_EVENT CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE NOT IN (-942) THEN
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE TRAIL CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE NOT IN (-942) THEN
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE CLIENT CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE NOT IN (-942) THEN
      RAISE;
    END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE GUIDE CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE NOT IN (-942) THEN
      RAISE;
    END IF;
END;
/

-- Create tables
CREATE TABLE GUIDE
(
  guide_id        NUMBER(5)      NOT NULL PRIMARY KEY,
  guide_fname     VARCHAR2(100)  NOT NULL,
  guide_sname     VARCHAR2(100)  NOT NULL,
  guide_contact   VARCHAR2(20)   NOT NULL,
  guide_level     NUMBER(3)      NOT NULL
);

CREATE TABLE CLIENT
(
  client_id        VARCHAR2(5)     NOT NULL PRIMARY KEY,
  client_fname     VARCHAR2(100)   NOT NULL,
  client_sname     VARCHAR2(100)   NOT NULL,
  client_address   VARCHAR2(200)   NOT NULL,
  client_contact   VARCHAR2(12)    NOT NULL
);

CREATE TABLE TRAIL
(
  trail_id              NUMBER(5)       NOT NULL PRIMARY KEY,
  trail_name            VARCHAR2(100)   NOT NULL,
  trail_duration        VARCHAR2(50),
  trail_location        VARCHAR2(50),
  trail_experience_lvl  NUMBER(3)       NOT NULL,
  trail_cost            NUMBER(8,2)     NOT NULL
);

CREATE TABLE TRAIL_EVENT
(
  event_id         VARCHAR2(10)   NOT NULL PRIMARY KEY,
  event_date       DATE           NOT NULL,
  participants     NUMBER(3)      NOT NULL,
  guide_id         NUMBER(5)      NOT NULL REFERENCES GUIDE(guide_id),
  client_id        VARCHAR2(5)    NOT NULL REFERENCES CLIENT(client_id),
  trail_id         NUMBER(5)      NOT NULL REFERENCES TRAIL(trail_id)
);

-- Insert sample data
INSERT ALL
  INTO GUIDE VALUES(201, 'Liam', 'Daniels', '0843569001', 7)
  INTO GUIDE VALUES(202, 'Emily', 'Stewart', '0763698022', 3)
  INTO GUIDE VALUES(203, 'Owen', 'Mthembu', '0786598999', 9)
  INTO GUIDE VALUES(204, 'Clara', 'Van Wyk', '0796369444', 4)
  INTO GUIDE VALUES(205, 'Marcus', 'Reid', '0826598111', 8)
SELECT * FROM dual;

INSERT ALL
  INTO CLIENT VALUES('CL101', 'Nathan', 'Daniels', '14 Willow Street', '0821112255')
  INTO CLIENT VALUES('CL102', 'Aisha', 'Morgan', '22 Olive Road', '0769658547')
  INTO CLIENT VALUES('CL103', 'Zara', 'Smith', '8 Hilltop Way', '0843256574')
  INTO CLIENT VALUES('CL104', 'Jade', 'Pillay', '10 Sunset Drive', '0762356111')
  INTO CLIENT VALUES('CL105', 'Sipho', 'Nkosi', '31 Forest Lane', '0821235000')
  INTO CLIENT VALUES('CL106', 'Tahir', 'Essop', '77 Oak Avenue', '0847541999')
  INTO CLIENT VALUES('CL107', 'Hannah', 'Jacobs', '96 Pine Road', '0745556000')
  INTO CLIENT VALUES('CL108', 'Amelia', 'Jones', '55 Riverbank', '0814745005')
  INTO CLIENT VALUES('CL109', 'Riley', 'Howard', '12 Clover Street', '0822232000')
SELECT * FROM dual;

INSERT ALL
  INTO TRAIL VALUES(650, 'Mountain Ridge', '3 hours', 'Storm Peak', 8, 750)
  INTO TRAIL VALUES(651, 'Forest Walk', '1 hour', 'Green Woods', 2, 150)
  INTO TRAIL VALUES(652, 'Canyon Trek', '2 hours', 'Red Valley', 4, 500)
  INTO TRAIL VALUES(653, 'River Bend Trail', '1 hour', 'Silver Stream', 1, 120)
  INTO TRAIL VALUES(654, 'Sunset Hike', '3 hours', 'Golden Cliffs', 3, 400)
  INTO TRAIL VALUES(655, 'Rocky Path', '30 minutes', 'Stone Ridge', 1, 90)
  INTO TRAIL VALUES(656, 'Highland Pass', '1 hour', 'Cloud Plains', 5, 300)
  INTO TRAIL VALUES(657, 'Wildflower Route', '2 hours', 'Bloom Valley', 3, 250)
  INTO TRAIL VALUES(658, 'Eagle Point Trek', '2 hours', 'Eagle Heights', 6, 600)
SELECT * FROM dual;

INSERT ALL
  INTO TRAIL_EVENT VALUES('EV_201', DATE '2025-07-05', 5,  203, 'CL101', 658)
  INTO TRAIL_EVENT VALUES('EV_202', DATE '2025-07-06', 7, 203, 'CL103', 655)
  INTO TRAIL_EVENT VALUES('EV_203', DATE '2025-07-08', 8,  201, 'CL104', 652)
  INTO TRAIL_EVENT VALUES('EV_204', DATE '2025-07-09', 3, 202, 'CL105', 651)
  INTO TRAIL_EVENT VALUES('EV_205', DATE '2025-07-11', 5, 205, 'CL107', 658)
  INTO TRAIL_EVENT VALUES('EV_206', DATE '2025-07-12', 8, 205, 'CL106', 656)
  INTO TRAIL_EVENT VALUES('EV_207', DATE '2025-07-15', 10, 205, 'CL101', 654)
  INTO TRAIL_EVENT VALUES('EV_208', DATE '2025-07-17', 5, 201, 'CL108', 652)
  INTO TRAIL_EVENT VALUES('EV_209', DATE '2025-07-18', 3, 202, 'CL109', 653)
SELECT * FROM dual;

COMMIT;

-- Create view
CREATE OR REPLACE VIEW "Trail Event_View" AS
SELECT te.guide_id,
       te.client_id,
       c.client_address,
       t.trail_duration
FROM trail_event te
JOIN client c ON te.client_id = c.client_id
JOIN trail t ON te.trail_id = t.trail_id
WHERE te.event_date BETWEEN DATE '2025-07-09' AND DATE '2025-07-23';

-- Create procedure
CREATE OR REPLACE PROCEDURE Client_Details (
    p_client_id IN VARCHAR2,
    p_trail_date IN DATE
) AS
  v_client_fname VARCHAR2(100);
  v_client_sname VARCHAR2(100);
  v_trail_name VARCHAR2(100);
  v_found BOOLEAN := FALSE;
  CURSOR c_details IS
    SELECT c.client_fname,
           c.client_sname,
           t.trail_name
    FROM trail_event te
    JOIN client c ON te.client_id = c.client_id
    JOIN trail t ON te.trail_id = t.trail_id
    WHERE te.client_id = p_client_id
      AND TRUNC(te.event_date) = TRUNC(p_trail_date);
BEGIN
  OPEN c_details;
  LOOP
    FETCH c_details INTO v_client_fname, v_client_sname, v_trail_name;
    EXIT WHEN c_details%NOTFOUND;
    v_found := TRUE;
    DBMS_OUTPUT.PUT_LINE('Customer: ' || v_client_fname || ' ' || v_client_sname);
    DBMS_OUTPUT.PUT_LINE('Trail Name: ' || v_trail_name);
    DBMS_OUTPUT.PUT_LINE('---');
  END LOOP;
  CLOSE c_details;

  IF NOT v_found THEN
    DBMS_OUTPUT.PUT_LINE('No client found for Client ID: ' || p_client_id ||
                         ' on date: ' || TO_CHAR(p_trail_date, 'YYYY-MM-DD'));
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END Client_Details;
/

-- Create function
CREATE OR REPLACE FUNCTION fnClientReport (
    p_client_id IN VARCHAR2
) RETURN SYS_REFCURSOR AS
  v_cursor SYS_REFCURSOR;
  v_count NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM client
  WHERE client_id = p_client_id;

  IF v_count = 0 THEN
    RAISE NO_DATA_FOUND;
  END IF;

  OPEN v_cursor FOR
    SELECT c.client_id AS customer_id,
           t.trail_id,
           te.event_date AS trail_date,
           t.trail_cost AS total_trail_cost
    FROM trail_event te
    JOIN client c ON te.client_id = c.client_id
    JOIN trail t ON te.trail_id = t.trail_id
    WHERE c.client_id = p_client_id
    ORDER BY te.event_date;

  RETURN v_cursor;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: Client ID ' || p_client_id || ' not found.');
    RETURN NULL;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
    RETURN NULL;
END fnClientReport;
/

-- Sample execution and output display
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== Trail Event_View contents ===');
END;
/
SELECT * FROM "Trail Event_View";

BEGIN
  DBMS_OUTPUT.PUT_LINE('=== Client_Details for CL101 on 2025-07-05 ===');
  Client_Details('CL101', DATE '2025-07-05');

  DBMS_OUTPUT.PUT_LINE('=== Client_Details for CL999 on 2025-07-05 ===');
  Client_Details('CL999', DATE '2025-07-05');
END;
/

SET SERVEROUTPUT ON
DECLARE
  v_cursor SYS_REFCURSOR;
  v_customer_id VARCHAR2(5);
  v_trail_id NUMBER;
  v_trail_date DATE;
  v_total_cost NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== Fixture: fnClientReport for CL101 ===');
  v_cursor := fnClientReport('CL101');

  IF v_cursor IS NOT NULL THEN
    LOOP
      FETCH v_cursor INTO v_customer_id, v_trail_id, v_trail_date, v_total_cost;
      EXIT WHEN v_cursor%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('Customer ID: ' || v_customer_id ||
                           ' | Trail ID: ' || v_trail_id ||
                           ' | Trail Date: ' || TO_CHAR(v_trail_date, 'YYYY-MM-DD') ||
                           ' | Total Cost: $' || v_total_cost);
    END LOOP;
    CLOSE v_cursor;
  END IF;

  DBMS_OUTPUT.PUT_LINE('=== Fixture: fnClientReport for CL999 ===');
  v_cursor := fnClientReport('CL999');
END;
/

CREATE OR REPLACE TRIGGER PhoneSwitching
AFTER INSERT ON STATE_CHANGE
FOR EACH ROW
DECLARE
    CurrentCell NUMBER;
BEGIN
    -- retrieve the corresponding cell
    SELECT CellId INTO CurrentCell
    FROM CELL
    WHERE X0 <= :NEW.X AND :NEW.X < X1
    AND Y0 <= :NEW.Y AND :NEW.Y < Y1;

    IF (:NEW.ChangeType = 'O') THEN
        -- insert the new phone into the TELEPHONE table
        INSERT INTO TELEPHONE(PhoneNo, X, Y, PhoneState)
        VALUES (:NEW.PhoneNo, :NEW.X, :NEW.Y, 'On');
        
        -- update the number of phones
        UPDATE CELL
        SET CurrentPhone# = CurrentPhone# + 1
        WHERE CellId = CurrentCell;
    ELSIF (:NEW.ChangeType = 'F') THEN
        -- remove the phone from the TELEPHONE table
        DELETE FROM TELEPHONE
        WHERE PhoneNo = :NEW.PhoneNo;
        
        -- update the number of phones
        UPDATE CELL
        SET CurrentPhone# = CurrentPhone# - 1
        WHERE CellId = CurrentCell;
    END IF;
END;
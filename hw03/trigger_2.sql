CREATE OR REPLACE TRIGGER StartCall
AFTER INSERT ON STATE_CHANGE
FOR EACH ROW
WHEN (NEW.ChangeType = 'C')
DECLARE
    CurrentCell NUMBER;
    CellX0 NUMBER;
    CellX1 NUMBER;
    CellY0 NUMBER;
    CellY1 NUMBER;
    CellMaxCalls NUMBER;
    CallingCount NUMBER;
    LastException NUMBER;
BEGIN
    -- retrieve the corresponding cell
    SELECT CellId, X0, X1, Y0, Y1, MaxCalls
    INTO CurrentCell, CellX0, CellX1, CellY0, CellY1, CellMaxCalls
    FROM CELL
    WHERE X0 <= :NEW.X AND :NEW.X < X1
    AND Y0 <= :NEW.Y AND :NEW.Y < Y1;
    
    -- count phones calling in the cell
    SELECT COUNT(*) INTO CallingCount
    FROM TELEPHONE
    WHERE CellX0 <= :NEW.X AND :NEW.X < CellX1
    AND CellY0 <= :NEW.Y AND :NEW.Y < CellY1
    AND PhoneState = 'Active';
    
    -- check if call can be allocated
    IF (CallingCount < CellMaxCalls) THEN
        -- telephone becomes active
        UPDATE TELEPHONE
        SET PhoneState = 'Active'
        WHERE PhoneNo = :NEW.PhoneNo;
    ELSE
        -- retrieve the exception number to use
        SELECT MAX(ExId) INTO LastException
        FROM EXCEPTION_LOG
        WHERE CellId = CurrentCell;
        
        -- set to 0 if NULL
        IF (LastException IS NULL) THEN
            LastException := 0;
        END IF;
        -- insert new exception
        
        INSERT INTO EXCEPTION_LOG(ExId, CellId, ExceptionType)
        VALUES (LastException + 1, CurrentCell, 'C');
    END IF;
END;
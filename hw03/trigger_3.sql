CREATE OR REPLACE TRIGGER MaxCallChange1
BEFORE UPDATE OF MaxCalls ON CELL
FOR EACH ROW
WHEN (NEW.MaxCalls < OLD.MaxCalls)
DECLARE
    CallingCount NUMBER;
BEGIN
    -- count phones calling in the cell
    SELECT COUNT(*) INTO CallingCount
    FROM TELEPHONE
    WHERE :NEW.X0 <= X AND X < :NEW.X1
    AND :NEW.X0 <= Y AND Y < :NEW.Y1
    AND PhoneState = 'Active';
    
    IF (CallingCount > :NEW.MaxCalls) THEN
        -- set the new value of MaxCalls
        :NEW.MaxCalls := CallingCount;
    END IF;
END;
CREATE OR REPLACE TRIGGER MaxCallChange2
AFTER UPDATE OF MaxCalls ON CELL
DECLARE
    TotalMaxCalls NUMBER;
BEGIN
    -- count the total of the calls on the mutating table
    SELECT SUM(MaxCalls) INTO TotalMaxCalls
    FROM CELL;
    
    -- check the constraint and report errors
    IF (TotalMaxCalls <= 30) THEN
        RAISE_APPLICATION_ERROR(-20000, 'The maximum number of calls needs to be always greater than 30');
    END IF;
END;
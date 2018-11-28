CREATE OR REPLACE TRIGGER COUNT_EMPLOYEES
AFTER INSERT OR UPDATE OF JOB ON IMP2
FOR EACH ROW
DECLARE
    NEW_LISTED NUMBER;
    OLD_EMPLOYEES NUMBER;
BEGIN
    -- check if the entry relative to the new job is already in the summary
    SELECT COUNT(*) INTO NEW_LISTED
    FROM SUMMARY
    WHERE JOB = :NEW.JOB;
    
    -- if not present, insert a new entry
    IF (NEW_LISTED = 1) THEN
        UPDATE SUMMARY
        SET NUM = NUM + 1
        WHERE JOB = :NEW.JOB;
    -- if present, update the available one
    ELSE
        INSERT INTO SUMMARY(JOB, NUM)
        VALUES (:NEW.JOB, 1);
    END IF;
    
    -- update the entry relative to the old job
    UPDATE SUMMARY
    SET NUM = NUM - 1
    WHERE JOB = :OLD.JOB;
    
    -- remove eventually empty entries
    DELETE FROM SUMMARY
    WHERE NUM = 0;
END;
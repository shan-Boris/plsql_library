CREATE OR REPLACE TRIGGER CHECK_BIRTHDAY
    BEFORE INSERT OR UPDATE ON CLIENT
    FOR EACH ROW

BEGIN

    IF EXTRACT(YEAR FROM :NEW.BIRTHDAY) NOT BETWEEN 1900 AND EXTRACT(YEAR FROM SYSDATE)
        THEN
            RAISE_APPLICATION_ERROR(-20501, '�������� ���� ��������');
    END IF;
END;
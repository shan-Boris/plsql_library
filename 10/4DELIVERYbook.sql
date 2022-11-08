-- ������ ����� �� ������ ����� ��������

DECLARE
    ID_CLIENT$          CLIENT.ID%TYPE;
    TITLE$              BOOK.TITLE%TYPE;
    PUBLISHER$          PUBLISHER.PUBLISHER%TYPE;
    ID_EXEMPLAR$        EXEMPLAR.ID%TYPE;

BEGIN
-- �������� ������ � �������

    ID_CLIENT$ := 10;
    TITLE$ := '1984';
    PUBLISHER$ := '�����';

--������� ��������� ����� ��� ������
    SELECT 
        E.ID
    INTO    
        ID_EXEMPLAR$
    FROM EXEMPLAR E
        JOIN BOOK B
            ON B.ID = E.ID_BOOK
        JOIN PUBLISHER P
            ON P.ID = B.ID_PUBLISHER
    WHERE TITLE = TITLE$
        AND PUBLISHER = PUBLISHER$
        AND ON_STORE = 1
    FETCH FIRST 1 ROWS ONLY;


-- ��������� ������ � ������ ������
    INSERT INTO LOG_DELIVERY_RETURN_BOOK (
        TAKE_BOOK,
        ID_CLIENT,
        ID_EXEMPLAR
    ) VALUES (
        TO_DATE(SYSDATE, 'dd/mm/yyyy'),
        ID_CLIENT$,
        ID_EXEMPLAR$
    );

-- ������ �������������� �����
    UPDATE EXEMPLAR
        SET ON_STORE = 0,
            ON_HOME = 1
    WHERE ID = ID_EXEMPLAR$;


    DBMS_OUTPUT.put_line (TITLE$ || ' ������, ��������� �' || ID_EXEMPLAR$);
    
END;


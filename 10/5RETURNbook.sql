-- ������ ����� �� �������� ����� ���������.

DECLARE
    ID_CLIENT$          CLIENT.ID%TYPE;
    TITLE$              BOOK.TITLE%TYPE;
    PUBLISHER$          PUBLISHER.PUBLISHER%TYPE;
    ID_EXEMPLAR$        EXEMPLAR.ID%TYPE;
    RATE_FROM_CLIENT$   NUMBER;
    
BEGIN
-- �������� ������ � �������

    ID_CLIENT$ := 10;
    TITLE$ := '1984';
    PUBLISHER$ := '�����';
    RATE_FROM_CLIENT$ := 4;

--������� ��������� ����� ������� ���� ������
    SELECT 
        E.ID
    INTO    
        ID_EXEMPLAR$
    FROM EXEMPLAR E
        JOIN BOOK B
            ON B.ID = E.ID_BOOK
        JOIN PUBLISHER P
            ON P.ID = B.ID_PUBLISHER
        JOIN LOG_DELIVERY_RETURN_BOOK DRB
            ON DRB.ID_EXEMPLAR = E.ID
        JOIN CLIENT C
            ON C.ID = DRB.ID_CLIENT
    WHERE TITLE = TITLE$
        AND P.PUBLISHER = PUBLISHER$
        AND C.ID = ID_CLIENT$
        AND DRB.RETURN_BOOK IS NULL;

-- ��������� ������ � ������ ������ � ��������
    UPDATE LOG_DELIVERY_RETURN_BOOK DRB
        SET RETURN_BOOK = TO_DATE(SYSDATE, 'dd/mm/yyyy'),
            RATING_BOOK = RATE_FROM_CLIENT$
    WHERE ID_CLIENT = ID_CLIENT$
            AND ID_EXEMPLAR = ID_EXEMPLAR$;



-- ������ �������������� �����
    UPDATE EXEMPLAR
        SET ON_STORE = 1,
            ON_HOME = 0
    WHERE ID = ID_EXEMPLAR$;


    DBMS_OUTPUT.put_line (TITLE$ || ' ����������, ��������� �' || ID_EXEMPLAR$);
    
END;


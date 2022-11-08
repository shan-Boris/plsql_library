-- ������ ������ � ������� ��������� ������, ��� ������ ����� �������� � �������.

DECLARE
    CLIENT_ID$              NUMBER;
    BOOK_ID$                NUMBER;
    READER_OK$              NUMBER;
    DELIVERY_EXEMPLAR_ID$   NUMBER;
    

BEGIN

    CLIENT_ID$ := CREATE_CLIENT(
        FIRST_NAME$ => '���', 
        LAST_NAME$ => '�������', 
        FATHER_NAME$ => '��������', 
        BIRTHDAY$ => TO_DATE('15/5/2020', 'dd/mm/yyyy'), 
        EMPLOYEE$ => '', 
        RATING$ => 5
        );
    DBMS_OUTPUT.put_line ('--------------------');


    BOOK_ID$ := CREATE_BOOK(
        AMOUNT_BOOKS$  => 3,
        PUBLISHER$ => '������������',
        TITLE$ => '��������',
        SUMMARY$ => '����������',
        YEAR_OF_PUBLICATION$ => 2010,
        AGE_LIMIT$ => 5,
        PRICE$ => 500,
        BOOK_TYPE$ => '�����',
        A_FIRST_NAMES$ => A_FIRST_NAME('������', '�����'),
        A_LAST_NAMES$ => A_LAST_NAME('�����', '������'),
        A_FATHER_NAMES$ => A_FATHER_NAME(' ', ' ')
        );
    DBMS_OUTPUT.put_line ('--------------------');


    READER_OK$ := CHECK_READER(
        ID_CLIENT$ => 8,
        TITLE$ => '�������'
    );

    IF READER_OK$ = 1 
        THEN DBMS_OUTPUT.put_line ('����� ������ �����');
        ELSE DBMS_OUTPUT.put_line ('������ ������ �����');
    END IF;
    DBMS_OUTPUT.put_line ('--------------------');


    DELIVERY_EXEMPLAR_ID$ := DELIVERY_BOOK(
        ID_CLIENT$ => 18,
        TITLE$ => '����������� ���� ������',
        PUBLISHER$ => '��������'
    );
    DBMS_OUTPUT.put_line ('--------------------');


    RETURN_BOOK(
        ID_CLIENT$ => 18,
        TITLE$ => '�����������',
        PUBLISHER$ => '����',
        RATE_FROM_CLIENT$ => 4
    );
    DBMS_OUTPUT.put_line ('--------------------');


    TOOK_BOOKS_A_DAY(
        DAY$ => TO_DATE('1/12/2022', 'dd/mm/yyyy')
    );
    DBMS_OUTPUT.put_line ('--------------------');
    

    RETURN_BOOKS_A_DAY(
        DAY$ => TO_DATE('10/10/2022', 'dd/mm/yyyy')
    );

    DBMS_OUTPUT.put_line ('--------------------');


    REPORT_ABOUT_EXEMPLAR(
        ID_EXEMPLAR$ => 563
    );

    DBMS_OUTPUT.put_line ('--------------------');

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;


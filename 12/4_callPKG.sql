-- ������ ������ � ������� ��������� ������, ��� ������ ����� �������� �������� � �������.

DECLARE
    CLIENT_ID$              NUMBER;
    BOOK_ID$                NUMBER;
    DELIVERY_EXEMPLAR_ID$   NUMBER;

BEGIN

    CLIENT_ID$ := CLIENT_PKG.CREATE_CLIENT(
        FIRST_NAME$ => '���', 
        LAST_NAME$ => '�������', 
        FATHER_NAME$ => '��������', 
        BIRTHDAY$ => TO_DATE('15/5/2020', 'dd/mm/yyyy'), 
        EMPLOYEE$ => '', 
        RATING$ => 5
        );
    DBMS_OUTPUT.put_line ('--------------------');


    BOOK_ID$ := BOOK_PKG.CREATE_BOOK(
        AMOUNT_BOOKS$  => 3,
        PUBLISHER$ => '������������',
        TITLE$ => '��������',
        SUMMARY$ => '����������',
        YEAR_OF_PUBLICATION$ => 2010,
        AGE_LIMIT$ => 5,
        PRICE$ => 500,
        BOOK_TYPE$ => '�����',
        A_FIRST_NAMES$ => BOOK_PKG.A_FIRST_NAME('������', '�����'),
        A_LAST_NAMES$ => BOOK_PKG.A_LAST_NAME('�����', '������'),
        A_FATHER_NAMES$ => BOOK_PKG.A_FATHER_NAME(' ', ' ')
        );
    DBMS_OUTPUT.put_line ('--------------------');


    DELIVERY_EXEMPLAR_ID$ := BOOK_PKG.GET_BOOK(
        ID_CLIENT$ => 9,
        TITLE$ => '�������',
        PUBLISHER$ => 'Inspiria'
    );
    DBMS_OUTPUT.put_line ('--------------------');


    BOOK_PKG.RETURN_BOOK(
        ID_CLIENT$ => 9,
        TITLE$ => '�������',
        PUBLISHER$ => 'Inspiria',
        RATE_FROM_CLIENT$ => 5
    );
    DBMS_OUTPUT.put_line ('--------------------');


    REPORT_PKG.TOOK_BOOKS_A_DAY(
        DAY$ => TO_DATE('1/12/2022', 'dd/mm/yyyy')
    );
    DBMS_OUTPUT.put_line ('--------------------');
    

    REPORT_PKG.RETURN_BOOKS_A_DAY(
        DAY$ => TO_DATE('15/3/2022', 'dd/mm/yyyy')
    );
    DBMS_OUTPUT.put_line ('--------------------');


    REPORT_PKG.REPORT_ABOUT_EXEMPLAR(
        ID_EXEMPLAR$ => 563
    );
    DBMS_OUTPUT.put_line ('--------------------');

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;


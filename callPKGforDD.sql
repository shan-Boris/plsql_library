-- -- ������ ������ � ������� ��������� ������, ��� ������ ����� �������� �������� � �������.

-- DECLARE
--     CLIENT_ID$              NUMBER;
--     BOOK_ID$                NUMBER;
--     DELIVERY_EXEMPLAR_ID$   NUMBER;

-- BEGIN

--     --  CLIENT_ID$ := CLIENT_PKG.CREATE_CLIENT(
--     --      FIRST_NAME$ => '���', 
--     --      LAST_NAME$ => '�������', 
--     --      FATHER_NAME$ => '��������', 
--     --      BIRTHDAY$ => TO_DATE('15/5/2002', 'dd/mm/yyyy'), 
--     --      EMPLOYEE$ => '', 
--     --      RATING$ => 5
--     --      );
--     --  DBMS_OUTPUT.put_line ('--------------------');


--      BOOK_ID$ := book_pkg.create_book(
--                 amount_books  => 1,
--                 publisher => '������������',
--                 title => '��������',
--                 summary => '����������',
--                 year_of_publication => 2022,
--                 age_limit => 5,
--                 price => 500,
--                 book_type => '�����',
--                 a_first_names => book_pkg.a_first_name('������', '�����'),
--                 a_last_names => book_pkg.a_last_name('�����', '������'),
--                 a_father_names => book_pkg.a_father_name(' ', ' '),
--                 tags => book_pkg.tag('��������', '���', '�����', '������'),
--                 genres => book_pkg.genre('������� ����')
--                 );
--      DBMS_OUTPUT.put_line ('--------------------');


--     -- DELIVERY_EXEMPLAR_ID$ := BOOK_PKG.GET_BOOK(
--     --     ID_CLIENT$ => 9,
--     --     TITLE$ => '����������� ���� ������',
--     --     PUBLISHER$ => '��������'
--     -- );
--     -- DBMS_OUTPUT.put_line ('--------------------');


--     -- BOOK_PKG.RETURN_BOOK(
--     --     ID_CLIENT$ => 9,
--     --     TITLE$ => '�������',
--     --     PUBLISHER$ => 'Inspiria',
--     --     RATE_FROM_CLIENT$ => 5
--     -- );
--     -- DBMS_OUTPUT.put_line ('--------------------');


--     --  REPORT_PKG.TOOK_BOOKS_A_DAY(
--     --     DAY$ => TO_DATE('1/12/2022', 'dd/mm/yyyy')
--     --  );
--     --  DBMS_OUTPUT.put_line ('--------------------');
    

--     --  REPORT_PKG.RETURN_BOOKS_A_DAY(
--     --      DAY$ => TO_DATE('15/3/2022', 'dd/mm/yyyy')
--     --  );
--     --  DBMS_OUTPUT.put_line ('--------------------');


--     --  REPORT_PKG.REPORT_ABOUT_EXEMPLAR(
--     --      ID_EXEMPLAR$ => 100
--     --  );
--     --  DBMS_OUTPUT.put_line ('--------------------');

-- END;
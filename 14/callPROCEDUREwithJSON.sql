-- ����� ������ ������������ ������� �������� ���� �� ������������ ���� - ������ � ���� CLOB json �������.


BEGIN

     REPORT_PKG.TOOK_BOOKS_A_DAY(
        DAY$ => TO_DATE('1/12/2022', 'dd/mm/yyyy')
     );
     DBMS_OUTPUT.put_line ('--------------------');
    

END;
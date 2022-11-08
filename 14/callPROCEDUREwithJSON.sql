-- Вызов метода возвращающий таблицу выданных книг за определенный день - теперь в виде CLOB json формата.


BEGIN

     REPORT_PKG.TOOK_BOOKS_A_DAY(
        DAY$ => TO_DATE('1/12/2022', 'dd/mm/yyyy')
     );
     DBMS_OUTPUT.put_line ('--------------------');
    

END;
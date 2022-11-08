BEGIN

  --Bye Tables!
  FOR i IN (SELECT ut.table_name
              FROM USER_TABLES ut) LOOP
    EXECUTE IMMEDIATE 'drop table '|| i.table_name ||' CASCADE CONSTRAINTS ';
  END LOOP;

END;
/
PURGE RECYCLEBIN; 
COMMIT;
/
BEGIN

  --Bye sequence!
  FOR i IN (SELECT ut.sequence_name
              FROM user_sequences ut) LOOP
    EXECUTE IMMEDIATE 'drop sequence '|| i.sequence_name ;
  END LOOP;

END;
/


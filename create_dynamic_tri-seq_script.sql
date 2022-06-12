set serveroutput on
DECLARE
        object_already_exists exception;
        pragma exception_init(object_already_exists, -955);
        Seq_name varchar(100);
        Trg_name varchar(100);
        CURSOR CREATE_SEQ_CURSOR IS
            SELECT CONSTRAINT_NAME, cols.column_name, table_name
            FROM USER_CONSTRAINTS natural JOIN all_cons_columns cols
            WHERE CONSTRAINT_TYPE = 'P' and COLS.POSITION = 1
            AND TABLE_NAME IN (SELECT TABLE_NAME FROM USER_TAB_COLUMNS);
BEGIN
        FOR SEQ_RECORD IN CREATE_SEQ_CURSOR LOOP
        BEGIN
        Seq_name:=SEQ_RECORD.table_name||'_SEQ' ;
        Trg_name:=SEQ_RECORD.table_name||'_TRG' ;
                    
                    -- Sequence
                    EXECUTE IMMEDIATE 'CREATE SEQUENCE '|| Seq_name ||' 
                    START WITH 1
                      MAXVALUE 999999999999999999999999999
                      MINVALUE 1
                      NOCYCLE
                      CACHE 20
                      NOORDER';
                   dbms_output.put_line(Seq_name||': Added successfully');
                                       
                      -- Trigger
                    EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER '||Trg_name||' 
                    BEFORE INSERT
                    ON '||SEQ_RECORD.table_name||'
                    REFERENCING NEW AS New OLD AS Old
                    FOR EACH ROW
                    BEGIN
                      :new.'||SEQ_RECORD.column_name|| ':= '||Seq_name||'.nextval;
                    END;';
                    
                    exception
                    when object_already_exists then
                    dbms_output.put_line(Seq_name||': Skipped already exists');
                    continue;
                    END;
                    
        END LOOP;
END;

commit;
show errors;

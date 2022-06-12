set serveroutput on
create or replace function insert_INSTALLMENTS_PAID (v_contract_id number, v_startdate out CONTRACTS.CONTRACT_STARTDATE%type, install_no out number, amount out number) 
return number
is
    cnt number(2);
    diff_month number(2);
    v_fees CONTRACTS.CONTRACT_TOTAL_FEES%type;
    v_enddate CONTRACTS.CONTRACT_ENDDATE%type;
    v_contype CONTRACTS.CONTRACT_PAYMENT_TYPE%type;
begin
    select CONTRACT_STARTDATE, CONTRACT_ENDDATE, CONTRACT_PAYMENT_TYPE, CONTRACT_TOTAL_FEES into v_startdate, v_enddate, v_contype, v_fees
    from contracts
    where contract_id = v_contract_id;
    
     case v_contype
         when 'ANNUAL' then cnt:=12;
         when 'QUARTER' then cnt:=3;
         when 'MONTHLY' then cnt:=1;
         when 'HALF_ANNUAL' then cnt:=6;
     end case;
    
    diff_month := MONTHS_BETWEEN(v_enddate, v_startdate);
    install_no:=diff_month/cnt;
    amount:= v_fees/install_no;
    
    return cnt;
    
end insert_INSTALLMENTS_PAID;

declare
    months_add number;
    counter number;
    v_new_date date;
    install_no number;
    v_amount number;
    cursor contract_cursor is
    select contract_id from contracts;
begin
    for contract_record in contract_cursor loop
    months_add:=insert_INSTALLMENTS_PAID(contract_record.contract_id, v_new_date, install_no, v_amount);
    dbms_output.put_line(months_add ||' '||v_new_date||' '||install_no);
    insert into INSTALLMENTS_PAID (CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT)
    values (contract_record.CONTRACT_ID, v_new_date, v_amount);
    counter := 1;
    while (counter<install_no)
        loop
        v_new_date:= add_months(v_new_date, months_add);
        dbms_output.put_line('new date: '||v_new_date);
        insert into INSTALLMENTS_PAID (CONTRACT_ID, INSTALLMENT_DATE, INSTALLMENT_AMOUNT)
        values (contract_record.CONTRACT_ID, v_new_date, v_amount);
        counter := counter + 1;
        end loop;
    end loop;
end;

show errors;
set serveroutput on
create or replace procedure update_payment_installemnts_no (v_contract_id number)
is
    cnt number(2);
    diff_month number(2); install_no number(2);
    v_startdate CONTRACTS.CONTRACT_STARTDATE%type;
    v_enddate CONTRACTS.CONTRACT_ENDDATE%type;
    v_contype CONTRACTS.CONTRACT_PAYMENT_TYPE%type;
begin
    select CONTRACT_STARTDATE, CONTRACT_ENDDATE, CONTRACT_PAYMENT_TYPE into v_startdate, v_enddate, v_contype
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
    
    update contracts
    set PAYMENTS_INSTALLMENTS_NO = install_no
    where contract_id = v_contract_id;
        
end update_payment_installemnts_no;

--call
declare
    cursor contract_cursor is
    select contract_id from contracts;
begin
    for contract_record in contract_cursor loop
        update_payment_installemnts_no(contract_record.contract_id);
    end loop;

end;

show errors;
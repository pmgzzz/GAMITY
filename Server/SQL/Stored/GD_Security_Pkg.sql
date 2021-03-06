prompt === Package GD_Security_Pkg ===

create or replace
package GD_Security_Pkg is
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ������������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ����
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_MD5(p in VarChar2)
return VarChar2;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �����������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Authorisation(pSNILS       in     GD_Emp_Personnel.snils%type,  -- �����
                        pPIN         in     VarChar2                   ,  -- ������
                        pMacAddress  in     GD_Gadget.mac_address%type ,  -- MAC �����
                        pEmployeeId     out GD_Employee.id%type        ,  -- Id ���������
                        pResult         out Integer                    ,  -- ��������� (0 - OK, ����� ������)
                        pErrMes         out VarChar2                   ); -- ��������� �� ������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/

create or replace
package body GD_Security_Pkg is
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ������������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
E_Fake exception;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ����
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_MD5(p in VarChar2)
return VarChar2 is
begin
  return Utl_Raw.Cast_To_VarChar2(Sys.DBMS_Obfuscation_Toolkit.MD5(input=>Utl_Raw.Cast_To_Raw(p)));
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �����������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Authorisation(pSNILS       in     GD_Emp_Personnel.snils%type,    -- �����
                        pPIN         in     VarChar2                   ,    -- ������
                        pMacAddress  in     GD_Gadget.mac_address%type ,    -- MAC �����
                        pEmployeeId     out GD_Employee.id%type        ,    -- Id ���������
                        pResult         out Integer                    ,    -- ��������� (0 - OK, ����� ������)
                        pErrMes         out VarChar2                   ) is -- ��������� �� ������
  rPersonnel GD_Emp_Personnel%RowType;
  rEmployee  GD_Employee%RowType;
  rGadget    GD_Gadget%RowType;
begin
  rPersonnel:=GD_Emp_Api_Pkg.Get_Personnel_By_SNILS(pSNILS);
  if Get_MD5(pPIN)!=rPersonnel.pin then
    pErrMes:='�������� ���';
    raise E_Fake;
  end if;
  rGadget:=GD_Api_Pkg.Get_Gadget_By_Mac_Address(pMacAddress);
  select GD_Employee.id
    into pEmployeeId
    from GD_Employee
    where GD_Employee.gadget_id=rGadget.id and
          GD_Employee.employee_id=rPersonnel.id;
  pResult:=0;
exception
  when E_Fake then
    pResult:=-1;
  when Others then
    pErrMes:=SQLErrM;
    pResult:=-1;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/

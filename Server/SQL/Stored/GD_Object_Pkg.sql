prompt === Package GD_Object_Pkg ===

create or replace
package GD_Object_Pkg is
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ������ � ���������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �������������� ����� �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function In_Area(pObjectId  in GD_Object_Area.object_id%type , -- Id �������
                 pLatitude  in GD_Object_Area.latitude%type  , -- ������
                 pLongitude in GD_Object_Area.longitude%type ) -- �������
return Boolean;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �������������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Init;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ������� �� �����������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Object(pLatitude  in GD_Object_Area.latitude%type  , -- ������
                    pLongitude in GD_Object_Area.longitude%type ) -- �������
return GD_Object%RowType;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/

create or replace
package body GD_Object_Pkg is
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ������ � ���������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
type TT_Object_Area is
  table of GD_Object_Area%RowType;
rObjectArea TT_Object_Area;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ������ �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Get_Object_Area(pObjectId in GD_Object_Area.object_id%type) is -- Id �������
begin
  if rObjectArea is null then
    select GD_Object_Area.*
      bulk collect
      into rObjectArea
      from GD_Object_Area
      where GD_Object_Area.object_id=pObjectId;
  end if;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �������������� ����� �������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function In_Area(pObjectId  in GD_Object_Area.object_id%type , -- Id �������
                 pLatitude  in GD_Object_Area.latitude%type  , -- ������
                 pLongitude in GD_Object_Area.longitude%type ) -- �������
return Boolean is
  vResult Boolean default false;
  j Integer;
  n Integer;
begin
  Get_Object_Area(pObjectId);
  n:=rObjectArea.Count;
  j:=n;
  for i in 1..n loop
    if ((((rObjectArea(i).latitude<=pLatitude) and (pLatitude<rObjectArea(j).latitude)) or ((rObjectArea(j).latitude<=pLatitude) and (pLatitude<rObjectArea(i).latitude))) and
         (pLongitude>(rObjectArea(j).longitude-rObjectArea(i).longitude)*(pLatitude-rObjectArea(i).latitude) / (rObjectArea(j).latitude-rObjectArea(i).latitude)+rObjectArea(i).longitude)) then
      vResult:=not vResult;
    end if;
    j:=i;
  end loop;
  return vResult;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- �������������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure Init is
begin
  rObjectArea:=null;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ��������� ������� �� �����������
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Get_Object(pLatitude  in GD_Object_Area.latitude%type  , -- ������
                    pLongitude in GD_Object_Area.longitude%type ) -- �������
return GD_Object%RowType is
begin
  for rObject in (select GD_Object.*
                    from GD_Object) loop
    Init;
    if In_Area(rObject.id,pLatitude,pLongitude) then
      return rObject;
    end if;
  end loop;
  return null;
end;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/

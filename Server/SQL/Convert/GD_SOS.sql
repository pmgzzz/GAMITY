prompt === Create table GD_SOS ===

create table GD_SOS
  (id integer generated by default on null as identity not null,
   object_id     Integer                                               not null,
   employee_id   Integer                                               not null,
   latitude      Number                                                not null,
   longitude     Number                                                not null,
   altitude      Number                                                not null,
   message       VarChar2(2000)                                        not null,
   work_shift_id Integer                                               not null,
   gadget_id     Integer                                               not null,
   date_time     Date                                                  not null);

comment on table GD_SOS               is 'GAMITY. SOS ������ (01.11.2020)';

comment on column GD_SOS.id            is 'Id';
comment on column GD_SOS.object_id     is 'Id �������';
comment on column GD_SOS.employee_id   is 'Id ���������';
comment on column GD_SOS.latitude      is '������';
comment on column GD_SOS.longitude     is '�������';
comment on column GD_SOS.altitude      is '������';
comment on column GD_SOS.message       is '���������';
comment on column GD_SOS.work_shift_id is 'Id �����';
comment on column GD_SOS.gadget_id     is 'Id �������';
comment on column GD_SOS.date_time     is '����/�����';

alter table GD_SOS add
  constraint PK_GD_Sos
    primary key (id) using index tablespace Indexes;
alter table GD_SOS add
  constraint FK_GD_Sos_2_Gdt
    foreign key (gadget_id)
    references GD_Gadget (id);
alter table GD_SOS add
  constraint FK_GD_Sos_2_Emp
    foreign key (employee_id)
    references GD_Employee (id);
alter table GD_SOS add
  constraint FK_GD_Sos_2_Obj
    foreign key (object_id)
    references GD_Object (id);

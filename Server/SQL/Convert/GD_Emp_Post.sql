prompt === Create table GD_Emp_Post ===

create table GD_Emp_Post
  (id integer generated by default on null as identity not null,
   name VarChar2(2000)                                                );

comment on table GD_Emp_Post      is 'GAMITY. ����� ������. ��������� (01.11.2020)';

comment on column GD_Emp_Post.id   is 'Id';
comment on column GD_Emp_Post.name is '������������';

alter table GD_Emp_Post add
  constraint PK_GD_Emp_Pst
    primary key (id) using index tablespace Indexes;

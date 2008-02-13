drop table if exists subjects;
drop table if exists rubber_bands;
drop table if exists cards;
drop table if exists users;

create table subjects (
    id                     int            not null auto_increment,
    name                   varchar(100)   not null,
    primary key(id)
) engine=InnoDB;

create table rubber_bands (
    id                     int            not null auto_increment,
    name                   varchar(100)   not null,
    subject_id             int            not null,
    constraint fk_rubber_bands_subjects foreign key (subject_id) references subjects(id),
    primary key(id)
) engine=InnoDB;


create table cards (
    id                     int            not null auto_increment,
    rubber_band_id         int            not null,
    front_side             varchar(255)   not null,
    back_side              text           not null,
    constraint fk_cards_rubber_bands foreign key (rubber_band_id) references rubber_bands(id),
    primary key(id)
) engine=InnoDB;

create table users (
    id                     int            not null auto_increment,
    user_name              varchar(100)   not null,
    password               varchar(100)   not null,
    role                   varchar(100)   not null,
    primary key(id)
) engine=InnoDB;

unit UNewTables;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const
  SQL_10000000_SEL = 'SELECT NAME FROM SQLITE_MASTER WHERE TYPE=''view''' +
                     'AND NAME = ''BRAND_VIEW''';
  SQL_10000000_DRP = 'DROP VIEW BRAND_VIEW';
  SQL_10000001_NEW = 'CREATE TABLE USERS_NEW(' +
                     'USER_ID INTEGER NOT NULL, ' +
                     'NAME VARCHAR(128) NOT NULL UNIQUE, ' +
                     'PAW VARCHAR(128) NOT NULL, ' +
                     'ROLE INTEGER NOT NULL, ' +
                     'ENTRY_DT DATETIME NOT NULL, ' +
                     'UPDATE_DT DATETIME, ' +
                     'PRIMARY KEY(USER_ID))';
  SQL_10000001_CPY = 'INSERT INTO USERS_NEW SELECT * FROM USERS';
  SQL_10000001_DRP = 'DROP TABLE USERS';
  SQL_10000001_REN = 'ALTER TABLE USERS_NEW RENAME TO USERS';
  SQL_10000001_IDX = 'CREATE UNIQUE INDEX USERS_ID_idx ON USERS( USER_ID )';

  SQL_10000010_NEW = 'CREATE TABLE SHOP_NEW(' +
                     'USER_ID INTEGER NOT NULL, ' +
                     'SHOP_ID INTEGER NOT NULL, ' +
                     'SHOP_NAME VARCHAR(128) NOT NULL, ' +
                     'PHONE_NUM VARCHAR(16), ' +
                     'START_BUSINESS_DT DATETIME, ' +
                     'END_BUSINESS_DT DATETIME, ' +
                     'DO_ROUND BOOLEAN, ' +
                     'DO_TRUNCATE BOOLEAN, ' +
                     'DO_ROUND_UP BOOLEAN, ' +
                     'DISABLED BOOLEAN NOT NULL, ' +
                     'ENTRY_DT DATETIME NOT NULL, ' +
                     'UPDATE_DT DATETIME, ' +
                     'PRIMARY KEY(USER_ID, SHOP_ID))';
  SQL_10000010_CPY = 'INSERT INTO SHOP_NEW SELECT * FROM SHOP';
  SQL_10000010_DRP = 'DROP TABLE SHOP';
  SQL_10000010_REN = 'ALTER TABLE SHOP_NEW RENAME TO SHOP';
  SQL_10000010_IDX = 'CREATE UNIQUE INDEX SHOP_ID_idx ON ' +
                     'SHOP(USER_ID, SHOP_ID)';

  SQL_10000016_NEW = 'CREATE TABLE ACCOUNT_NEW(' +
                     'USER_ID INTEGER NOT NULL, ' +
                     'ACCOUNT_ID INTEGER NOT NULL, ' +
                     'BRAND_NAME VARCHAR(32) NOT NULL, ' +
                     'SUB_NAME VARCHAR(32), ' +
                     'PHONE_NUM VARCHAR(16), ' +
                     'OPENING_BALANCE INTEGER, ' +
                     'CURRENT_BALANCE INTEGER, ' +
                     'DISABLED BOOLEAN NOT NULL, ' +
                     'ENTRY_DT DATETIME NOT NULL, ' +
                     'UPDATE_DT DATETIME, ' +
                     'PRIMARY KEY(USER_ID, ACCOUNT_ID))';
  SQL_10000016_CPY = 'INSERT INTO ACCOUNT_NEW SELECT * FROM ACCOUNT';
  SQL_10000016_DRP = 'DROP TABLE ACCOUNT';
  SQL_10000016_REN = 'ALTER TABLE ACCOUNT_NEW RENAME TO ACCOUNT';
  SQL_10000016_IDX = 'CREATE UNIQUE INDEX ACCOUNT_ID_idx ON ' +
                     'ACCOUNT(USER_ID, ACCOUNT_ID)';

  SQL_10000018_NEW = 'CREATE TABLE MAKER_NEW(' +
                     'USER_ID INTEGER NOT NULL, ' +
                     'MAKER_ID INTEGER NOT NULL, ' +
                     'MAKER_NAME VARCHAR(40) NOT NULL, ' +
                     'DISABLED BOOLEAN NOT NULL, ' +
                     'ENTRY_DT DATETIME NOT NULL, ' +
                     'UPDATE_DT DATETIME, ' +
                     'PRIMARY KEY(USER_ID, MAKER_ID))';
  SQL_10000018_CPY = 'INSERT INTO MAKER_NEW SELECT * FROM MAKER';
  SQL_10000018_DRP = 'DROP TABLE MAKER';
  SQL_10000018_REN = 'ALTER TABLE MAKER_NEW RENAME TO MAKER';
  SQL_10000018_IDX = 'CREATE UNIQUE INDEX MAKER_ID_idx ON ' +
                     'MAKER(USER_ID, MAKER_ID)';

  SQL_10000020_NEW = 'CREATE TABLE BRAND_NEW(' +
                     'USER_ID INTEGER NOT NULL, ' +
                     'MAKER_ID INTEGER NOT NULL, ' +
                     'BRAND_NAME_ID INTEGER NOT NULL, ' +
                     'BRAND_NAME VARCHAR(40) NOT NULL, ' +
                     'END_OF_SALES BOOLEAN NOT NULL, ' +
                     'DISABLED BOOLEAN NOT NULL, ' +
                     'ENTRY_DT DATETIME NOT NULL, ' +
                     'UPDATE_DT DATETIME, ' +
                     'PRIMARY KEY(USER_ID, MAKER_ID, BRAND_NAME_ID))';
  SQL_10000020_CPY = 'INSERT INTO BRAND_NEW SELECT * FROM BRAND';
  SQL_10000020_DRP = 'DROP TABLE BRAND';
  SQL_10000020_REN = 'ALTER TABLE BRAND_NEW RENAME TO BRAND';
  SQL_10000020_IDX = 'CREATE UNIQUE INDEX BRAND_ID_idx ON ' +
                     'BRAND(USER_ID, MAKER_ID, BRAND_NAME_ID)';

  SQL_10000022_NEW = 'CREATE TABLE UNIT_NEW(' +
                     'UNIT_ID SERIAL NOT NULL, ' +
                     'UNIT VARCHAR(16) NOT NULL, ' +
                     'ORDER_ID INTEGER NOT NULL, ' +
                     'DISABLED BOOLEAN NOT NULL, ' +
                     'ENTRY_DT DATETIME NOT NULL, ' +
                     'UPDATE_DT DATETIME, ' +
                     'PRIMARY KEY(UNIT_ID))';
  SQL_10000022_CPY = 'INSERT INTO UNIT_NEW SELECT * FROM UNIT';
  SQL_10000022_DRP = 'DROP TABLE UNIT';
  SQL_10000022_REN = 'ALTER TABLE UNIT_NEW RENAME TO UNIT';
  SQL_10000022_IDX = 'CREATE UNIQUE INDEX UNIT_ID_idx ON ' +
                     'UNIT(UNIT_ID)';

  SQL_10000024_NEW = 'CREATE TABLE TAX_TYPE_NEW(' +
                     'USER_ID INTEGER NOT NULL, ' +
                     'TAX_TYPE_ID INTEGER NOT NULL, ' +
                     'TAX_RATE_ID INTEGER NOT NULL, ' +
                     'TAX_TYPE VARCHAR(16) NOT NULL, ' +
                     'ORDER_ID INTEGER NOT NULL, ' +
                     'ENTRY_DT DATETIME NOT NULL, ' +
                     'UPDATE_DT DATETIME, ' +
                     'PRIMARY KEY(USER_ID, TAX_TYPE_ID, TAX_RATE_ID, ORDER_ID))';
  SQL_10000024_CPY = 'INSERT INTO TAX_TYPE_NEW SELECT * FROM TAX_TYPE';
  SQL_10000024_DRP = 'DROP TABLE TAX_TYPE';
  SQL_10000024_REN = 'ALTER TABLE TAX_TYPE_NEW RENAME TO TAX_TYPE';
  SQL_10000024_IDX = 'CREATE UNIQUE INDEX TAX_TYPE_ID_idx ON ' +
                     'TAX_TYPE(USER_ID, TAX_TYPE_ID, TAX_RATE_ID)';

  SQL_10000026_NEW = 'CREATE TABLE TAX_RATE_NEW(' +
                     'USER_ID INTEGER NOT NULL, ' +
                     'TAX_RATE_ID INTEGER NOT NULL, ' +
                     'TAX_RATE INTEGER NOT NULL, ' +
                     'DISABLED BOOLEAN NOT NULL, ' +
                     'ENTRY_DT DATETIME NOT NULL, ' +
                     'UPDATE_DT DATETIME, ' +
                     'PRIMARY KEY(USER_ID, TAX_RATE_ID))';
  SQL_10000026_CPY = 'INSERT INTO TAX_RATE_NEW SELECT * FROM TAX_RATE';
  SQL_10000026_DRP = 'DROP TABLE TAX_RATE';
  SQL_10000026_REN = 'ALTER TABLE TAX_RATE_NEW RENAME TO TAX_RATE';
  SQL_10000026_IDX = 'CREATE UNIQUE INDEX TAX_RATE_ID_idx ON ' +
                     'TAX_RATE(USER_ID, TAX_RATE_ID)';

implementation

end.


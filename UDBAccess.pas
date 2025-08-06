unit UDBAccess;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const
  // UEntryAdmin
  SQL_10000001 = 'CREATE TABLE USERS(' +
                 'USER_ID INTEGER NOT NULL PRIMARY KEY, ' +
                 'NAME VARCHAR(128) NOT NULL UNIQUE, ' +
                 'PAW VARCHAR(128) NOT NULL, ' +
                 'ROLE INTEGER NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME)';
  SQL_10000002 = 'CREATE UNIQUE INDEX USERS_ID_idx ON USERS( USER_ID )';
  SQL_10000003 = 'INSERT INTO USERS(NAME, PAW, ROLE, ENTRY_DT) ' +
                 'VALUES (:pUserId, :pPaw, :pRole, :pEntryDT)';
  SQL_10000004 = 'CREATE TABLE EXP1(' +
                 'USER_ID INTEGER NOT NULL, ' +
                 'EXP_KEY1 INTEGER NOT NULL, ' +
                 'ORDER_KEY1 INTEGER NOT NULL, ' +
                 'NAME1 VARCHAR(128) NOT NULL, ' +
                 'DISABLED1 BOOLEAN NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME, ' +
                 'PRIMARY KEY(USER_ID, EXP_KEY1, ORDER_KEY1))';
  SQL_10000005 = 'CREATE UNIQUE INDEX EXP1_ID_idx ON EXP1( USER_ID, ' +
                 'EXP_KEY1, ORDER_KEY1, DISABLED1 )';
  SQL_10000006 = 'CREATE TABLE EXP2(' +
                 'USER_ID INTEGER NOT NULL, ' +
                 'EXP_KEY1 INTEGER NOT NULL, ' +
                 'EXP_KEY2 INTEGER NOT NULL, ' +
                 'ORDER_KEY2 INTEGER NOT NULL, ' +
                 'NAME2 VARCHAR(128) NOT NULL, ' +
                 'DISABLED2 BOOLEAN NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME, ' +
                 'PRIMARY KEY(USER_ID, EXP_KEY1, EXP_KEY2, ORDER_KEY2))';
  SQL_10000007 = 'CREATE UNIQUE INDEX EXP2_ID_idx ON EXP2(USER_ID, ' +
                 'EXP_KEY1, EXP_KEY2, ORDER_KEY2, DISABLED2 )';
  SQL_10000008 = 'CREATE TABLE EXP3(' +
                 'USER_ID INTEGER NOT NULL, ' +
                 'EXP_KEY1 INTEGER NOT NULL, ' +
                 'EXP_KEY2 INTEGER NOT NULL, ' +
                 'EXP_KEY3 INTEGER NOT NULL, ' +
                 'ORDER_KEY3 INTEGER NOT NULL, ' +
                 'NAME3 VARCHAR(128) NOT NULL, ' +
                 'DISABLED3 BOOLEAN NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME, ' +
                 'PRIMARY KEY(USER_ID, EXP_KEY1, EXP_KEY2, EXP_KEY3, ' +
                 'ORDER_KEY3))';
  SQL_10000009 = 'CREATE UNIQUE INDEX EXP3_ID_idx ON EXP3( USER_ID, ' +
                 'EXP_KEY1, EXP_KEY2, EXP_KEY3, ORDER_KEY3, ' +
                 'DISABLED3 )';
  SQL_10000010 = 'CREATE TABLE SHOP(' +
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
                 'UPDATE_DT DATETIME)';
  SQL_10000011 = 'CREATE UNIQUE INDEX SHOP_ID_idx ON ' +
                 'SHOP(USER_ID, SHOP_ID)';
  SQL_10000012 = 'CREATE TABLE DETAILS_HEADER(' +
                 'USER_ID INTEGER NOT NULL, ' +
                 'HEADER_ID INTEGER NOT NULL, ' +
                 'HEADER_DT DATETIME NOT NULL, ' +
                 'SHOP_ID INTEGER NOT NULL, ' +
                 'EXP_KEY1 INTEGER NOT NULL, ' +
                 'FROM_ID INTEGER, ' +
                 'TO_ID INTEGER, ' +
                 'TOTAL_AMOUNT INTEGER, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME, ' +
                 'PRIMARY KEY(USER_ID, HEADER_ID))';
  SQL_10000013 = 'CREATE UNIQUE INDEX DETAILS_HEADER_ID_idx ON ' +
                 'DETAILS_HEADER(USER_ID, HEADER_ID)';
  SQL_10000014 = 'CREATE TABLE DETAILS(' +
                 'USER_ID INTEGER NOT NULL, ' +
                 'HEADER_ID INTEGER NOT NULL, ' +
                 'DETAIL_ID INTEGER NOT NULL, ' +
                 'EXP_KEY1 INTEGER NOT NULL, ' +
                 'EXP_KEY2 INTEGER, ' +
                 'EXP_KEY3 INTEGER, ' +
                 'MAKER_ID INTEGER NOT NULL, ' +
                 'BRAND_NAME_ID INTEGER NOT NULL, ' +
                 'QUANTITY INTEGER NOT NULL, ' +
                 'UNIT_ID INTEGER NOT NULL, ' +
                 'EXCLUDE_TAX INTEGER NOT NULL, ' +
                 'TAX_TYPE_ID INTEGER NOT NULL, ' +
                 'TAX_RATE_ID INTEGER NOT NULL, ' +
                 'TAX INTEGER, ' +
                 'SUB_TOTAL INTEGER NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME, ' +
                 'PRIMARY KEY(USER_ID, HEADER_ID, DETAIL_ID))';
  SQL_10000015 = 'CREATE UNIQUE INDEX DETAILS_ID_idx ON ' +
                 'DETAILS(USER_ID, HEADER_ID, DETAIL_ID)';
  SQL_10000016 = 'CREATE TABLE ACCOUNT(' +
                 'USER_ID INTEGER NOT NULL, ' +
                 'ACCOUNT_ID INTEGER NOT NULL, ' +
                 'BRAND_NAME VARCHAR(32) NOT NULL, ' +
                 'SUB_NAME VARCHAR(32), ' +
                 'PHONE_NUM VARCHAR(16), ' +
                 'OPENING_BALANCE INTEGER, ' +
                 'CURRENT_BALANCE INTEGER, ' +
                 'DISABLED BOOLEAN NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME)';
  SQL_10000017 = 'CREATE UNIQUE INDEX ACCOUNT_ID_idx ON ' +
                 'ACCOUNT(USER_ID, ACCOUNT_ID)';
  SQL_10000018 = 'CREATE TABLE MAKER(' +
                 'USER_ID INTEGER NOT NULL, ' +
                 'MAKER_ID INTEGER NOT NULL, ' +
                 'MAKER_NAME VARCHAR(40) NOT NULL, ' +
                 'DISABLED BOOLEAN NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME)';
  SQL_10000019 = 'CREATE UNIQUE INDEX MAKER_ID_idx ON ' +
                 'MAKER(USER_ID, MAKER_ID)';
  SQL_10000020 = 'CREATE TABLE BRAND(' +
                 'USER_ID INTEGER NOT NULL, ' +
                 'MAKER_ID INTEGER NOT NULL, ' +
                 'BRAND_NAME_ID INTEGER NOT NULL, ' +
                 'BRAND_NAME VARCHAR(40) NOT NULL, ' +
                 'END_OF_SALES BOOLEAN NOT NULL, ' +
                 'DISABLED BOOLEAN NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME)';
  SQL_10000021 = 'CREATE UNIQUE INDEX BRAND_ID_idx ON ' +
                 'BRAND(USER_ID, MAKER_ID, BRAND_NAME_ID)';
  SQL_10000022 = 'CREATE TABLE UNIT(' +
                 'UNIT_ID SERIAL NOT NULL PRIMARY KEY, ' +
                 'UNIT VARCHAR(16) NOT NULL, ' +
                 'ORDER_ID INTEGER NOT NULL, ' +
                 'DISABLED BOOLEAN NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME)';
  SQL_10000023 = 'CREATE TABLE TAX_TYPE(' +
                 'USER_ID INTEGER NOT NULL, ' +
                 'TAX_TYPE_ID INTEGER NOT NULL, ' +
                 'TAX_RATE_ID INTEGER NOT NULL, ' +
                 'TAX_TYPE VARCHAR(16) NOT NULL, ' +
                 'ORDER_ID INTEGER NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME)';
  SQL_10000024 = 'CREATE UNIQUE INDEX TAX_TYPE_ID_idx ON ' +
                 'TAX_TYPE(USER_ID, TAX_TYPE_ID, TAX_RATE_ID)';
  SQL_10000025 = 'CREATE TABLE TAX_RATE(' +
                 'USER_ID INTEGER NOT NULL, ' +
                 'TAX_RATE_ID INTEGER NOT NULL, ' +
                 'TAX_RATE INTEGER NOT NULL, ' +
                 'DISABLED BOOLEAN NOT NULL, ' +
                 'ENTRY_DT DATETIME NOT NULL, ' +
                 'UPDATE_DT DATETIME)';
  SQL_10000026 = 'CREATE UNIQUE INDEX TAX_RATE_ID_idx ON ' +
                 'TAX_RATE(USER_ID, TAX_RATE_ID)';
  SQL_10000027 = 'CREATE VIEW BRAND_VIEW (USER_ID, MAKER_ID, MAKER_NAME, ' +
                 'BRAND_NAME_ID, BRAND_NAME, END_OF_SALES, DISABLED, ' +
                 'ENTRY_DT, UPDATE_DT) AS SELECT B.USER_ID, B.MAKER_ID, ' +
                 'M.MAKER_NAME, B.BRAND_NAME_ID, B.BRAND_NAME, ' +
                 'B.END_OF_SALES, B.DISABLED, B.ENTRY_DT, B.UPDATE_DT ' +
                 'FROM BRAND B LEFT OUTER JOIN MAKER M ' +
                 'ON M.USER_ID = B.USER_ID AND M.MAKER_ID = B.MAKER_ID';

  // ULogin
  SQL_20010001 = 'SELECT USER_ID, NAME, ROLE FROM USERS ' +
                 'WHERE NAME = :pUName AND PAW = :pPaw';
  // UManageUser
  SQL_20020001 = 'SELECT USER_ID, NAME, PAW, ROLE, ENTRY_DT, UPDATE_DT ' +
                 'FROM USERS';
  SQL_20020002 = 'SELECT USER_ID, NAME, PAW, ROLE, ENTRY_DT, UPDATE_DT ' +
                 'FROM USERS WHERE NAME = :pUName';
  SQL_20020003 = 'SELECT COUNT(USER_ID) AS COUNT ' +
                 'FROM USERS WHERE ROLE = :pRole';

  // UAddUser
  SQL_20030001 = 'INSERT INTO USERS(NAME, PAW, ROLE, ENTRY_DT) ' +
                 'VALUES (:pUName, :pPaw, :pRole, :pEntryDT)';
  SQL_20030002 = 'SELECT USER_ID, NAME FROM USERS WHERE NAME = :pUName';

  // UEditUser and UEditAdminUser
  SQL_20040001 = 'SELECT USER_ID, NAME, ROLE, PAW, ENTRY_DT, UPDATE_DT ' +
                 'FROM USERS WHERE ROLE = :pRole';
  SQL_20040002 = 'SELECT USER_ID, NAME, ROLE, PAW, ENTRY_DT, UPDATE_DT ' +
                 'FROM USERS WHERE ROLE = :pRole AND NAME = :pName';
  SQL_20040003 = 'UPDATE USERS SET :pFieldAndValue WHERE USER_ID = :pUserID';

  // URemoveUser 
  SQL_20050001 = 'SELECT USER_ID, NAME, ROLE, ENTRY_DT, UPDATE_DT ' +
                 'FROM USERS WHERE ROLE = :pRole';
  SQL_20050002 = 'DELETE FROM USERS WHERE USER_ID = :pUserId';

  // UManageExp
  SQL_20060001 = 'SELECT E1.USER_ID AS USER_ID, U.NAME AS UNAME, ' +
                 'E1.EXP_KEY1 AS EXP_KEY1, E1.NAME1 AS NAME1, ' +
                 'E1.DISABLED1 AS DISABLED1, E1.ORDER_KEY1 AS ' +
                 'ORDER_KEY1, E1.ENTRY_DT AS ENTRY_DT, E1.UPDATE_DT AS ' +
                 'UPDATE_DT FROM EXP1 E1 JOIN USERS U ON E1.USER_ID = ' +
                 'U.USER_ID ORDER BY E1.USER_ID, E1.ORDER_KEY1';
  SQL_20060002 = 'SELECT E1.USER_ID AS USER_ID, U.NAME AS UNAME, ' +
                 'E1.EXP_KEY1 AS EXP_KEY1, E1.NAME1 AS NAME1, ' +
                 'E1.DISABLED1 AS DISABLED1, E1.ORDER_KEY1 AS ' +
                 'ORDER_KEY1, E1.ENTRY_DT AS ENTRY_DT, E1.UPDATE_DT AS ' +
                 'UPDATE_DT FROM EXP1 E1 JOIN USERS U ON E1.USER_ID = ' +
                 'U.USER_ID WHERE E1.USER_ID = :pUserID ORDER BY E1.ORDER_KEY1';
  // UManageExp and UManageDetails
  SQL_20060003 = 'SELECT USER_ID, EXP_KEY1, EXP_KEY2, NAME2, ' +
                 'DISABLED2, ORDER_KEY2, ENTRY_DT, UPDATE_DT FROM EXP2 ' +
                 'WHERE USER_ID = :pUserID AND EXP_KEY1 = :pExpKey1 ORDER BY ' +
                 'ORDER_KEY2';
  SQL_20060004 = 'SELECT USER_ID, EXP_KEY1, EXP_KEY2, EXP_KEY3, ' +
                 'NAME3, DISABLED3, ORDER_KEY3, ENTRY_DT, UPDATE_DT FROM EXP3 ' +
                 'WHERE USER_ID = :pUserID AND EXP_KEY1 = :pExpKey1 AND ' +
                 'EXP_KEY2 = :pExpKey2 ORDER BY ORDER_KEY3';
  // UManageExp
  SQL_20060005 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'NAME2, DISABLED2, ORDER_KEY2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES(:pUserID, :pExpKey1, (SELECT COALESCE(MAX(EXP_KEY2),' +
                 '0) + 1 AS EXP_KEY2 FROM EXP2 WHERE USER_ID = :pUserID AND ' +
                 'EXP_KEY1 = :pExpKey1), :pName2, FALSE, (SELECT ' +
                 'COALESCE(MAX(ORDER_KEY2), 0) + 1 AS ORDER_KEY2 FROM EXP2 ' +
                 'WHERE USER_ID = :pUserID AND EXP_KEY1 = :pExpKey1), ' +
                 ':pEntryDT, NULL)';
  SQL_20060006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, NAME3, DISABLED3, ORDER_KEY3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES(:pUserID, :pExpKey1, :pExpKey2, (SELECT ' +
                 'COALESCE(MAX(EXP_KEY3), 0) + 1 AS EXP_KEY3 FROM EXP3 WHERE ' +
                 'USER_ID = :pUserID AND EXP_KEY1 = :pExpKey1 AND EXP_KEY2 = ' +
                 ':pExpKey2), :pName3, FALSE, (SELECT ' +
                 'COALESCE(MAX(ORDER_KEY3), 0) + 1 AS ORDER_KEY3 FROM EXP3 ' +
                 'WHERE USER_ID = :pUserID AND EXP_KEY1 = :pExpKey1 AND ' +
                 'EXP_KEY2 = :pExpKey2), :pEntryDT, NULL)';
  SQL_20060007 = 'UPDATE EXP2 SET NAME2 = :pName2, DISABLED2 = ' +
                 ':pDisabled2, ORDER_KEY2 = :pOrderKey2, UPDATE_DT = ' +
                 ':pUpdateDT WHERE USER_ID = :pUserID AND EXP_KEY1 = ' +
                 ':pExpKey1 AND EXP_KEY2 = :pExpKey2';
  SQL_20060008 = 'UPDATE EXP3 SET NAME3 = :pName3, DISABLED3 = ' +
                 ':pDisabled3, ORDER_KEY3 = :pOrderKey3, UPDATE_DT = ' +
                 ':pUpdateDT WHERE USER_ID = :pUserID AND EXP_KEY1 = ' +
                 ':pExpKey1 AND EXP_KEY2 = :pExpKey2 AND EXP_KEY3 = ' +
                 ':pExpKey3';
  SQL_20060009 = 'UPDATE EXP2 SET ORDER_KEY2 = :pOrderKey2 WHERE USER_ID = ' +
                 ':pUserID AND EXP_KEY1 = :pExpKey1 AND EXP_KEY2 = :pExpKey2';
  SQL_20060010 = 'UPDATE EXP2 SET DISABLED2 = :pDisabled2, UPDATE_DT = ' +
                 ':pUpdateDT WHERE USER_ID = :pUserID AND EXP_KEY1 = ' +
                 ':pExpKey1 AND EXP_KEY2 = :pExpKey2';
  SQL_20060011 = 'UPDATE EXP3 SET DISABLED3 = :pDisabled3, UPDATE_DT = ' +
                 ':pUpdateDT WHERE USER_ID = :pUserID AND EXP_KEY1 = ' +
                 ':pExpKey1 AND EXP_KEY2 = :pExpKey2 AND EXP_KEY3 = ' +
                 ':pExpKey3';
  SQL_20060012 = 'UPDATE EXP2 SET ORDER_KEY2 = :pOrderKey2, UPDATE_DT = ' +
                 ':pUpdateDT WHERE USER_ID = :pUserID AND EXP_KEY1 = ' +
                 ':pExpKey1 AND EXP_KEY2 = :pExpKey2';
  SQL_20060013 = 'UPDATE EXP3 SET ORDER_KEY3 = :pOrderKey3, UPDATE_DT = ' +
                 ':pUpdateDT WHERE USER_ID = :pUserID AND EXP_KEY1 = ' +
                 ':pExpKey1 AND EXP_KEY2 = :pExpKey2 AND EXP_KEY3 = ' +
                 ':pExpKey3';
  SQL_20060014 = 'UPDATE EXP2 SET ORDER_KEY2 = EXP_KEY2, UPDATE_DT = ' +
                 'datetime(''now'', ''+9 hours'') WHERE USER_ID = :pUserID ' +
                 'AND EXP_KEY1 = :pExpKey1';
  SQL_20060015 = 'UPDATE EXP3 SET ORDER_KEY3 = EXP_KEY3, UPDATE_DT = ' +
                 'datetime(''now'', ''+9 hours'') WHERE USER_ID = :pUserID ' +
                 'AND EXP_KEY1 = :pExpKey1 AND EXP_KEY2 = :pExpKey2';

  // UTopMenu
  SQL_20070001 = 'SELECT COUNT(USER_ID) AS COUNT FROM EXP1';
  SQL_20070002 = 'SELECT COUNT(USER_ID) AS COUNT FROM EXP1 WHERE USER_ID = ' +
                 ':pUserID';

  // UEntryShop
  SQL_20080001 = 'SELECT * FROM SHOP WHERE USER_ID = :pUserID ORDER BY ' +
                 'SHOP_NAME ASC';
  SQL_20080002 = 'SELECT COALESCE(MAX(SHOP_ID), 0) + 1 AS NEXT_ID FROM ' +
                 'SHOP WHERE USER_ID = :pUserID';
  SQL_20080003 = 'INSERT INTO SHOP(USER_ID, SHOP_ID, SHOP_NAME, PHONE_NUM, ' +
                 'START_BUSINESS_DT, END_BUSINESS_DT, DO_ROUND, DO_TRUNCATE, ' +
                 'DO_ROUND_UP, DISABLED, ENTRY_DT, UPDATE_DT) VALUES(' +
                 ':pUserID, :pShopID, :pShopName, :pPhoneNum, ' +
                 ':pStartBusinessDT, :pEndBusinessDT, FALSE, FALSE, FALSE, ' +
                 ':pDisabled, :pEntryDT, NULL) ON CONFLICT (USER_ID, ' +
                 'SHOP_ID) DO UPDATE SET SHOP_NAME = :pShopName, PHONE_NUM ' +
                 '= :pPhoneNum, START_BUSINESS_DT = :pStartBusinessDT, ' +
                 'END_BUSINESS_DT = :pEndBusinessDT, DISABLED = :pDisabled, ' +
                 'UPDATE_DT = :pUpdateDT';

  // UManageDetails
  SQL_20090001 = 'SELECT DH.USER_ID AS USER_ID, DH.HEADER_ID AS HEADER_ID, ' +
                 'DH.HEADER_DT AS HEADER_DT, DH.SHOP_ID AS SHOP_ID, ' +
                 '(SELECT S.SHOP_NAME FROM SHOP S WHERE S.USER_ID = ' +
                 'DH.USER_ID AND S.SHOP_ID = DH.SHOP_ID) AS SHOP_NAME, ' +
                 'DH.EXP_KEY1 AS EXP_KEY1, (SELECT E1.NAME1 FROM EXP1 E1 ' +
                 'WHERE E1.USER_ID = DH.USER_ID AND E1.EXP_KEY1 = ' +
                 'DH.EXP_KEY1) AS EXP1, DH.FROM_ID AS FROM_ID, ' +
                 'CAST(AF.BRAND_NAME||'' ''||AF.SUB_NAME AS VARCHAR) ' +
                 'AS FROM_NAME, DH.TO_ID AS TO_ID, ' +
                 'CAST(AT.BRAND_NAME||'' ''||AT.SUB_NAME AS VARCHAR) ' +
                 'AS TO_NAME, DH.TOTAL_AMOUNT AS TOTAL_AMOUNT, ' +
                 'DH.ENTRY_DT AS ENTRY_DT, DH.UPDATE_DT AS UPDATE_DT ' +
                 'FROM DETAILS_HEADER DH ' +
                 'LEFT OUTER JOIN ACCOUNT AF ON AF.USER_ID = DH.USER_ID ' +
                 'AND AF.ACCOUNT_ID = DH.FROM_ID ' +
                 'LEFT OUTER JOIN ACCOUNT AT ON AT.USER_ID = DH.USER_ID ' +
                 'AND AT.ACCOUNT_ID = DH.TO_ID ' +
                 'WHERE DH.USER_ID = :pUserID ORDER BY strftime(' +
                 '''%Y-%m-%d %H'', HEADER_DT) DESC, HEADER_ID DESC';
  SQL_20090002 = 'DELETE FROM DETAILS WHERE USER_ID = :pUserID AND ' +
                 'HEADER_ID = :pHeaderID';
  SQL_20090003 = 'DELETE FROM DETAILS_HEADER WHERE USER_ID = :pUserID AND ' +
                 'HEADER_ID = :pHeaderID';

  // UAddDetailsHeader and UEditDetailsHeader
  SQL_20100001 = 'SELECT USER_ID, SHOP_ID, SHOP_NAME, PHONE_NUM, DO_ROUND, ' +
                 'DO_TRUNCATE, DO_ROUND_UP, DISABLED FROM SHOP WHERE ' +
                 'USER_ID = :pUserID AND DISABLED = FALSE ORDER BY ' +
                 'SHOP_NAME ASC';
  SQL_20100002 = 'SELECT USER_ID, EXP_KEY1, NAME1, DISABLED1 ' +
                 'FROM EXP1 WHERE USER_ID = :pUserID AND DISABLED1 = FALSE ' +
                 'ORDER BY EXP_KEY1 ASC';
  SQL_20100003 = 'SELECT USER_ID, ACCOUNT_ID FROM_ID, ' +
                 'CAST(BRAND_NAME||'' ''||SUB_NAME AS VARCHAR) ' +
                 'AS FROM_NAME, DISABLED FROM ACCOUNT WHERE USER_ID ' +
                 '= :pUserID AND DISABLED = FALSE ORDER BY FROM_ID ASC';
  SQL_20100004 = 'SELECT USER_ID, ACCOUNT_ID TO_ID, ' +
                 'CAST(BRAND_NAME||'' ''||SUB_NAME AS VARCHAR) ' +
                 'AS TO_NAME, DISABLED FROM ACCOUNT WHERE USER_ID ' +
                 '= :pUserID AND DISABLED = FALSE ORDER BY TO_ID ASC';
  SQL_20100005 = 'SELECT COALESCE(MAX(HEADER_ID), 0) + 1 AS ' +
                 'NEXT_ID FROM DETAILS_HEADER WHERE USER_ID = :pUserID';
  SQL_20100006 = 'SELECT USER_ID, HEADER_ID, HEADER_DT, SHOP_ID, EXP_KEY1, ' +
                 'FROM_ID, TO_ID, TOTAL_AMOUNT, ENTRY_DT, UPDATE_DT ' +
                 'FROM DETAILS_HEADER WHERE USER_ID = :pUserID AND HEADER_ID ' +
                 '= :pHeaderID';
  SQL_20100007 = 'INSERT INTO DETAILS_HEADER(USER_ID, HEADER_ID, HEADER_DT, ' +
                 'SHOP_ID, EXP_KEY1, FROM_ID, TO_ID, TOTAL_AMOUNT, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES(:pUserID, :pHeaderID, :pHeaderDT, ' +
                 ':pShopID, :pExpKey1, :pFromID, :pToID, :pTotalAmount, ' +
                 ':pEntryDT, NULL)';
  SQL_20100008 = 'UPDATE DETAILS_HEADER SET HEADER_DT = :pHeaderDT, ' +
                 'SHOP_ID = :pShopID, EXP_KEY1 = :pExpKey1, FROM_ID = ' +
                 ':pFromID, TO_ID = :pToID, TOTAL_AMOUNT = :pTotalAmount, ' +
                  'UPDATE_DT = :pUpdateDT WHERE USER_ID = :pUserID AND ' +
                 'HEADER_ID = :pHeaderID';
  SQL_20100009 = 'SELECT D.USER_ID, D.HEADER_ID, D.DETAIL_ID, D.MAKER_ID, ' +
                 'M.MAKER_NAME, D.BRAND_NAME_ID, B.BRAND_NAME, D.EXP_KEY1, ' +
                 'E1.NAME1 AS EXP1, COALESCE(D.EXP_KEY2, 0) AS EXP_KEY2, ' +
                 'E2.NAME2 AS EXP2, COALESCE(D.EXP_KEY3, 0) ' +
                 'AS EXP_KEY3, E3.NAME3 AS EXP3, D.QUANTITY AS QUANTITY, ' +
                 'D.UNIT_ID, U.UNIT AS UNIT, D.EXCLUDE_TAX, D.TAX_TYPE_ID, ' +
                 'T.TAX_TYPE, D.TAX, D.SUB_TOTAL FROM DETAILS D LEFT JOIN ' +
                 'MAKER M ON D.MAKER_ID = M.MAKER_ID LEFT JOIN BRAND B ON ' +
                 'D.USER_ID = B.USER_ID AND D.MAKER_ID = B.MAKER_ID AND ' +
                 'D.BRAND_NAME_ID = B.BRAND_NAME_ID LEFT JOIN EXP1 E1 ON ' +
                 'D.USER_ID = E1.USER_ID AND D.EXP_KEY1 = E1.EXP_KEY1 ' +
                 'LEFT JOIN EXP2 E2 ON D.USER_ID = E2.USER_ID AND D.EXP_KEY1 ' +
                 '= E2.EXP_KEY1 AND D.EXP_KEY2 = E2.EXP_KEY2 LEFT JOIN ' +
                 'EXP3 E3 ON D.USER_ID = E3.USER_ID AND D.EXP_KEY1 = ' +
                 'E3.EXP_KEY1 AND D.EXP_KEY2 = E3.EXP_KEY2 AND D.EXP_KEY3 = ' +
                 'E3.EXP_KEY3 LEFT JOIN UNIT U ON D.UNIT_ID = U.UNIT_ID ' +
                 'LEFT JOIN TAX_TYPE T ON D.USER_ID = T.USER_ID AND ' +
                 'D.TAX_TYPE_ID = T.TAX_TYPE_ID WHERE D.USER_ID = :pUserID ' +
                 'AND D.HEADER_ID = :pHeaderID ORDER BY D.DETAIL_ID DESC';
  SQL_20100010 = 'SELECT USER_ID, HEADER_ID, DETAIL_ID, MAKER_ID, ' +
                 'BRAND_NAME_ID, EXP_KEY1, QUANTITY, UNIT_ID, EXCLUDE_TAX, ' +
                 'TAX_TYPE_ID, TAX, SUB_TOTAL FROM DETAILS ' +
                 'WHERE USER_ID = :pUserID AND HEADER_ID = :pHeaderID';
  SQL_20100011 = 'SELECT HEADER_ID, DETAIL_ID, SUM(INCLUSIVE_TAX) AS ' +
                 'TOTAL_AMOUNT FROM (SELECT HEADER_ID, DETAIL_ID, TAX_TYPE, ' +
                 'TAX_RATE, CAST(TOTAL_AMOUNT AS VARCHAR) AS TOTAL_AMOUNT, ' +
                 'ROUND(TOTAL_AMOUNT * RATE) AS INCLUSIVE_TAX FROM (SELECT ' +
                 'D.HEADER_ID AS HEADER_ID, D.DETAIL_ID AS DETAIL_ID, CAST(' +
                 'TT.TAX_TYPE AS VARCHAR) AS TAX_TYPE, CAST(TR.TAX_RATE AS ' +
                 'VARCHAR) AS TAX_RATE, SUM(D.EXCLUDE_TAX) AS TOTAL_AMOUNT, ' +
                 '1 + (CAST(TR.TAX_RATE AS REAL) / 100) AS RATE FROM DETAILS ' +
                 'D JOIN TAX_TYPE TT ON D.USER_ID = TT.USER_ID AND ' +
                 'D.TAX_TYPE_ID = TT.TAX_TYPE_ID JOIN TAX_RATE TR ON ' +
                 'D.USER_ID = TR.USER_ID AND D.TAX_RATE_ID = TR.TAX_RATE_ID ' +
                 'WHERE D.USER_ID = :pUserID AND D.HEADER_ID = :pHeaderID ' +
                 'GROUP BY D.HEADER_ID, D.DETAIL_ID, TT.TAX_TYPE, TR.TAX_RATE' +
                 '))';
  SQL_20100012 = 'SELECT HEADER_ID, DETAIL_ID, SUM(INCLUSIVE_TAX) AS ' +
                 'TOTAL_AMOUNT FROM (SELECT HEADER_ID, DETAIL_ID, TAX_TYPE, ' +
                 'TAX_RATE, CAST(TOTAL_AMOUNT AS VARCHAR) AS TOTAL_AMOUNT, ' +
                 'TRUNC(TOTAL_AMOUNT * RATE) AS INCLUSIVE_TAX FROM (SELECT ' +
                 'D.HEADER_ID AS HEADER_ID, D.DETAIL_ID AS DETAIL_ID, CAST(' +
                 'TT.TAX_TYPE AS VARCHAR) AS TAX_TYPE, CAST(TR.TAX_RATE AS ' +
                 'VARCHAR) AS TAX_RATE, SUM(D.EXCLUDE_TAX) AS TOTAL_AMOUNT, ' +
                 '1 + (CAST(TR.TAX_RATE AS REAL) / 100) AS RATE FROM DETAILS ' +
                 'D JOIN TAX_TYPE TT ON D.USER_ID = TT.USER_ID AND ' +
                 'D.TAX_TYPE_ID = TT.TAX_TYPE_ID JOIN TAX_RATE TR ON ' +
                 'D.USER_ID = TR.USER_ID AND D.TAX_RATE_ID = TR.TAX_RATE_ID ' +
                 'WHERE D.USER_ID = :pUserID AND D.HEADER_ID = :pHeaderID ' +
                 'GROUP BY D.HEADER_ID, D.DETAIL_ID, TT.TAX_TYPE, TR.TAX_RATE' +
                 '))';
  SQL_20100013 = 'SELECT HEADER_ID, DETAIL_ID, SUM(INCLUSIVE_TAX) AS ' +
                 'TOTAL_AMOUNT FROM (SELECT HEADER_ID, DETAIL_ID, TAX_TYPE, ' +
                 'TAX_RATE, CAST(TOTAL_AMOUNT AS VARCHAR) AS TOTAL_AMOUNT, ' +
                 'CEIL(TOTAL_AMOUNT * RATE) AS INCLUSIVE_TAX FROM (SELECT ' +
                 'D.HEADER_ID AS HEADER_ID, D.DETAIL_ID AS DETAIL_ID, CAST(' +
                 'TT.TAX_TYPE AS VARCHAR) AS TAX_TYPE, CAST(TR.TAX_RATE AS ' +
                 'VARCHAR) AS TAX_RATE, SUM(D.EXCLUDE_TAX) AS TOTAL_AMOUNT, ' +
                 '1 + (CAST(TR.TAX_RATE AS REAL) / 100) AS RATE FROM DETAILS ' +
                 'D JOIN TAX_TYPE TT ON D.USER_ID = TT.USER_ID AND ' +
                 'D.TAX_TYPE_ID = TT.TAX_TYPE_ID JOIN TAX_RATE TR ON ' +
                 'D.USER_ID = TR.USER_ID AND D.TAX_RATE_ID = TR.TAX_RATE_ID ' +
                 'WHERE D.USER_ID = :pUserID AND D.HEADER_ID = :pHeaderID ' +
                 'GROUP BY D.HEADER_ID, D.DETAIL_ID, TT.TAX_TYPE, TR.TAX_RATE' +
                 '))';
  SQL_20100014 = 'UPDATE SHOP SET DO_ROUND = TRUE, DO_TRUNCATE = FALSE, ' +
                 'DO_ROUND_UP = FALSE WHERE USER_ID = :pUserID AND SHOP_ID ' +
                 '= :pShopID';
  SQL_20100015 = 'UPDATE SHOP SET DO_ROUND = FALSE, DO_TRUNCATE = TRUE, ' +
                 'DO_ROUND_UP = FALSE WHERE USER_ID = :pUserID AND SHOP_ID ' +
                 '= :pShopID';
  SQL_20100016 = 'UPDATE SHOP SET DO_ROUND = FALSE, DO_TRUNCATE = FALSE, ' +
                 'DO_ROUND_UP = TRUE WHERE USER_ID = :pUserID AND SHOP_ID ' +
                 '= :pShopID';

  // UEntryAccount
  SQL_20110001 = 'SELECT * FROM ACCOUNT WHERE USER_ID = :pUserID ORDER BY ' +
                 'ACCOUNT_ID ASC';
  SQL_20110002 = 'SELECT COALESCE(MAX(ACCOUNT_ID), 0) + 1 AS NEXT_ID ' +
                 'FROM ACCOUNT WHERE USER_ID = :pUserID';
  SQL_20110003 = 'INSERT INTO ACCOUNT(USER_ID, ACCOUNT_ID, BRAND_NAME, ' +
                 'SUB_NAME, PHONE_NUM,OPENING_BALANCE, CURRENT_BALANCE, ' +
                 'DISABLED, ENTRY_DT, UPDATE_DT) VALUES(:pUserID, ' +
                 ':pAccountID, :pBrandName, :pSubName, :pPhoneNum, ' +
                 ':pOpeningBalance, :pCurrentBalance, :pDisabled, :pEntryDT, ' +
                 'NULL) ON CONFLICT (USER_ID, ACCOUNT_ID) DO UPDATE SET ' +
                 'BRAND_NAME = :pBrandName, SUB_NAME = :pSubName, PHONE_NUM ' +
                 '= :pPhoneNum, OPENING_BALANCE = :pOpeningBalance, ' +
                 'CURRENT_BALANCE = :pCurrentBalance, DISABLED = :pDisabled, ' +
                 'UPDATE_DT = :pUpdateDT';

  // UAddDetail and UEditDetail
  SQL_20120001 = 'SELECT USER_ID, EXP_KEY1, EXP_KEY2, NAME2, ' +
                 'DISABLED2, ORDER_KEY2, ENTRY_DT, UPDATE_DT FROM EXP2 ' +
                 'WHERE USER_ID = :pUserID AND EXP_KEY1 = :pExpKey1 ORDER BY ' +
                 'ORDER_KEY2';
  SQL_20120002 = 'SELECT USER_ID, EXP_KEY1, EXP_KEY2, EXP_KEY3, ' +
                 'NAME3, DISABLED3, ORDER_KEY3, ENTRY_DT, UPDATE_DT FROM EXP3 ' +
                 'WHERE USER_ID = :pUserID AND EXP_KEY1 = :pExpKey1 AND ' +
                 'EXP_KEY2 = :pExpKey2 ORDER BY ORDER_KEY3';
  SQL_20120003 = 'SELECT COALESCE(MAX(DETAIL_ID), 0) + 1 AS NEXT_ID ' +
                 'FROM DETAILS WHERE USER_ID = :pUserID AND HEADER_ID = ' +
                 ':pHeaderID';
  SQL_20120004 = 'SELECT TT.USER_ID, TT.TAX_TYPE_ID, TT.TAX_RATE_ID, (SELECT ' +
                 'TR.TAX_RATE FROM TAX_RATE TR WHERE TR.USER_ID = TT.USER_ID ' +
                 'AND TR.TAX_RATE_ID = TT.TAX_RATE_ID) AS TAX_RATE, ' +
                 'CAST(TT.TAX_TYPE||''(''||(SELECT TR.TAX_RATE FROM ' +
                 'TAX_RATE TR WHERE TR.USER_ID = TT.USER_ID AND ' +
                 'TR.TAX_RATE_ID = TT.TAX_RATE_ID)||''%)'' AS VARCHAR) ' +
                 'AS TAX_TYPE, TT.ORDER_ID FROM TAX_TYPE TT WHERE TT.USER_ID ' +
                 '= :pUserID ORDER BY TT.TAX_TYPE_ID ASC';
  SQL_20120005 = 'SELECT * FROM DETAILS WHERE USER_ID = :pUserID AND ' +
                 'HEADER_ID = :pHeaderID';
  SQL_20120006 = 'SELECT * FROM DETAILS WHERE USER_ID = :pUserID AND ' +
                 'HEADER_ID = :pHeaderID AND DETAIL_ID = :pDetailID';
  SQL_20120007 = 'INSERT INTO DETAILS(USER_ID, HEADER_ID, DETAIL_ID, ' +
                 'EXP_KEY1, EXP_KEY2, EXP_KEY3, MAKER_ID, BRAND_NAME_ID, ' +
                 'QUANTITY, UNIT_ID, EXCLUDE_TAX, TAX_TYPE_ID, TAX_RATE_ID, ' +
                 'TAX, SUB_TOTAL, ENTRY_DT, UPDATE_DT) VALUES (:pUserID, ' +
                 ':pHeaderID, :pDetailID, :pExpKey1, :pExpKey2, :pExpKey3, ' +
                 ':pMakerID, :pBrandNameID, :pQuantity, :pUnitID, :pExcludeTax, ' +
                 ':pTaxTypeID, :pTaxRateID, :pTax, :pSubTotal, :pEntryDT, ' +
                 'NULL) ON CONFLICT (USER_ID, HEADER_ID, DETAIL_ID) ' +
                 'DO UPDATE SET EXP_KEY1 = :pExpKey1, EXP_KEY2 = :pExpKey2, ' +
                 'EXP_KEY3 = :pExpKey3, MAKER_ID = :pMakerID, BRAND_NAME_ID ' +
                 '= :pBrandNameID, QUANTITY = :pQuantity, UNIT_ID = ' +
                 ':pUnitID, EXCLUDE_TAX = :pExcludeTax, TAX_TYPE_ID = :pTaxTypeID, ' +
                 'TAX_RATE_ID = :pTaxRateID, TAX = :pTax, SUB_TOTAL = ' +
                 ':pSubTotal, UPDATE_DT = :pUpdateDT';

  // UEntryMaker and UAddDetail and UEditDetail and UEntryBrandName
  SQL_20130001 = 'SELECT * FROM MAKER WHERE USER_ID = :pUserID ORDER BY ' +
                 'MAKER_NAME';
  SQL_20130002 = 'SELECT * FROM MAKER WHERE USER_ID = :pUserID AND ' +
                 'DISABLED = False ORDER BY MAKER_NAME ASC';
  SQL_20130003 = 'SELECT COALESCE(MAX(MAKER_ID), 0) + 1 AS NEXT_ID ' +
                 'FROM MAKER WHERE USER_ID = :pUserID';
  SQL_20130004 = 'INSERT INTO MAKER(USER_ID, MAKER_ID, MAKER_NAME, ' +
                 'DISABLED, ENTRY_DT, UPDATE_DT) VALUES(:pUserID, ' +
                 ':pMakerID, :pMakerName, :pDisabled, :pEntryDT, ' +
                 'NULL) ON CONFLICT (USER_ID, MAKER_ID) ' +
                 'DO UPDATE SET MAKER_NAME = :pMakerName, DISABLED ' +
                 '= :pDisabled, UPDATE_DT = :pUpdateDT';

  // UEntryBrandName and UAddDetail and UEditDetail
  SQL_20140001 = 'SELECT USER_ID, MAKER_ID, BRAND_NAME_ID, BRAND_NAME, ' +
                 'END_OF_SALES, DISABLED, ENTRY_DT, UPDATE_DT FROM BRAND ' +
                 'WHERE USER_ID = :pUserID AND MAKER_ID = :pMakerID';
  SQL_20140002 = 'SELECT COALESCE(MAX(BRAND_NAME_ID), 0) + 1 AS ' +
                 'NEXT_ID FROM BRAND WHERE USER_ID = :pUserID ' +
                 'AND MAKER_ID = :pMakerID';
  SQL_20140003 = 'SELECT B.USER_ID, B.BRAND_NAME_ID, B.MAKER_ID, ' +
                 'M.MAKER_NAME, B.BRAND_NAME, B.END_OF_SALES, B.DISABLED, ' +
                 'B.ENTRY_DT, B.UPDATE_DT FROM BRAND B LEFT OUTER JOIN ' +
                 'MAKER M ON M.USER_ID = B.USER_ID AND M.MAKER_ID = ' +
                 'B.MAKER_ID AND B.USER_ID = :pUserID ORDER BY ' +
                 'M.MAKER_NAME ASC';
  SQL_20140004 = 'INSERT INTO BRAND(USER_ID, MAKER_ID, BRAND_NAME_ID, ' +
                 'BRAND_NAME, END_OF_SALES, DISABLED, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES(:pUserID, :pMakerID, :pBrandNameID, :pBrandName, ' +
                 ':pEndOfSales, :pDisabled, :pEntryDT, NULL) ON CONFLICT ' +
                 '(USER_ID, MAKER_ID, BRAND_NAME_ID) DO UPDATE SET ' +
                 'MAKER_ID = :pNewMakerID, BRAND_NAME_ID = ' +
                 ':pNewBrandNameID, BRAND_NAME = :pBrandName, END_OF_SALES ' +
                 '= :pEndOfSales, DISABLED = :pDisabled, UPDATE_DT = ' +
                 ':pUpdateDT';
  SQL_20140006 = 'UPDATE BRAND SET USER_ID = :pUserID, MAKER_ID = ' +
                 ':pMakerID, BRAND_NAME_ID = :pBrandNameID, BRAND_NAME = ' +
                 ':pBrandName, END_OF_SALES = :pEndOfSales, DISABLED = ' +
                 ':pDisabled, UPDATE_DT = :pUpdateDT WHERE USER_ID = ' +
                 ':pUserID AND MAKER_ID = :pCurrMakerID AND BRAND_NAME_ID ' +
                 '= :pCurrBrandNameID';

  // UEntryUnit and UAddDetail and UEditDetail
  SQL_20150001 = 'SELECT * FROM UNIT ORDER BY ORDER_ID ASC';
  SQL_20150002 = 'SELECT COALESCE(MAX(UNIT_ID), 0) + 1 AS NEXT_ID ' +
                 'FROM UNIT';
  SQL_20150003 = 'INSERT INTO UNIT(UNIT_ID, UNIT, ORDER_ID, DISABLED, ' +
                 'ENTRY_DT, UPDATE_DT) VALUES(:pUnitID, :pUnit, :pOrderID, ' +
                 ':pDisabled, :pEntryDT, NULL) ON CONFLICT (UNIT_ID) ' +
                 'DO UPDATE SET UNIT = :pUnit, DISABLED = :pDisabled, ' +
                 'UPDATE_DT = :pUpdateDT';


  //============================================================================
  // Default Datas
  //============================================================================
  //----------------------------------------------------------------------------
  SQL_90010001 = 'INSERT INTO TAX_RATE(USER_ID, TAX_RATE_ID, TAX_RATE, ' +
                 'DISABLED, ENTRY_DT, UPDATE_DT) VALUES (:pUserID, 1, 8, ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_90010002 = 'INSERT INTO TAX_RATE(USER_ID, TAX_RATE_ID, TAX_RATE, ' +
                 'DISABLED, ENTRY_DT, UPDATE_DT) VALUES (:pUserID, 2, 10, ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_90010003 = 'INSERT INTO TAX_RATE(USER_ID, TAX_RATE_ID, TAX_RATE, ' +
                 'DISABLED, ENTRY_DT, UPDATE_DT) VALUES (:pUserID, 3, 0, ' +
                 'FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_90020001 = 'INSERT INTO TAX_TYPE(USER_ID, TAX_TYPE_ID, TAX_RATE_ID, ' +
                 'TAX_TYPE, ORDER_ID, ENTRY_DT, UPDATE_DT) VALUES (:pUserID, ' +
                 '1, 1, ''外税'', 1, :pEntryDT, NULL)';
  SQL_90020002 = 'INSERT INTO TAX_TYPE(USER_ID, TAX_TYPE_ID, TAX_RATE_ID, ' +
                 'TAX_TYPE, ORDER_ID, ENTRY_DT, UPDATE_DT) VALUES (:pUserID, ' +
                 '2, 2, ''外税'', 2, :pEntryDT, NULL)';
  SQL_90020003 = 'INSERT INTO TAX_TYPE(USER_ID, TAX_TYPE_ID, TAX_RATE_ID, ' +
                 'TAX_TYPE, ORDER_ID, ENTRY_DT, UPDATE_DT) VALUES (:pUserID, ' +
                 '3, 1, ''内税'', 3, :pEntryDT, NULL)';
  SQL_90020004 = 'INSERT INTO TAX_TYPE(USER_ID, TAX_TYPE_ID, TAX_RATE_ID, ' +
                 'TAX_TYPE, ORDER_ID, ENTRY_DT, UPDATE_DT) VALUES (:pUserID, ' +
                 '4, 2, ''内税'', 4, :pEntryDT, NULL)';
  SQL_90020005 = 'INSERT INTO TAX_TYPE(USER_ID, TAX_TYPE_ID, TAX_RATE_ID, ' +
                 'TAX_TYPE, ORDER_ID, ENTRY_DT, UPDATE_DT) VALUES (:pUserID, ' +
                 '5, 3, ''非課税'', 5, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91000001 = 'INSERT INTO EXP1(USER_ID, EXP_KEY1, ORDER_KEY1, ' +
                 'NAME1, DISABLED1, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 1, ''支出'', FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_91010001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 1, 1, ''食費'', FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_91010002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 1, 1, 1, ''食料品'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91010003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 1, 2, 2, ''飲料'', FALSE, ' +
                 ':pEntryDT, NULL)';
  SQL_91010004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 1, 3, 3, ''朝食'', FALSE, ' +
                 ':pEntryDT, NULL)';
  SQL_91010005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 1, 4, 4, ''昼食'', FALSE, ' +
                 ':pEntryDT, NULL)';
  SQL_91010006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 1, 5, 5, ''夕食'', FALSE, ' +
                 ':pEntryDT, NULL)';
  SQL_91010007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 1, 6, 6, ''夜食'', FALSE, ' +
                 ':pEntryDT, NULL)';
  SQL_91010008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 1, 7, 7, ' +
                 '''中食(ブランチなど)'', FALSE, :pEntryDT, NULL)';
  SQL_91010009 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 1, 8, 8, ''外食'', FALSE, ' +
                 ':pEntryDT, NULL)';
  SQL_91010010 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 1, 9, 9, ''嗜好品'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91010011 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 1, 10, 10, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91020001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 2, 2, ''日用雑貨'', FALSE, :pEntryDT, ' +
                 'NULL)';
  //----------------------------------------------------------------------------
  SQL_91020002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 2, 1, 1, ''消耗品'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91020003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 2, 2, 2, ''子ども関連'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91020004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 2, 3, 3, ''タバコ'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91020005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 2, 4, 4, ''ペット関連'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91020006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 2, 5, 5, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91030001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 3, 3, ''交通費'', FALSE, :pEntryDT, ' +
                 'NULL)';
  //----------------------------------------------------------------------------
  SQL_91030002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 3, 1, 1, ''バス'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91030003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 3, 2, 2, ''電車'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91030004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 3, 3, 3, ''タクシー'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91030005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 3, 4, 4, ''飛行機'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91030006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 3, 5, 5, ''電子マネー'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91030007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 3, 6, 6, ' +
                 '''自動車(ガソリン代など)'', FALSE, :pEntryDT, NULL)';
  SQL_91030008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 3, 7, 7, ' +
                 '''バイク(ガソリン代など)'', FALSE, :pEntryDT, NULL)';
  SQL_91030009 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 3, 8, 8, ' +
                 '''自転車(駐輪代など)'', FALSE, :pEntryDT, NULL)';
  SQL_91030010 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 3, 9, 9, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91040001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 4, 4, ''通信'', FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_91040002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 4, 1, 1, ''携帯電話'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91040003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 4, 2, 2, ''固定回線'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91040004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 4, 3, 3, ' +
                 '''インターネット関連'', FALSE, :pEntryDT, NULL)';
  SQL_91040005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 4, 4, 4, ''放送サービス'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91040006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 4, 5, 5, ''郵便'', FALSE, ' +
                 ':pEntryDT, NULL)';
  SQL_91040007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 4, 6, 6, ''宅配便'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91040008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 4, 7, 7, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91050001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 5, 5, ''娯楽'', FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_91050002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 5, 1, 1, ''映画・動画'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91050003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 5, 2, 2, ''音楽'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91050004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 5, 3, 3, ''演劇'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91050005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 5, 4, 4, ''スポーツ'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91050006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 5, 5, 5, ''書籍'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91050007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 5, 6, 6, ''漫画'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91050008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 5, 7, 7, ''ゲーム'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91050009 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 5, 8, 8, ''イベント'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91050010 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 5, 9, 9, ''レジャー'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91050011 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 5, 10, 10, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91060001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 6, 6, ''教養'', FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_91060002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 6, 1, 1, ''書籍'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91060003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 6, 2, 2, ''塾'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91060004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 6, 3, 3, ''習い事'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91060005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 6, 4, 4, ''講習会'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91060006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 6, 5, 5, ''新聞'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91060007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 6, 6, 6, ''試験'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91060008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 6, 7, 7, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91070001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 7, 7, ''美容・健康'', FALSE, ' +
                 ':pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_91070002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 7, 1, 1, ''化粧品'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91070003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 7, 2, 2, ''衣類'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91070004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 7, 3, 3, ''小物'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91070005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 7, 4, 4, ' +
                 '''アクセサリー'', FALSE, :pEntryDT, NULL)';
  SQL_91070006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 7, 5, 5, ' +
                 '''食品・サプリメント'', FALSE, :pEntryDT, NULL)';
  SQL_91070007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 7, 6, 6, ' +
                 '''コインランドリー'', FALSE, :pEntryDT, NULL)';
  SQL_91070008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 7, 7, 7, ' +
                 '''美容院・理容院'', FALSE, :pEntryDT, NULL)';
  SQL_91070009 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 7, 8, 8, ''ジム'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91070010 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 7, 9, 9, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91080001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 8, 8, ''医療'', FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_91080002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 8, 1, 1, ''病院'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91080003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 8, 2, 2, ''薬'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91080004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 8, 3, 3, ''医療器具'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91080005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 8, 4, 4, ''食品'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91080006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 8, 5, 5, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91090001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 9, 9, ''保険・年金'', FALSE, ' +
                 ':pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_91090002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 9, 1, 1, ''健康保険'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91090003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 9, 2, 2, ''国民年金'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91090004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 9, 3, 3, ''共済保険'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91090005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 9, 4, 4, ''医療保険'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91090006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 9, 5, 5, ''終身保険'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91090007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 9, 6, 6, ' +
                 '''携帯保険(故障・紛失補償など)'', FALSE, :pEntryDT, NULL)';
  SQL_91090008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 9, 7, 7, ''車両保険'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91090009 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 9, 8, 8, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91100001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 10, 10, ''光熱費'', FALSE, :pEntryDT, ' +
                 'NULL)';
  //----------------------------------------------------------------------------
  SQL_91100002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 10, 1, 1, ''電気代'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91100003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 10, 2, 2, ''ガス代'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91100004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 10, 3, 3, ''水道代'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91100005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 10, 4, 4, ''薪代'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91100006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 10, 5, 5, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91110001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 11, 11, ''住居'', FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_91110002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 11, 1, 1, ''家賃'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91110003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 11, 2, 2, ' +
                 '''管理・共益費'', FALSE, :pEntryDT, NULL)';
  SQL_91110004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 11, 3, 3, ''修繕費'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91110005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 11, 4, 4, ' +
                 '''リフォーム代'', FALSE, :pEntryDT, NULL)';
  SQL_91110006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 11, 5, 5, ' +
                 '''引越代'', FALSE, :pEntryDT, NULL)';
  SQL_91110007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 11, 6, 6, ''敷金'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91110008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 11, 7, 7, ''礼金'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91110009 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 11, 8, 8, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91120001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 12, 12, ''税金'', FALSE, :pEntryDT, ' +
                 'NULL)';
  //----------------------------------------------------------------------------
  SQL_91120002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 12, 1, 1, ''消費税'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91120003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 12, 2, 2, ''住民税'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91120004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 12, 3, 3, ''固定資産税'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91120005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 12, 4, 4, ''自動車税'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91120006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 12, 5, 5, ''法人税'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91120007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 12, 6, 6, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91130001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 13, 13, ''大型出費'', FALSE, ' +
                 ':pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_91130002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 13, 1, 1, ' +
                 '''IT家電(PC・ガジェットなど)'', FALSE, :pEntryDT, NULL)';
  SQL_91130003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 13, 2, 2, ''その他家電'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91130004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 13, 3, 3, ''家具'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91130005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 13, 4, 4, ''什器'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91130006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 13, 5, 5, ''冠婚葬祭'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91130007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 13, 6, 6, ''出産'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91130008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 13, 7, 7, ''介護'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91130009 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 13, 8, 8, ''旅行'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91130010 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 13, 9, 9, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_91140001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 1, 14, 14, ''その他'', FALSE, :pEntryDT, ' +
                 'NULL)';
  //----------------------------------------------------------------------------
  SQL_91140002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 14, 1, 1, ' +
                 '''電子マネーを使用'', FALSE, :pEntryDT, NULL)';
  SQL_91140003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 14, 2, 2, ''仕送り'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91140004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 14, 3, 3, ''お小遣い'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91140005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 14, 4, 4, ''お年玉'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91140006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 14, 5, 5, ''立替金'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91140007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 14, 6, 6, ''使途不明金'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_91140008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 1, 14, 7, 7, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //============================================================================
  SQL_92000001 = 'INSERT INTO EXP1(USER_ID, EXP_KEY1, ORDER_KEY1, ' +
                 'NAME1, DISABLED1, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 2, 2, ''収入'', FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_92010001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 2, 1, 1, ''給与'', FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_92010002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 1, 1, 1, ''報酬'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92010003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 1, 2, 2, ' +
                 '''アルバイト・パート代'', FALSE, :pEntryDT, NULL)';
  SQL_92010004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 1, 3, 3, ''講師代'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92010005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 1, 4, 4, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_92020001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 2, 2, 2, ''賞与'', FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_92020002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 2, 1, 1, ''夏季賞与'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92020003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 2, 2, 2, ''冬季賞与'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92020004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 2, 3, 3, ''期末賞与'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92020005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 2, 4, 4, ''臨時賞与'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92020006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 2, 5, 5, ''寸志'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92020007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 2, 6, 6, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_92030001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 2, 3, 3, ''年金'', FALSE, :pEntryDT, NULL)';
  //----------------------------------------------------------------------------
  SQL_92030002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 3, 1, 1, ''基礎年金'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92030003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 3, 2, 2, ''厚生年金'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92030004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 3, 3, 3, ''老齢年金'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92030005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 3, 4, 4, ''遺族年金'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92030006 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 3, 5, 5, ' +
                 '''障害基礎年金'', FALSE, :pEntryDT, NULL)';
  SQL_92030007 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 3, 6, 6, ' +
                 '''障害厚生年金'', FALSE, :pEntryDT, NULL)';
  SQL_92030008 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 3, 7, 7, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_92040001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 2, 4, 4, ''支給金'', FALSE, :pEntryDT, ' +
                 'NULL)';

  //----------------------------------------------------------------------------
  SQL_92050001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 2, 5, 5, ''保険金'', FALSE, :pEntryDT, ' +
                 'NULL)';
  //----------------------------------------------------------------------------
  SQL_92050002 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 5, 1, 1, ''医療保険'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92050003 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 5, 2, 2, ''終身保険'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92050004 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 5, 3, 3, ''車両保険'', ' +
                 'FALSE, :pEntryDT, NULL)';
  SQL_92050005 = 'INSERT INTO EXP3(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'EXP_KEY3, ORDER_KEY3, NAME3, DISABLED3, ENTRY_DT, ' +
                 'UPDATE_DT) VALUES (:pUserID, 2, 5, 4, 4, ''その他'', ' +
                 'FALSE, :pEntryDT, NULL)';

  //----------------------------------------------------------------------------
  SQL_92060001 = 'INSERT INTO EXP2(USER_ID, EXP_KEY1, EXP_KEY2, ' +
                 'ORDER_KEY2, NAME2, DISABLED2, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 2, 6, 6, ''臨時収入'', FALSE, :pEntryDT, ' +
                 'NULL)';

  //============================================================================
  SQL_93000001 = 'INSERT INTO EXP1(USER_ID, EXP_KEY1, ORDER_KEY1, ' +
                 'NAME1, DISABLED1, ENTRY_DT, UPDATE_DT) ' +
                 'VALUES (:pUserID, 3, 3, ''振替'', FALSE, :pEntryDT, NULL)';

type

  { TDBAccess }

  TDBAccess = class(TObject)
  private
  protected
  published
  public

  end;

implementation

end.


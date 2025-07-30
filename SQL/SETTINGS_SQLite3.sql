.headers on
.mode column
.separator "|"
PRAGMA foreign_keys = ON;
--PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA cache_size = 10000;
PRAGMA temp_store = MEMORY;
PRAGMA auto_vacuum = FULL;
PRAGMA busy_timeout = 5000;
PRAGMA locking_mode = NORMAL;
PRAGMA page_size = 4096;
PRAGMA temp_store_directory = 'D:\tmp';
PRAGMA secure_delete = ON;
--PRAGMA foreign_key_check = ON;


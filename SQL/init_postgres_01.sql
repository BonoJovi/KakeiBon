CREATE DATABASE kakeibon;
CREATE ROLE kakeibon WITH LOGIN;
CREATE SCHEMA kakeibon AUTHORIZATION kakeibon;
ALTER ROLE kakeibon SET search_path TO kakeibon,"$user",public;

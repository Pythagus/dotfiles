-- This script is executed to configure
-- the MySQL database at the MySQL installation.

-- Update the root's password.
-- It's a local database, don't need a super-protected password.
 ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'bdd';

-- Make the changes working.
FLUSH PRIVILEGES ;

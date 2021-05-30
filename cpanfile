requires "Mojolicious";
requires "YAML";
requires "Data::UUID";
requires "DBI";
requires "DBD::SQLite";

on "test" => sub {
    requires "Test::MockModule";
};

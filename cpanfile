requires "Mojolicious";
requires "YAML";
requires "Data::UUID";

on "test" => sub {
    requires "Test::MockModule";
};

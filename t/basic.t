use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Course::Management');
$t->get_ok('/')->status_is(200)->content_like(qr/Welcome to the Course Management App/i);
ok 1;

done_testing();

use experimental 'signatures';
use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

no warnings 'experimental';

subtest main => sub {
    my $t = Test::Mojo->new('Course::Management');
    $t->get_ok('/');

    $t->status_is(200);
    $t->content_like(qr/Welcome to the Course Management App/i);
    # Test there is a form to login
};

done_testing();


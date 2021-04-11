use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use YAML qw(LoadFile);

my $t = Test::Mojo->new('Course::Management');
my $course_config = LoadFile($t->app->home->child($t->app->config->{course_config}));

subtest main => sub {
    $t->get_ok('/');

    $t->status_is(200);
    $t->content_like(qr/Welcome to the Course Management App/i);

    $t->content_like(qr{$course_config->[0]{name}});
    $t->text_is("#$course_config->[0]{id} a", $course_config->[0]{name});
};

subtest course => sub {
    $t->get_ok("/course/$course_config->[0]{id}");

    $t->status_is(200);
    $t->text_is('#exercises :first-child a', $course_config->[0]{exercises}[0]{title});
    $t->text_is(qq{a[href="$course_config->[0]{exercises}[1]{url}"]}, $course_config->[0]{exercises}[1]{title});
};

subtest login_failed => sub {
    $t->post_ok('/login' => form => {email => 'foo@bar.com'});
    $t->status_is(200);
    $t->content_like(qr{Invalid email});
};

subtest login => sub {
    $t->post_ok('/login' => form => { email => $course_config->[0]{students}[0]{email} });
    $t->status_is(200);
    $t->content_like(qr{We have sent an email to});
};


done_testing();

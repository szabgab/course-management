use experimental 'signatures';
use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Test::MockModule;
use YAML qw(LoadFile);

no warnings 'experimental';

my $course_config = get_course_config();

sub get_course_config {
    my $t = Test::Mojo->new('Course::Management');
    LoadFile($t->app->home->child($t->app->config->{course_config}));
}

subtest main => sub {
    my $t = Test::Mojo->new('Course::Management');
    $t->get_ok('/');

    $t->status_is(200);
    $t->content_like(qr/Welcome to the Course Management App/i);
    # Test there is a form to login
};

subtest course => sub {
    my $t = Test::Mojo->new('Course::Management');
    login($t);
    $t->get_ok("/course/$course_config->[0]{id}");

    $t->status_is(200);
    $t->text_is('#exercises :first-child a', $course_config->[0]{exercises}[0]{title});
    $t->text_is(qq{a[href="$course_config->[0]{exercises}[1]{url}"]}, $course_config->[0]{exercises}[1]{title});

    $t->get_ok("/course/$course_config->[2]{id}");
    $t->status_is(401);
    $t->content_is('You are not in this course');
};

subtest login_failed => sub {
    my $t = Test::Mojo->new('Course::Management');
    my $called_sendmail;
    my $module = Test::MockModule->new( 'Course::Management::Controller::Main');
    $module->mock('sendmail', sub {
        note 'mocking sendmail';
        $called_sendmail = 1;
    });

    $t->post_ok('/login' => form => {email => 'foo@bar.com'});
    $t->status_is(200);
    $t->content_like(qr{Invalid email});
    ok !$called_sendmail, 'no sendmail';

    $t->get_ok('/course/');
    $t->status_is(401);
    $t->content_is('Not logged in');
};

subtest not_accessible_without_login => sub {
    my $t = Test::Mojo->new('Course::Management');
    $t->get_ok('/course/');
    $t->status_is(401);
    $t->content_is('Not logged in');

    $t->get_ok("/course/$course_config->[0]{id}");
    $t->status_is(401);
    $t->content_is('Not logged in');
};

subtest login_verification_fail => sub {
    my $t = Test::Mojo->new('Course::Management');
    $t->get_ok("/login/some-invalid-code");
    $t->status_is(200);
    #diag $t->tx->res->body;
    $t->content_like(qr{<h2>Failed Login</h2>});
    $t->content_like(qr{Invalid code});

    $t->get_ok('/course/');
    $t->status_is(401);
    $t->content_is('Not logged in');
};

subtest login => sub {
    my $t = Test::Mojo->new('Course::Management');
    login($t);

    $t->get_ok('/course/');
    $t->status_is(200);
    $t->content_like(qr{<title>Courses</title>});
    $t->content_like(qr{$course_config->[0]{name}});
    $t->text_is("#$course_config->[0]{id} a", $course_config->[0]{name});
    $t->content_like(qr{$course_config->[1]{name}});
    $t->text_is("#$course_config->[1]{id} a", $course_config->[1]{name});
    $t->content_unlike(qr{$course_config->[2]{name}});

    $t->ua->max_redirects(1);
    $t->get_ok('/');
    $t->ua->max_redirects(0);
    $t->status_is(200);
    $t->content_like(qr{<title>Courses</title>});

    $t->get_ok('/logout')
      ->status_is(200)
      ->content_like(qr{<h2>Bye</h2>});
    #diag $t->tx->res->body;

    $t->get_ok('/course/');
    $t->status_is(401);
    $t->content_is('Not logged in');
};


done_testing();

sub login($t) {
    my $called_sendmail;
    my $sent_email;
    my $sent_code;
    my $module = Test::MockModule->new( 'Course::Management::Controller::Main');
    no warnings 'experimental';
    $module->mock('sendmail', sub ($email, $code) {
        note 'mocking sendmail';
        $called_sendmail = 1;
        $sent_email  = $email;
        $sent_code   = $code;
    });

    $t->post_ok('/login' => form => { email => $course_config->[0]{students}[0]{email} });
    $t->status_is(200);
    $t->content_like(qr{We have sent an email to});
    ok $called_sendmail, 'sendmail';
    is $sent_email, $course_config->[0]{students}[0]{email};
    note "code: $sent_code";

    $t->ua->max_redirects(1);
    $t->get_ok("/login/$sent_code");
    $t->ua->max_redirects(0);
    $t->status_is(200);
    #diag $t->tx->res->body;
    $t->content_like(qr{<title>Courses</title>});
}



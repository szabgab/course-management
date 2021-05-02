package t::lib::TestHelper;
use strict;
use warnings;
no warnings 'experimental';
use experimental 'signatures';
use Test::MockModule;
use Exporter qw(import);
use Test::More;
use Test::Mojo;
use YAML qw(LoadFile);

our @EXPORT_OK = qw(login get_course_config);

my $course_config = get_course_config();

sub get_course_config {
    my $t = Test::Mojo->new('Course::Management');
    LoadFile($t->app->home->child($t->app->config->{course_config}));
}


sub login($t) {
    my $called_sendmail;
    my $sent_email;
    my $sent_code;
    my $module = Test::MockModule->new( 'Course::Management::Controller::Main');
    $module->mock('sendmail', sub ($email, $code) {
        note('mocking sendmail');
        $called_sendmail = 1;
        $sent_email  = $email;
        $sent_code   = $code;
    });

    $t->post_ok('/login' => form => { email => $course_config->[0]{students}[0]{email} });
    $t->status_is(200);
    $t->content_like(qr{We have sent an email to});
    ok( $called_sendmail, 'sendmail');
    is($sent_email, $course_config->[0]{students}[0]{email});
    note("code: $sent_code");

    $t->ua->max_redirects(1);
    $t->get_ok("/login/$sent_code");
    $t->ua->max_redirects(0);
    $t->status_is(200);
    #diag $t->tx->res->body;
    $t->content_like(qr{<title>Courses</title>});
}


1;


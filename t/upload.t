use experimental 'signatures';
use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Test::MockModule;
use Mojo::File qw(path tempdir);

use lib '.';
use t::lib::TestHelper qw(login get_course_config);

no warnings 'experimental';

my $course_config = get_course_config();

subtest upload_no_upload_dir => sub {
    my $tempdir = tempdir(CLEANUP => 1);
    my $t = Test::Mojo->new('Course::Management', {
        secrets => ['1220edf81263ffb1a06f92304eafa2ce51cf7c69'],
        course_config => 'courses/config.yml',
        login_db => 'courses/login.yml',
        admin_email =>  'fake@code-maven.com',
        #upload_dir no upload dir in this test case!
    });
    login($t);
    my $content = 'bar';
    my $upload = {
        $course_config->[0]{exercises}[0]{files}[0] => {content => $content, filename => 'baz.txt'},
    };
    $t->post_ok("/course/$course_config->[0]{id}/upload" => form => $upload)->status_is(500);
    #diag $t->tx->res->body;
    $t->content_like(qr{Upload directory not configured});
};


subtest upload => sub {
    my $tempdir = tempdir(CLEANUP => 1);
    my $t = Test::Mojo->new('Course::Management', {
        upload_dir => $tempdir,
        secrets => ['1220edf81263ffb1a06f92304eafa2ce51cf7c69'],
        course_config => 'courses/config.yml',
        login_db => 'courses/login.yml',
        admin_email =>  'fake@code-maven.com',
    });
    login($t);

    # TODO test without id
    # TODO test large file
    my $content = 'bar';
    my $upload = {
        $course_config->[0]{exercises}[0]{files}[0] => {content => $content, filename => 'baz.txt'},
    };
    $t->post_ok("/course/$course_config->[0]{id}/upload" => form => $upload)->status_is(200);
    #diag $t->tx->res->body;
    $t->content_like(qr{Uploaded});
    (my $exercise_name = $course_config->[0]{exercises}[0]{url}) =~ s{[:/]+}{_}g;
    my $actual_content = path("$tempdir/$exercise_name/$course_config->[0]{exercises}[0]{files}[0]")->slurp;
    is $actual_content, $content;
};


done_testing();

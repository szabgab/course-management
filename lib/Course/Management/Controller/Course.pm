package Course::Management::Controller::Course;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::File qw(path);

sub list_courses ($self) {
    my $email = $self->session('email');
    $self->render(email => $email);
}

sub list_exercises ($self) {
    my $email = $self->session('email');

    my $course_id = $self->param('id');
    my %courses = $self->courses($email);
    return $self->render(text => 'You are not in this course', status => 401) if not exists $courses{$course_id};

    my $cc = $self->course_config;
    my ($course) = grep {$_->{id} eq $course_id} @$cc;

    $self->render(course => $course);
}


sub upload ($self) {
    my $id = $self->param('id');

    # Verify that the ID was indeed one of the IDs we have.
    my $cc = $self->course_config;
    my ($course) = grep {$_->{id} eq $id} @$cc;
    die "'$id'" if not $course;

    my $home = $self->app->home;
    $home->detect;
    my $upload_dir = $self->app->config->{'upload_dir'} // 'data';
    # TODO stop defaulting to a relative directory called 'data' it won't work now.

    my $upload = $self->req->upload('upload');
    my $dir = path($upload_dir)->child('hello');
    $dir->make_path;
    my $filename = $dir->child('a.txt');
    $upload->move_to($filename);

    $self->render(course => $course, cc => $cc);
}

1;

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

    # Verify that the ID was indeed one of the course IDs we have.
    my $cc = $self->course_config;
    my ($course) = grep {$_->{id} eq $id} @$cc;
    die "'$id'" if not $course;

    my $upload_dir = $self->app->config->{'upload_dir'};
    return $self->reply->exception('Upload directory not configured')->rendered(500)
        if not defined $upload_dir;
    return $self->reply->exception('Upload directory does not exist')->rendered(500)
        if not -d $upload_dir;

    for my $exercise (@{ $course->{exercises} }) {
        for my $file (@{ $exercise->{files} }) {
            my $upload = $self->req->upload($file);
            next unless defined $upload;
            $self->app->log->info($upload->name);
            $self->app->log->info($upload->size);
            next unless $upload->size;

            (my $exercise_name = $exercise->{url}) =~ s{[:/]+}{_}g;
            my $dir = path($upload_dir)->child($exercise_name);
            $dir->make_path;
            my $filename = $dir->child($file);
            $upload->move_to($filename);
        }
    }

    $self->render(course => $course, cc => $cc);
}

1;

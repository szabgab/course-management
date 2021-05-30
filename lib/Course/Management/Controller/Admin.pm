package Course::Management::Controller::Admin;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub list_courses ($self) {
    $self->render();
}

sub list_solutions ($self) {
    my $course_id = $self->param('id');
    my %courses = $self->courses();

    my $cc = $self->course_config;
    my ($course) = grep {$_->{id} eq $course_id} @$cc;

    $self->render(course => $course);
}


1;

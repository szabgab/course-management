package Course::Management::Controller::Course;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub list_exercises ($self) {
  my $id = $self->param('id');
  my $cc = $self->stash('cc');
  my ($course) = grep {$_->{id} eq $id} @$cc;

  $self->render(course => $course);
}

1;

package Course::Management::Controller::Main;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub welcome ($self) {

  my $cc = $self->course_config;
  $self->render(cc => $cc);
}

1;

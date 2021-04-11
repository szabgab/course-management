package Course::Management::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub welcome ($self) {

  # Render template "example/welcome.html.ep" with message
  my $cc = $self->course_config;
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!', cc => $cc);
}

1;

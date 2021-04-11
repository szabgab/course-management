package Course::Management::Controller::Main;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub welcome ($self) {

  my $cc = $self->course_config;
  $self->render(cc => $cc);
}

sub login ($self) {
  my $cc = $self->course_config;
  my $email = $self->param('email');
  my $success = 0;
  for my $course (@$cc) {
    for my $student (@{ $course->{students} }) {
       if ($email eq $student->{email}) {
         $success = 1;
         last;
       }
    }
  }
  $self->app->log->info($email);
  # TODO check email, generate code, save code to db, send email
  $self->render(email => $email, success => $success);
}

1;

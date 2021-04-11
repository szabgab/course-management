package Course::Management::Controller::Main;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use List::Util qw(uniq any);

sub welcome ($self) {

  my $cc = $self->course_config;
  $self->render(cc => $cc);
}

sub login ($self) {
  my $cc = $self->course_config;
  my $email = lc $self->param('email');
  $email =~ s/^\s+//;
  $email =~ s/\s+$//;
  my @emails = uniq map {$_->{email}} map {@{ $_->{students} }} @$cc;
  my $success = any { $_ eq $email } @emails;
  $self->app->log->info($email);
  # TODO check email, generate code, save code to db, send email
  $self->render(email => $email, success => $success);
}

1;

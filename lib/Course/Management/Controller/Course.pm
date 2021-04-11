package Course::Management::Controller::Course;
use Mojo::Base 'Mojolicious::Controller', -signatures;
#use Mojo::Upload;

sub list_exercises ($self) {
  my $id = $self->param('id');
  my $cc = $self->stash('cc');
  my ($course) = grep {$_->{id} eq $id} @$cc;

  $self->render(course => $course);
}

sub upload ($self) {
  my $id = $self->param('id');

  # Verify that the ID was indeed one of the IDs we have.
  my $cc = $self->stash('cc');
  my ($course) = grep {$_->{id} eq $id} @$cc;
  die "'$id'" if not $course;

  my $home = $self->app->home;
  $home->detect;

  my $upload = $self->req->upload('upload');
  #my $upload = Mojo::Upload->new;
  #say $upload->filename;
  #my $dir = $home->child('data', $course->{id});
  my $dir = $home->child('data', 'hello');
  $dir->make_path;
  my $filename = $dir->child('a.txt');
  $upload->move_to($filename);

  $self->render(course => $course);
}

1;

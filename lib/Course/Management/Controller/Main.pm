package Course::Management::Controller::Main;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use List::Util qw(uniq any);
use Data::UUID;
use YAML qw(DumpFile LoadFile);

sub welcome ($self) {
    $self->render();
}

sub login ($self) {
    my $cc = $self->course_config;
    my $email = lc $self->param('email');
    $email =~ s/^\s+//;
    $email =~ s/\s+$//;
    my @emails = uniq map {$_->{email}} map {@{ $_->{students} }} @$cc;
    my $success = any { $_ eq $email } @emails;
    $self->app->log->info($email);
    if (not $success) {
        return $self->render(email => $email, success => $success);
    }

    # TODO check email, generate code, save code to db, send email

    my $code = _get_code();
    $self->app->log->info($code);

    my ($filename, $logins) = $self->_login_db();

    $logins->{$code} = {
        email => $email,
        timestamp => time,
    };
    DumpFile($filename, $logins);

    sendmail($email, $code);

    $self->render(email => $email, success => $success);
}

sub _login_db($self) {
    my $home = $self->app->home;
    $home->detect;
    my $filename = $home->child($self->app->config('login_db'));
    my $logins = {};
    if (-e $filename) {
        $logins = LoadFile($filename);
    }
    return ($filename, $logins);
}


sub logout ($self) {
    $self->session(expires => 1);
    $self->render();
}


sub login_get ($self) {
    my $code = $self->param('code');
    my ($filename, $logins) = $self->_login_db();
    my $TIMEOUT = 60*60;
    # check code in database, setup session
    if (not $logins->{$code}) {
        return $self->render(message => 'Invalid code');
    }
    if ($logins->{$code}{timestamp} + $TIMEOUT < time) {
        return $self->render(message => 'Code timed out.');
    }

    $self->session(expiration => 60*60*24*100);
    $self->session(email => $logins->{$code}{email});

    delete $logins->{$code};
    DumpFile($filename, $logins);

    $self->render(message => '');
}

sub sendmail($email, $code) {
    return;
}

sub _get_code {
    my $ug = Data::UUID->new;
    my $uuid = $ug->create;
    my $code = $ug->to_string($uuid);
    return $code;
}


1;

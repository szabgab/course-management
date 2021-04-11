#!perl

use strict;
use warnings;

use Test::More;
use Test::BDD::Cucumber::StepFile;

Given qr{a running application}, sub {
    #C - step Context
    #S - reference to a Stash
    # start the web application
    my $app = undef;
    S->{app} = $app;
    ok 1;
};

When qr{we navigate to the student login page}, sub {
    # my $response = S->{app}->get('/login');
    # S->{response} = $response;
    ok 1;
};

# see an empty text box labeled "email"
# see a button labeled "login"
Then qr{see an? (empty text box|button) labeled "([^"]+)"}, sub {
    my ($element, $label) = ($1, $2);
    diag $element;
    # is S->{response}->status, 200;
    # ok S->{response}->content->CSS_selector($element, $label);
    ok 1;
};


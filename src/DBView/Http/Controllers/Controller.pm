package DBView::Http::Controllers::Controller;

use strict;
use warnings;

use Foundation::Appify;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub welcome {
    my $self = shift;
    my $request = shift;

    app()->pushToStack('scripts', servicePath('dbview') . '/script.js');

    my $template = &_::template('dbview::welcome', {
        email => user()->get('email'),
    });

    return $template->output();
}

sub dashboard {
    my $self = shift;
    my $request = shift;

    # TODO: Do something useful.

    app()->pushToStack('scripts', servicePath('dbview') . '/script.js');

    my $template = &_::template('dbview::dashboard', {
        #
    });

    return $template->output();
}

sub showMessage {
    my $self = shift;
    my $request = shift;

    # TODO: Do something useful.

    return $self->welcome($request);
}

1;

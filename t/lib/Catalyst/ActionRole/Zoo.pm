package Catalyst::ActionRole::Zoo;

use Moose::Role;

use namespace::autoclean;

after execute => sub {
    my ($self, $controller, $c) = @_;
    $c->response->body(__PACKAGE__);
};

1;

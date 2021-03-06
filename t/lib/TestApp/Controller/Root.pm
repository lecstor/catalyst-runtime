package TestApp::Controller::Root;
use strict;
use warnings;
use base 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

sub chain_root_index : Chained('/') PathPart('') Args(0) { }

sub zero : Path('0') {
    my ( $self, $c ) = @_;
    $c->res->header( 'X-Test-Class' => ref($self) );
    $c->response->content_type('text/plain; charset=utf-8');
    $c->forward('TestApp::View::Dump::Request');
}

sub zerobody : Local {
    my ($self, $c) = @_;
    $c->res->body('0');
}

sub emptybody : Local {
    my ($self, $c) = @_;
    $c->res->body('');
}

sub localregex : LocalRegex('^localregex$') {
    my ( $self, $c ) = @_;
    $c->res->header( 'X-Test-Class' => ref($self) );
    $c->response->content_type('text/plain; charset=utf-8');
    $c->forward('TestApp::View::Dump::Request');
}

sub index : Private {
    my ( $self, $c ) = @_;
    $c->res->body('root index');
}

sub global_action : Private {
    my ( $self, $c ) = @_;
    $c->forward('TestApp::View::Dump::Request');
}

sub class_forward_test_method :Private {
    my ( $self, $c ) = @_;
    $c->response->headers->header( 'X-Class-Forward-Test-Method' => 1 );
}

sub loop_test : Local {
    my ( $self, $c ) = @_;

    for( 1..1001 ) {
        $c->forward( 'class_forward_test_method' );
    }
}

sub recursion_test : Local {
    my ( $self, $c ) = @_;
    $c->forward( 'recursion_test' );
}

sub base_href_test : Local {
    my ( $self, $c ) = @_;

    my $body = <<"EndOfBody";
<html>
  <head>
    <base href="http://www.example.com/">
  </head>
  <body>
  </body>
</html>
EndOfBody

    $c->response->body($body);
}

sub body_semipredicate : Local {
    my ($self, $c) = @_;
    $c->res->body; # Old code tests length($c->res->body), which causes the value to be built (undef), which causes the predicate
    $c->res->status( $c->res->has_body ? 500 : 200 ); # to return the wrong thing, resulting in a 500.
    $c->res->body('Body');
}


sub test_redirect :Global {
    my ($self, $c) = @_;
    # Don't set content_type
    # Don't set body
    $c->res->redirect('/go_here');
}

sub test_redirect_with_contenttype :Global {
    my ($self, $c) = @_;
    # set content_type but don't set body
    $c->res->content_type('image/jpeg');
    $c->res->redirect('/go_here');
}

sub test_redirect_with_content :Global {
    my ($self, $c) = @_;
    $c->res->content_type('text/plain');
    $c->res->body('Please kind sir, I beg you to go to /go_here.');
    $c->res->redirect('/go_here');
}

sub end : Private {
    my ($self,$c) = @_;
}

1;

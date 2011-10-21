use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Catalyst::Test 'TestApp';

my %roles = (
    foo  => 'TestApp::ActionRole::Moo',
    bar  => 'TestApp::ActionRole::Moo',
    baz  => 'Moo',
    quux => 'Catalyst::ActionRole::Zoo',
);

while (my ($path, $role) = each %roles) {
    my $resp = request("/actionroles/${path}");
    ok($resp->is_success);
    is($resp->content, $role);
    is($resp->header('X-Affe'), 'Tiger');
}

{
    my $resp = request("/actionroles/corge");
    ok($resp->is_success);
    is($resp->content, 'TestApp::ActionRole::Moo');
    is($resp->header('X-Affe'), 'Tiger');
	is($resp->header('X-Action-After'), 'moo');
}

done_testing;

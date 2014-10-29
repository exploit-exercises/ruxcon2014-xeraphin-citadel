#!/usr/bin/env perl
use Mojolicious::Lite;

get '/' => sub {
  my $self = shift;
  $self->render('index');
};

sub citadel_login {
	my ($user, $pass) = @_;
	$user = uc($user);
	$user =~ s/\s+//g;
	$pass = uc($pass);

	#print "\$user is $user and \$pass is $pass\n";

	if($user eq "" or $pass eq "") {
		return "empty username or password supplied, invalid sorry";
	}

	#print "my user is now '$user'\n";

	my $entries = `grep "$user" accounts.tsv`;

	#print "my \$entries are now $entries\n";

	my @lines = split("\n", $entries);

	#print "my \@lines are now @lines\n";

	foreach my $line (@lines) {
		#print "my line is '$line'\n";
		my ($u, $p, $t) = split("\t", $line);
		if($u =~ $user and $p =~ $pass) {
			return "Your message is '$t'";
		}
	}	
	return "Failed to log in!";
}

post '/login' => sub {
  my $self = shift;
  my $username = $self->param('username');
  my $password = $self->param('password');

  my $result = citadel_login($username, $password);

  $self->render(text => $result);
};

app->secrets(['bf318a3b-0e19-4973-a242-a9f84c9257e7']);
app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Citadel';
<form method="POST" action="/login">
  <input type="text" name="username" value="GUEST" />
  <br/>
  <input type="text" name="password" value="GUEST" />
  <br/>
  <input type="submit" name="submit" value="submit" />
</form>

@@ response.html.ep
% layout 'default';
% title 'Your results';

<%= results =>
  
@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>



package POE::Filter::Bzip2;

use Carp;
use Compress::Bzip2 qw(compress decompress);
use vars qw($VERSION);

$VERSION = '1.0';

sub PUT_LITERAL () { 1 }

sub new {
  my $type = shift;
  croak "$type requires an even number of parameters" if @_ % 2;
  my $buffer = { @_ };
  foreach my $option ( keys %{ $buffer } ) {
	$buffer->{ lc( $option) } = delete( $buffer->{ $option } );
  }
  $buffer->{level} = 1 unless ( $buffer->{level} );
  $buffer->{BUFFER} = [];
  return bless($buffer, $type);
}

sub level {
  my ($self) = shift;
  my ($level) = shift;

  if ( defined ( $level ) ) {
	$self->{level} = $level;
  }
  return $self->{level};
}

sub get {
  my ($self, $raw_lines) = @_;
  my $events = [];

  foreach my $raw_line (@$raw_lines) {
	if ( my $line = decompress( $raw_line ) ) {
		push( @$events, $line );
	} else {
		warn "Couldn\'t decompress input\n";
	}
  }
  return $events;
}

sub get_one_start {
  my ($self, $raw_lines) = @_;

  foreach my $raw_line (@$raw_lines) {
	if ( my $line = decompress( $raw_line ) ) {
		push( @$events, $line );
	} else {
		warn "Couldn\'t decompress input\n";
	}
  }
}

sub get_one {
  my ($self) = shift;
  my $events = [];

  if ( my $raw_line = shift ( @{ $self->{BUFFER} } ) ) {
	if ( my $line = decompress( $raw_line ) ) {
		push( @$events, $line );
	} else {
		warn "Couldn\'t decompress input\n";
	}
  }
  return $events;
}

sub put {
  my ($self, $events) = @_;
  my $raw_lines = [];

  foreach my $event (@$events) {
	if ( my $line = compress( $event, $self->{level} ) ) {
		push( @$raw_lines, $line );
	} else {
		warn "Couldn\'t compress output\n";
	}
  }
  return $raw_lines;
}

1;

__END__

=head1 NAME

POE::Filter::Bzip2 -- A POE filter wrapped around Compress::Bzip2

=head1 SYNOPSIS

    use POE::Filter::Bzip2;

    my $filter = POE::Filter::Bzip2->new();
    my $scalar = 'Blah Blah Blah';
    my $compressed_array   = $filter->put( [ $scalar ] );
    my $uncompressed_array = $filter->get( $compressed_array );

    use POE qw(Filter::Stackable Filter::Line Filter::Bzip2);

    my ($filter) = POE::Filter::Stackable->new();
    $filter->push( POE::Filter::Bzip2->new(),
		   POE::Filter::Line->new( InputRegexp => '\015?\012', OutputLiteral => "\015\012" ),

=head1 DESCRIPTION

POE::Filter::Bzip2 provides a POE filter for performing compression/decompression using L<Compress::Bzip2|Compress::Bzip2>. It is
suitable for use with L<POE::Filter::Stackable|POE::Filter::Stackable>.

=head1 METHODS

=over

=item *

new

Creates a new POE::Filter::Bzip2 object. Takes one optional argument, 'level': the level of compression to employ.
Consult L<Compress::Bzip2|Compress::Bzip2> for details.

=item *

get

Takes an arrayref which is contains lines of compressed input. Returns an arrayref of decompressed lines.

=item *

put

Takes an arrayref containing lines of uncompressed output, returns an arrayref of compressed lines.

=item *

level

Sets the level of compression employed to the given value. If no value is supplied, returns the current level setting.

=back

=head1 AUTHOR

Chris Williams <chris@bingosnet.co.uk>

=head1 SEE ALSO

L<POE|POE>
L<Compress::Bzip2|Compress::Bzip2>
L<POE::Filter::Stackable|POE::Filter::Stackable>

=cut


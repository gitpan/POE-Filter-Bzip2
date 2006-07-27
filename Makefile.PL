use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
# Blah!

WriteMakefile(
			  'NAME'	=> 'POE::Filter::Bzip2',
			  'PREREQ_PM' => {
							  'POE'    => 0.3501,
							  'Compress::Bzip2' => 2.08,
							  'Carp' => 0,
							 },
			  'VERSION_FROM' => 'lib/POE/Filter/Bzip2.pm', # finds $VERSION
			  'dist' => { 'COMPRESS' => 'gzip --best' },
			 );

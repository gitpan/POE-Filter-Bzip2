#use ExtUtils::MakeMaker;
use inc::Module::Install;

license 'perl';
author 'Chris Williams <chris@bingosnet.co.uk>';

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

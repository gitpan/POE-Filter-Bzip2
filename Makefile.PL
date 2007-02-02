use inc::Module::Install;
name 'POE-Filter-Bzip2';
license 'perl';
author 'Chris Williams <chris@bingosnet.co.uk>';
version_from 'lib/POE/Filter/Bzip2.pm';
requires 'Carp' => 0;
requires 'POE' => 0.38;
requires 'Compress::Bzip2' => 2.08;
WriteAll();
